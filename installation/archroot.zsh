#!/usr/bin/env zsh

# sources colors, log_*, run_reflector, set_timezone
BASE=${0:h}

source ${BASE}/utils.zsh

pacman -Syu dialog jq archlinux-keyring reflector --noconfirm

function configure_network_iface(){
	local ifaces=$(ip addr show | grep -vi "loopback" | grep -wi "up" | awk '{ match($0, /^[0-9]+:\s(.*):/, arr); if(arr[1] != "") print arr[1] }')
	local count=$(echo $ifaces | wc -l)
	local iface
	if (( $count > 1 ))
	then
		iface=$(dialog --stdout --title "Areas" --menu "Select interface" 0 0 0 $(echo $ifaces | awk '{print $1,toupper($1)}' | paste -sd " "))
	elif (( $count > 0 ))
	then
		iface=$ifaces
	else
		echo "No interface is up"
		return 21
	fi

	local netfile=/etc/systemd/network/$1.network

	if [[ -f $netfile ]]
	then
		truncate --size=0 $netfile
	fi

	echo "[Match]" >> $netfile
	echo "Name=$iface" >> $netfile
	echo "" >> $netfile
	echo "[Network]" >> $netfile
	echo "DHCP=yes" >> $netfile
	echo "" >> $netfile
	echo "[DHCP]" >> $netfile
	echo "RouteMetric=$2" >> $netfile
}

function install_bootloader(){
	local ucode=$1
	vared -p "Select bootloader: 1) systemd-boot 2) grub (default=1)" -c selectboot

	case $selectboot in
		2)
			if [[ ! -x /usr/bin/grub-install ]]
			then
				pacman -S --noconfirm grub os-prober
			fi

			grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB

			vared -p "Wish customize bootloader installation e.g enable os-prober? y/N: " -c custgrub
			if [[ "$custgrub" == "y" ]]
			then
				# TODO: offer alternate system detection
				echo "No automatic process available yet, will be prompt to zsh"
				zsh
			fi

			grub-mkconfig -o /boot/grub/grub.cfg
			;;
		*)
			pushd /

			bootctl install --esp-path=/boot

			echo -e "default arch\ntimeout 4\nconsole-mode max\neditor no" > /boot/loader/loader.conf

			local rootpart=$(lsblk -l -p | grep "/$" | awk '{ print $1 }')
			local uuid=$(blkid $rootpart | grep -Eo "\bUUID=\"[a-z0-9\-]*\"" | tr -d '"')

			{
				echo "title Arch Linux"
				echo "linux /vmlinuz-linux"
				if [[ -n "$ucode" ]]
				then
					echo "initrd /${ucode}.img"
				fi
				echo "initrd /initramfs-linux.img"
				echo "options root=\"$uuid\" rw"
			} > /boot/loader/entries/arch.conf

			popd
		;;
	esac
}

vared -p "Is this a laptop?y/N " -c laptop

set_timezone

echo -e "${GREEN}Setting locale${NC}"
sed -i '/^#en_US.UTF-8/s/^#//' /etc/locale.gen

locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo -e "${GREEN}Setting hosts${NC}"
vared -p "Enter hostname: " -c hostname
echo $hostname > /etc/hostname

echo -e "127.0.0.1\tlocalhost\n::1\tlocalhost\n127.0.1.1\t$hostname.localdomain\t$hostname" > /etc/hosts

run_reflector

systemctl enable reflector.timer

vared -p "Select appropriate ucode(Use your CPU's brand) 1)intel 2)amd *)no ucode : " -c cucode

case $cucode in
	1)
		ucode=intel-ucode
		;;
	2)
		ucode=amd-ucode
		;;
	*)
		log_warning "No ucode will be installed"
	;;
esac


echo -e "${GREEN}Installing packages${NC}"

echo "Configurations:"
jq ".[].name" ${BASE}/pkconfig.json | tr -d "\"" |  awk '{print NR,$0}'
vared -p "Select a configuration: (default=1) " -c cconf

if [[ -z "$cconf" ]]
then
	cconf=0
else
	cconf=$(( $cconf - 1 ))
fi

pkgfile=$(jq -r ".[${cconf}].file" ${BASE}/pkconfig.json)

pacman -Syu $(cat ${BASE}/${pkgfile}) $ucode --noconfirm

systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service

if [[ ! -z "$laptop" ]]
then
	systemctl enable iwd.service
fi


echo "Setting useful symlinks"
ln -sf /usr/bin/nvim /usr/bin/vim
ln -sf /usr/bin/doas /usr/bin/sudo

if [[ -d ${BASE}/../system/profile ]]
then
	echo "Adding profile scripts"
	cp ${BASE}/../system/profile/* /etc/profile.d/
fi

# Hyprland uses greetd as login manager; sway/i3 use tty1 autoexec.
if [[ "$pkgfile" == "hyprlandconf.pkgs" ]] && [[ -f ${BASE}/../system/greetd/config.toml ]]
then
	log_success "greetd" "installing config and enabling service"
	mkdir -p /etc/greetd
	cp ${BASE}/../system/greetd/config.toml /etc/greetd/config.toml
	systemctl enable greetd.service
fi

echo "Configure wired network"
configure_network_iface "10-wired" 10

vared -p "Wish to configure network interface (special for wireless)? Y/n: " -c ciface
if [[ "$ciface" != "n" ]]
then
	configure_network_iface "20-wireless" 20
fi

echo -e "${GREEN}Creating Initramfs${NC}"
mkinitcpio -P

echo -e "${GREEN}Installing bootloader${NC}"
install_bootloader $ucode

vared -p "Enter username for primary user" -c puser

useradd -m -G systemd-journal,video,uucp,lp,audio,wheel,optical -s /usr/bin/zsh $puser

echo "Added user to sudo/doas file"
printf "permit persist %s\n" "$puser" > /etc/doas.conf

# Persist username so archbase can passwd it after chroot exits
echo -n "$puser" > /root/.installer_user

log_success "Copying dotfiles" "if you are ${BOLD}me${ND} remember to set remote to SSH and install your SSH key ${BOLD}(${ND}do that part even if you are not me${BOLD})${ND}"

cp -R /root/dotfiles /home/${puser}/.dotfiles
chown -R ${puser}:${puser} /home/${puser}/.dotfiles

echo "you will find these in ${GREEN}${BOLD}/home/$puser/.dotfiles${ND}${NC}"
echo "you may remove this copy of dotfiles just run 'rm -rf /root/dotfiles'"

# Passwd PSA
echo -e "${YELLOW} ####IMPORTANT#### ${NC}"
echo "Root and $puser passwords will be set after this chroot exits."
echo "After reboot, log in as $puser and run:"
echo "  ~/.dotfiles/installation/archuser.zsh"
