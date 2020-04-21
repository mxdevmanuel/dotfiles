#!/bin/env bash

TOOL=dmenu
if [[ -t 1 ]]; then
        TOOL=fzf
fi

ADDR=$(ip -oneline -4 addr | awk '{print $2, $4}'| $TOOL | awk '{print $2}' | perl -pe 's/\/\d+//')

echo $ADDR | xclip -i -selection clipboard
xdotool type --clearmodifiers "$ADDR"
