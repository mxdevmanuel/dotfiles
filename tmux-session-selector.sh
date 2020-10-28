#!/usr/bin/env bash

ssession=$(tmux ls | awk '{print $1}' | tr -d ":" | dmenu -p "sessions")

status=$?

if test $status -eq 0
then
        kitty /usr/bin/tmux a -t "$ssession" &
        disown $!
fi

