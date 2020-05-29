#!/bin/bash

SESSION=$(tmux ls | perl -pe 's/:.*$//' | dmenu)

status=$?

if test $status -eq 0
then
        kitty /usr/bin/tmux a -t "$SESSION" &
        disown $!
fi
