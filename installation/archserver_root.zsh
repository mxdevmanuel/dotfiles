#!/usr/bin/env zsh

# sources colors, log_*, run_reflector
BASE=${0:h}

source ${BASE}/utils.zsh

pacman -Syu dialog jq archlinux-keyring reflector --noconfirm

function select_timezone(){
	 ln -s /usr/share/zoneinfo/America/Mexico_City /etc/localtime
}

function configure_network_iface(){
	local ifaces=$(ip addr show | grep -vi "loopback" | grep -wi "up" | awk '{ match($0, /^[0-9]+:\s(.*):/, arr); if(arr[1] != "") print arr[1] }'
)
	local count=$(echo $ifaces | wc -l)
	if (( $count > 1 ))
	then
		iface=$(dialog --stdout --title "Areas" --menu "Select interface" 0 0 0 $(echo $ifaces | awk '{print $1,toupper($1)}' | paste -sd " " ))
	elif (( $count > 0 ))
		iface=$ifaces
	then
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

}

function install_bootloader(){
	vared -p "Select bootloader: 1) systemd-boot 2) grub (default=1)" -c selectboot

case $selectboot in 
	2)
		if [[ ! -x /usr/bin/grub-install ]]
		then
			pacman -S grub os-prober
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
		
		echo -ne "default arch\ntimeout 4\nconsole-mode max\neditor no" > /boot/loader/loader.conf


		local rootpart=$(lsblk -l -p | grep "/$" | awk '{ print $1 }')
		local uuid=$(blkid $rootpart | grep -Eo "\bUUID=\"[a-z0-9\-]*\"" | tr -d '"')

		echo -e "title Arch Linux\nlinux /vmlinuz-linux" > /boot/loader/entries/arch.conf

		if [[ ! -z "$2" ]]
		then
			echo "initrd /$1.img" >> /boot/loader/entries/arch.conf
		fi

		echo -n "initrd /initramfs-linux.img\noptions root=\"$uuid\" rw" >> /boot/loader/entries/arch.conf

		pushd
	;;
esac
}

select_timezone

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

pacman -Syu openssh $ucode --noconfirm

systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
systemctl enable ssh.service


echo "Setting useful symlinks"
ln -s /usr/bin/nvim /usr/bin/vim
ln -s /usr/bin/doas /usr/bin/sudo


echo "Configure wired network"
configure_network_iface "10-wired" 10

echo -e "${GREEN}Creating Initramfs${NC}"
mkinitcpio -P

echo -e "${GREEN}Installing bootloader${NC}"
install_bootloader $ucode

vared -p "Enter username for primary user" -c puser

useradd -m -G systemd-journal,video,uucp,lp,audio,wheel,optical -s /usr/bin/zsh $puser

echo "Added user to sudo/doas file"
echo -n "permit persist $puser\n" > /etc/doas.conf

log_success "Copying dotfiles" "if you are ${BOLD}me${ND} remember to set remote to SSH and install your SSH key ${BOLD}(${ND}do that part even if you are not me${BOLD})${ND}"

cp -R $(git rev-parse --show-toplevel) /home/${puser}/.dotfiles
chown -R ${puser}:${puser} /home/${puser}/.dotfiles

echo "you will find these in ${GREEN}${BOLD}/home/$puser/.dotfiles${ND}${NC}"
echo "you may remove this copy of dotfiles just run 'rm /root/dotfiles'"

# Passwd PSA
echo -e "${YELLOW} ####IMPORTANT#### ${NC}"
echo "Run 'passwd' with no arguments to set the root password"
echo "and run 'passwd $puser' to set $puser's password"
echo "then run 'su $puser' to access as $puser"
echo "and if you want to continue run ${BOLD}archuser.zsh${ND}"
