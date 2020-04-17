#!/bin/bash

SESSION=$(tmux ls | perl -pe 's/:.*$//' | dmenu)

if [ ! -z '$SESSION' ]
then
        kitty /usr/bin/tmux a -t "$SESSION" &
        disown $!
fi

