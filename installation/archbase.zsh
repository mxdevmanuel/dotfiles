#!/usr/bin/env zsh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
YELLOW_BG='\033[0;33m'
NC='\033[0m' # No Color
BOLD='\u001b[1m'
ND='\u001b[0m'


function log_error() {
	echo -e "${RED}Error:${NC} ${1}"
}
function log_warning() {
	echo -e "${YELLOW}Warning:${NC} ${1}"
}
function log_success() {
	echo -e "${GREEN}${1}:${NC} ${2}"
}
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

echo -e "${YELLOW_BG} Will begin installation if you are not connected to the internet,  please connect${NC}"
vared -p "Wish to get a shell to connect to the internet(y/N)? " -c internetdrop
if [[ "${internetdrop}" == "y" ]]
then
	zsh
fi

# Check secondary scripts are present 
if [[ ! -f archroot.zsh ]] || [[ ! -f packages.txt ]]
then
	log_error "Ensure ${BOLD}archroot.zsh${ND}, ${BOLD}packages.txt${ND} and ${BOLD}archuser.zsh${ND} are present in the current directory"
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


log_warning "You will be dropped into cfdisk to perform custom partitioning. Minimum 3 partitions need to be created root, home and efi"

vared -p "Continue?(y/N)" -c tmp

if [[ "${tmp}" != "y" ]]
then
	log_success "Finished" "Aborted by user"
	exit 4
fi

# Backup partitions
sfdisk -d $device > /tmp/part.dump

# Drop into interactive disk partition utility
cfdisk $device

# Extract partitions from device
partstmp=$( fdisk -l $device | grep -E '^\/dev' | awk '{print $1, $5}'  ) 

partnumber=$(echo $partnumber | wc -l)

# Select partitions to install

# Select efi partition
export bootpart=$( whiptail --title "Block devices" --menu "Select partition for /efi" 0 0 0 $(echo $partstmp | grep -Ev "boot|rpmb|loop" | tac | sed ':a;N;$!ba;s/\n/ /g') 3>&1 1>&2 2>&3 )

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


dformat "/" $rootpart
dformat "/home" $homepart

echo -e "${GREEN}Creating mounting points...${NC}"
echo -e "${GREEN}Mounting devices...${NC}"

#first mount root to create structure inside device
mount $rootpart /mnt

mkdir -p /mnt/efi
mkdir -p /mnt/home

mount $bootpart /mnt/efi
mount $homepart /mnt/home


log_success "Reflector" "will attempt to get optimal mirrors"
reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

if [[ "$!" != "0" ]]
then
	log_error "Unable to run reflector, installation may proceed"
fi

log_success "Pacstrap" "installing base system"
pacstrap /mnt base linux linux-firmware btrfs-progs zsh

log_success "Disks" "Generating fstab"

genfstab -U /mnt >> /mnt/etc/fstab

cp archroot.zsh packages.txt /mnt/root


arch-chroot /mnt zsh < /root/archroot.zsh
