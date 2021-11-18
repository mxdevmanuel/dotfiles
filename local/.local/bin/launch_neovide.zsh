#!/usr/bin/env zsh

read -r -d '' ascii_art << EOM
███╗░░██╗███████╗░█████╗░██╗░░░██╗██╗██████╗░███████╗
████╗░██║██╔════╝██╔══██╗██║░░░██║██║██╔══██╗██╔════╝
██╔██╗██║█████╗░░██║░░██║╚██╗░██╔╝██║██║░░██║█████╗░░
██║╚████║██╔══╝░░██║░░██║░╚████╔╝░██║██║░░██║██╔══╝░░
██║░╚███║███████╗╚█████╔╝░░╚██╔╝░░██║██████╔╝███████╗
╚═╝░░╚══╝╚══════╝░╚════╝░░░░╚═╝░░░╚═╝╚═════╝░╚══════╝
EOM

echo $ascii_art

pushd $HOME/Code

dirs=$(find ${PWD} -type d -and -name ".git" -exec dirname {} \;)

selection=$( echo "${dirs}\n${HOME}/.dotfiles" | fzf --height "50%" )

if [[ ! -z "$selection" ]]
then
	pushd $selection
else
	exit 1
fi

vared -p "Darkmode Y/n?" -c darkmode

if [[ "$darkmode" != "n" ]]
then
	export TIMETHEME=dark
fi

$HOME/.local/bin/neovide &

echo "launched" 
jobs 

disown
