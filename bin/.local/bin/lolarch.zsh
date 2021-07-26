#!/usr/bin/env zsh

clear 

local LOLPATH=$HOME/Envs/tests/bin

if [[ -x $LOLPATH/lolcat ]]
then
	paste -d '' <(cat $HOME/.ascii/arch.txt | $LOLPATH/lolcat ) <(neofetch --stdout | sed "s,:.*,$(tput sgr0)&,")
else
	neofetch
fi

echo -ne '\n\t' ; for i in $(seq 1 16); do echo -en `tput setab $i` '   ' `tput sgr0`; done; echo -e ''
