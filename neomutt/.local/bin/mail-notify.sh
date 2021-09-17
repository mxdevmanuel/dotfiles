#!/usr/bin/env bash

MAILDIR=~/.mail
TIMEFILE=~/.config/neomutt/.mailsynclastrun

_notify(){
	[[ ! -d $MAILDIR ]] && exit 0

	pushd $MAILDIR > /dev/null	

	local inboxes=$(find . -type d -path "**/Inbox/new" -or -path "**/Inbox/cur" | paste -sd " ")

	[[ -z "$inboxes" ]] && exit 0

	local news=`eval "find ${inboxes} -type f -newer ${TIMEFILE}" \
		| awk 'BEGIN { FS = "/" } ; { print $2 }' | sort | uniq -c`
	
	[[ ! -z "$news" ]] && notify-send --icon=$HOME/.local/share/icons/Gruvbox-Material-Dark/64x64/apps/email.svg 'New Email' "${news}" -t 10000 

	touch $TIMEFILE
}

_notify
