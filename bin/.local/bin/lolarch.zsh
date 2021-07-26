#!/usr/bin/env zsh

clear 

local LOLPATH=$HOME/Envs/tests/bin

local termcolors=""
for i in $(seq 1 16)
do
	 termcolors+=$( echo -en `tput setab $i` '   ' `tput sgr0` )
	 [[ $i == 8 ]] && termcolors+="\n"
done

if [[ -x $LOLPATH/lolcat ]]
then
	paste -d '\ ' <(cat $HOME/.ascii/arch.txt | $LOLPATH/lolcat ) <(neofetch --stdout | sed -e "s,:.*,$(tput sgr0)&," -e '$a'"$termcolors") | tr -d "%"
else
	neofetch
fi

