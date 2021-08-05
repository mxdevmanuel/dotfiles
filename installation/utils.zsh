#!/usr/bin/env zsh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
YELLOW_BG='\033[0;33m'
NC='\033[0m' # No color
BOLD='\u001b[1m'
ND='\u001b[0m' # No decoration

function log_error() {
	echo -e "${RED}Error:${NC} ${1}"
}
function log_warning() {
	echo -e "${YELLOW}Warning:${NC} ${1}"
}
function log_success() {
	echo -e "${GREEN}${1}:${NC} ${2}"
}

function run_reflector(){
	local ref=$(which reflector)
	if [[ ! -x $ref ]]
	then
		log_error "Unable to find reflector"
		return 10
	fi

	log_success "Reflector" "will attempt to get optimal mirrors"
	reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

	if [[ "$!" != "0" ]]
	then
		log_error "Unable to run reflector, installation may proceed"
	fi
}
