#!/usr/bin/env zsh


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
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

# Select installation disk
blktmp="/tmp/blktmp$$"
whiptail --title "Block devices" --menu "Select installation device" 0 0 0 $(lsblk --nodeps --paths --list --noheadings --sort=size --output name,size | grep -Ev "boot|rpmb|loop" | tac | sed ':a;N;$!ba;s/\n/ /g') 2>$blktmp
device=`cat $blktmp`

echo -e "${GREEN}Selected:${NC} $device"

if [[ -z "$device" ]]
then
	log_error "Must select an installation device, try running this script again"
	exit 1
fi

if [[ ! -d /sys/firmware/efi/efivars ]]
then

	log_error "This script assumes an EFI install please boot in the proper mode"
	exit 2
fi


log_warning "You will be dropped into a shell to perform custom partitioning. Minimum 3 partitions need to be created root, home and efi"

vared -p "Continue?(y/N)" -c tmp

if [[ "${tmp}" != "y" ]]
then
	log_success "Finished" "Aborted by user"
	exit 3
fi


sfdisk -d $device > /tmp/part.dump

cfdisk $device

parts=$(fdisk -l $device | grep -E '^\/dev' | awk '{print $1, $5}')

echo $parts
