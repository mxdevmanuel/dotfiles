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

if [[ -z "$1" ]]
then
	log_error "No path provided"
	exit 5
fi

if [[ "${PWD}" == "$1" ]]
then
	log_error "Must be run from a different directory"
	exit 4
fi

local orig_env=`printenv`
pushd $1

local new_env=`printenv`

local extract=`diff <(echo $orig_env) <(echo $new_env) | grep -E '^>' | grep -vE 'DIRENV|OLDPWD|PWD' | tr -d '> '`

local funame=".projectvars"

touch $funame
truncate --size=0 $funame

echo $extract > $funame
