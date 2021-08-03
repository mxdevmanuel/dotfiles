#!/usr/bin/env zsh
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
YELLOW_BG='\033[0;33m'
NC='\033[0m' # No Color

function log_error() {
	echo -e "${RED}Error:${NC} ${1}"
}
function log_warning() {
	echo -e "${YELLOW}Warning:${NC} ${1}"
}
function log_success() {
	echo -e "${GREEN}${1}:${NC} ${2}"
}

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

echo -e "${GREEN}Installing packages${NC}"

pacman -Syu $(cat /root/packages.txt) --noconfirm

echo -e "${GREEN}Creating Initramfs${NC}"
mkinitcpio -P

echo -e "${GREEN}Installing bootloader${NC}"
grub-install --target=x86_64-efi --efi-directory=efi --bootloader-id=GRUB

# TODO: offer alternate system detection
grub-mkconfig -o /boot/grub/grub.cfg

vared -p "Enter username for primary user" -c puser

useradd -m -G systemd-journal,video,uucp,lp,audio,wheel,optical -s zsh $puser

# Passwd PSA
echo -e "${YELLOW} ####IMPORTANT#### ${NC}"
echo "Run 'passwd' with no arguments to set the root password"
echo "and run 'passwd $puser' to set $puser's password"
