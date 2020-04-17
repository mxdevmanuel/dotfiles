#!/bin/env bash

if [[ -t 1 ]]; then
        ip -oneline -4 addr | awk '{print $2, $4}'| fzf | awk '{print $2}' | perl -pe 's/\/\d+//' | tee /dev/tty | xclip -i 
else
        ip -oneline -4 addr | awk '{print $2, $4}'| dmenu | awk '{print $2}' | perl -pe 's/\/\d+//' | xclip -i 
fi


