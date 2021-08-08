#!/usr/bin/env zsh

if [[ -z "$SWAYSOCK" ]]
then
	COMMAND="dmenu"
else
	COMMAND="wofi --dmenu"
fi

SESSION=$(tmux ls | perl -pe 's/:.*$//' | eval $COMMAND -p "sessions")

local exitcode=$?

if test $exitcode -eq 0
then
        kitty /usr/bin/tmux a -t "$SESSION" &
        disown $!
fi
