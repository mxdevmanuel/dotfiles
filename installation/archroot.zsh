#!/usr/bin/env zsh

# sources colors, log_*, run_reflector
source ${0:h}/utils.zsh

pacman -Syu dialog --noconfirm

function select_timezone(){
	r=$(timedatectl list-timezones | awk -F'/' '{ print $1, toupper(substr($1,0,2)) }' | uniq)
	timebase=$( dialog --stdout --title "Areas" --menu "Select area" 0 0 0 $(echo $r | sed ':a;N;$!ba;s/\n/ /g') )
	if [[ -z "$timebase" ]]
	then
		select_timezone
		return 5
	fi
	byarea=$(timedatectl list-timezones | grep "$timebase" | awk -F'/' '{ print $0, toupper(substr($2,0,2)) }' | uniq)
	timezone=$( dialog --stdout --title "Areas" --menu "Select area" 0 0 0 $(echo $byarea | sed ':a;N;$!ba;s/\n/ /g') )

	ln -s /usr/share/zoneinfo/$timezone /etc/localtime
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

	local netfile=/etc/systemd/network/20-wireless.network

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
	echo "RouteMetric=20" >> $netfile
		
}

vared -p "Is this a laptop?y/N " -c laptop

select_timezone

echo -e "${GREEN}Setting locale${NC}"
sed -i '/^#en_US.UTF-8/s/^#//' /etc/locale.gen

locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo -e "${GREEN}Setting hosts${NC}"
vared -p "Enter hostname: " -c hostname
echo $hostname > /etc/hostname

echo -e "127.0.0.1\tlocalhost\n::1\tlocalhost\n127.0.1.1\t$hostname.localdomain\t$hostname" > /etc/hosts

vared -p "Select appropriate ucode(Use your CPU's brand) 1)intel 2)amd default)no ucode :" -c ucode

case $ucode in 
	1)
		pacman -S intel-ucode --noconfirm
		;;
	2)
		pacman -S amd-ucode --noconfirm
		;;
	*)
		log_warning "No ucode will be installed"
	;;
esac

run_reflector

echo -e "${GREEN}Installing packages${NC}"

pacman -Syu $(cat /root/packages.txt) --noconfirm

systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service

if [[ ! -z "$laptop" ]]
then
	systemctl enable iwd.service
fi

echo "Added user to sudo/doas file"
echo -n "permit $puser as root" > /etc/doas.conf

echo "Setting useful symlinks"
ln -s /usr/bin/nvim /usr/bin/vim
ln -s /usr/bin/doas /usr/bin/sudo

if [[ -d ../system/profile ]]
then
	echo "Adding profile scripts"
	cp ../system/profile/* /etc/profile.d/
fi

vared -p "Wish to configure network interface (special for wireless)? Y/n: " -c ciface
if [[ "$ciface" != "n" ]]
then
	configure_network_iface
fi

echo -e "${GREEN}Creating Initramfs${NC}"
mkinitcpio -P

echo -e "${GREEN}Installing bootloader${NC}"
grub-install --target=x86_64-efi --efi-directory=efi --bootloader-id=GRUB

vared -p "Wish customize bootloader installation e.g enable os-prober? y/N: " -c custgrub
if [[ "$custgrub" == "y" ]]
then
	# TODO: offer alternate system detection
	echo "No automatic process available yet, will be prompt to zsh"
	zsh
fi

grub-mkconfig -o /boot/grub/grub.cfg

vared -p "Enter username for primary user" -c puser

useradd -m -G systemd-journal,video,uucp,lp,audio,wheel,optical -s zsh $puser

# Passwd PSA
echo -e "${YELLOW} ####IMPORTANT#### ${NC}"
echo "Run 'passwd' with no arguments to set the root password"
echo "and run 'passwd $puser' to set $puser's password"
