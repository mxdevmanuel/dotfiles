#!/usr/bin/env zsh

if [[ -v NVM_DIR ]]; then
	exit 2
else
	pre=$(env)

	[ `alias | grep nvm | wc -l` != 0 ] && unalias nvm

	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

	post=$(env)

	res=$(diff <(echo "$pre") <(echo "$post") | grep "^>" | sed "s/^>\s//")

	echo "$res"
fi

