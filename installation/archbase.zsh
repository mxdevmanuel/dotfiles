#!/usr/bin/env zsh

# sources colors, log_*, run_reflector
source ${0:h}/utils.zsh

function dformat(){
	unset confi
	vared -p "Wish to format partition $1:$2 : (Y/n)" -c confi

	if [[ "${confi}" == "n" ]]
	then
		log_warning "Continuing" "Aborted by user"
		return 5
	fi

	unset formopt
	vared -p "Wish to format partition as: 1)btrfs 2)ext4 default)Do not format: " -c formopt

	case $formopt in 
		1)
			mkfs.btrfs $2
			if [[ "$?" != "0" ]]
			then
				unset forceopt
				vared -p "Existing btrfs found in device, wish to force formatting?Y/n: " -c forceopt
				[[ "$forceopt" != "n" ]] && mkfs.btrfs -f $2
			else
				log_success "Formatted" "Partition $2 formatted to btrfs" 
			fi
			;;
		2)
			mkfs.ext4 $2
			log_success "Formatted" "Partition $2 formatted to btrfs" 
			;;
		*)
			log_warning "Partition will not be formatted"
		;;
	esac
}
function prompt_swap(){
	vared -p "Wish to select a swap partition: (y/N)" -c wishswap

	if [[ "${wishswap}" == "y" ]]
	then
		partstmp=$( echo $partstmp | grep -v $rootpart )
		swappart=$( whiptail --title "Block devices" --menu "Select partition for swap" 0 0 0 $(echo $partstmp | grep -Ev "boot|rpmb|loop" | tac | sed ':a;N;$!ba;s/\n/ /g') 3>&1 1>&2 2>&3 )
		mkswap $swappart
		swapon $swappart
	fi
}

timedatectl set-ntp true

echo -e "${YELLOW_BG} Will begin installation, will need internet for installation and if you got these files without git please install git beforehand${NC}"

# Check secondary scripts are present 
if [[ ! -f utils.zsh ]]
then
	log_error "Not found ${BOLD}utils.zsh${ND}. This script must be run from the ${BOLD}installation${ND} directory."
	exit 1
fi

# Select installation disk
blktmp=$(mktemp)
whiptail --title "Block devices" --menu "Select installation device" 0 0 0 $(lsblk --nodeps --paths --list --noheadings --sort=size --output name,size | grep -Ev "boot|rpmb|loop" | tac | sed ':a;N;$!ba;s/\n/ /g') 2>$blktmp
device=`cat $blktmp`

echo -e "${GREEN}Selected:${NC} $device"

if [[ -z "$device" ]]
then
	log_error "Must select an installation device, try running this script again"
	exit 2
fi

if [[ ! -d /sys/firmware/efi/efivars ]]
then

	log_error "This script assumes an EFI install please boot in the proper mode"
	exit 3
fi

log_warning "You will be dropped into partition tool to perform custom partitioning. Minimum 3 partitions need to be created root, home and efi"

vared -p "Continue?(Y/n)" -c tmp

if [[ "${tmp}" != "n" ]]
then
	# Backup partitions
	sfdisk -d $device > /tmp/part.dump

	# Drop into interactive disk partition utility
	echo "Select partition tool"
	vared -p "1) cfdisk 2) gdisk 3)zsh " -c cparttool
	case $cparttool in
		1)
			cfdisk $device
			;;
		2)
			gdisk $device
			;;
		*)
			zsh
			;;
	esac

fi
# Extract partitions from device
partstmp=$( fdisk -l $device | grep -E '^\/dev' | awk '{print $1, $5}'  ) 

partnumber=$(echo $partnumber | wc -l)

# Select partitions to install

# Select boot partition
export bootpart=$( whiptail --title "Block devices" --menu "Select partition for /boot" 0 0 0 $(echo $partstmp | grep -Ev "boot|rpmb|loop" | tac | sed ':a;N;$!ba;s/\n/ /g') 3>&1 1>&2 2>&3 )

echo -e "Boot: ${bootpart}"

partstmp=$( echo $partstmp | grep -v $bootpart )

export rootpart=$( whiptail --title "Block devices" --menu "Select partition for /" 0 0 0 $(echo $partstmp | grep -Ev "boot|rpmb|loop" | tac | sed ':a;N;$!ba;s/\n/ /g') 3>&1 1>&2 2>&3 )

echo -e "Root: ${rootpart}"
partstmp=$( echo $partstmp | grep -v $rootpart )

export homepart=$( whiptail --title "Block devices" --menu "Select partition for /home" 0 0 0 $(echo $partstmp | grep -Ev "boot|rpmb|loop" | tac | sed ':a;N;$!ba;s/\n/ /g') 3>&1 1>&2 2>&3 )

echo -e "Home: ${homepart}"

askforswap=$(( $partnumber > 3))
if [[ "$askforswap" != "0" ]]
then
	prompt_swap
fi

mkfs.fat -F32 $bootpart

dformat "/" $rootpart
dformat "/home" $homepart

echo -e "${GREEN}Creating mounting points...${NC}"
echo -e "${GREEN}Mounting devices...${NC}"

#first mount root to create structure inside device
mount $rootpart /mnt

mkdir -p /mnt/boot
mkdir -p /mnt/home

mount $bootpart /mnt/boot
mount $homepart /mnt/home

run_reflector

log_success "Pacstrap" "installing base system"
pacstrap /mnt base linux linux-firmware btrfs-progs zsh

log_success "Disks" "Generating fstab"

genfstab -U /mnt > /mnt/etc/fstab

log_success "Copying files to installation's root directory"
cp -R $(git rev-parse --show-toplevel) /mnt/root

log_success "Copying resolv.conf"
mv /mnt/etc/resolv.conf /mnt/etc/resolv.conf.backup

cp /etc/resolv.conf /mnt/etc/

vared -p "Wish to chroot now: (Y/n)" -c cchroot

if [[ "${cchroot}" == "n" ]]
then
	log_warning "Exiting" "bye"
	exit 0 
fi

arch-chroot /mnt /usr/bin/zsh /root/dotfiles/installation/archroot.zsh

log_success "Set root password"
arch-chroot /mnt passwd

log_success "Set user password"
arch-chroot /mnt passwd $(cat /mnt/root/user)

vared -p "Wish to reboot now: (Y/n)" -c creboot

if [[ "${creboot}" == "n" ]]
then
	log_warning "Exiting" "bye"
	exit 0 
else
	reboot
fi


