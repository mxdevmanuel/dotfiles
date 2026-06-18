#!/usr/bin/env zsh
#
# Runs inside the chroot (from archbase.zsh). Profile-aware: a "desktop"
# profile sets up Hyprland (greetd, DHCP, laptop extras); a "server" profile
# sets up sshd with static networking and a minimal package/group set.
# The profile is selected from pkconfig.json (each entry has a "type" field).

# sources colors, log_*, run_reflector, set_timezone
BASE=${0:h}

source ${BASE}/utils.zsh

pacman -Syu dialog jq archlinux-keyring reflector --noconfirm

# Configure a systemd-networkd interface. mode = dhcp (default) | static.
function configure_network_iface(){
	local name=$1
	local metric=$2
	local mode=${3:-dhcp}

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

	local netfile=/etc/systemd/network/$name.network

	if [[ -f $netfile ]]
	then
		truncate --size=0 $netfile
	fi

	echo "[Match]" >> $netfile
	echo "Name=$iface" >> $netfile
	echo "" >> $netfile
	echo "[Network]" >> $netfile

	if [[ "$mode" == "static" ]]
	then
		vared -p "IPv4: " -c ipv4
		echo "Address=${ipv4}" >> $netfile
		vared -p "IPv6: " -c ipv6
		echo "Address=${ipv6}" >> $netfile
		vared -p "Gateway: " -c gateway
		echo "Gateway=${gateway}" >> $netfile
		echo "Gateway=fe80::1" >> $netfile
		vared -p "IPv4 DNS: " -c ipv4dns
		echo "DNS=${ipv4dns}" >> $netfile
		vared -p "IPv6 DNS: " -c ipv6dns
		echo "DNS=${ipv6dns}" >> $netfile
	else
		echo "DHCP=yes" >> $netfile
		echo "" >> $netfile
		echo "[DHCP]" >> $netfile
		echo "RouteMetric=$metric" >> $netfile
	fi
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

			grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

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
				echo "options root=$uuid rw"
			} > /boot/loader/entries/arch.conf

			popd
		;;
	esac
}

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

while true
do
	echo "Configurations:"
	jq ".[].name" ${BASE}/pkconfig.json | tr -d "\"" |  awk '{print NR,$0}'
	vared -p "Select a configuration: (default=1) " -c cconf

	if [[ -z "$cconf" ]]
	then
		cconf=0
	else
		cconf=$(( $cconf - 1 ))
	fi

	pkgfile=$(jq -r ".[${cconf}].file // empty" ${BASE}/pkconfig.json)
	ptype=$(jq -r ".[${cconf}].type // \"desktop\"" ${BASE}/pkconfig.json)

	if (( cconf >= 0 )) && [[ -n "$pkgfile" ]] && [[ -f ${BASE}/${pkgfile} ]]
	then
		break
	fi

	log_warning "Invalid selection" "pick a number from the list"
	unset cconf
done

log_success "Profile" "selected ${pkgfile} (type: ${ptype})"

pacman -Syu $(grep -vE '^\s*#|^\s*$' ${BASE}/${pkgfile}) $ucode --noconfirm

systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service

if [[ "$ptype" == "server" ]]
then
	systemctl enable sshd.service
else
	vared -p "Is this a laptop?y/N " -c laptop
	if [[ "$laptop" == "y" ]]
	then
		if [[ -s ${BASE}/laptop.pkgs ]]
		then
			log_success "Laptop" "installing laptop-only packages"
			pacman -S --needed --noconfirm $(grep -vE '^\s*#|^\s*$' ${BASE}/laptop.pkgs)
		fi

		systemctl enable iwd.service

		vared -p "Is this a ThinkPad? (y/N): " -c thinkpad
		if [[ "$thinkpad" == "y" ]]
		then
			setup_thinkpad
		fi
	fi
fi


echo "Setting useful symlinks"
command -v nvim &>/dev/null && ln -sf /usr/bin/nvim /usr/bin/vim
command -v doas &>/dev/null && ln -sf /usr/bin/doas /usr/bin/sudo

if [[ -d ${BASE}/../system/profile ]]
then
	echo "Adding profile scripts"
	cp ${BASE}/../system/profile/* /etc/profile.d/
fi

# Hyprland uses greetd as login manager (desktop profile only).
if [[ "$ptype" != "server" ]] && [[ "$pkgfile" == "hyprlandconf.pkgs" ]] && [[ -f ${BASE}/../system/greetd/config.toml ]]
then
	log_success "greetd" "installing config and enabling service"
	mkdir -p /etc/greetd
	cp ${BASE}/../system/greetd/config.toml /etc/greetd/config.toml
	systemctl enable greetd.service
fi

if [[ "$ptype" == "server" ]]
then
	echo "Configure wired network (static)"
	configure_network_iface "10-wired" 10 static
else
	echo "Configure wired network (DHCP)"
	configure_network_iface "10-wired" 10

	vared -p "Wish to configure network interface (special for wireless)? Y/n: " -c ciface
	if [[ "$ciface" != "n" ]]
	then
		configure_network_iface "20-wireless" 20
	fi
fi

echo -e "${GREEN}Creating Initramfs${NC}"
mkinitcpio -P

echo -e "${GREEN}Installing bootloader${NC}"
install_bootloader $ucode

vared -p "Enter username for primary user" -c puser

if [[ "$ptype" == "server" ]]
then
	useradd -m -G systemd-journal,wheel -s /usr/bin/zsh $puser
else
	useradd -m -G systemd-journal,video,uucp,lp,audio,wheel,optical -s /usr/bin/zsh $puser
fi

echo "Added user to sudo/doas file"
printf "permit persist %s\n" "$puser" > /etc/doas.conf

# Persist username so archbase can passwd it after chroot exits
echo -n "$puser" > /root/.installer_user

log_success "Copying dotfiles" "if you are ${BOLD}me${ND} remember to set remote to SSH and install your SSH key ${BOLD}(${ND}do that part even if you are not me${BOLD})${ND}"

cp -R /root/dotfiles /home/${puser}/.dotfiles
chown -R ${puser}:${puser} /home/${puser}/.dotfiles

echo "you will find these in ${GREEN}${BOLD}/home/$puser/.dotfiles${ND}${NC}"
echo "you may remove this copy of dotfiles just run 'rm -rf /root/dotfiles'"

# Post-reboot user script depends on the profile.
if [[ "$ptype" == "server" ]]
then
	userscript="archserveruser.zsh"
else
	userscript="archuser.zsh"
fi

# Passwd PSA
echo -e "${YELLOW} ####IMPORTANT#### ${NC}"
echo "Root and $puser passwords will be set after this chroot exits."
echo "After reboot, log in as $puser and run:"
echo "  ~/.dotfiles/installation/${userscript}"
