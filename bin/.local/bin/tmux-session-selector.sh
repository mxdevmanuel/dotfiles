#!/usr/bin/env zsh

if [[ -z "$SWAYSOCK" ]]
then
	COMMAND="dmenu"
else
	COMMAND="wofi --dmenu"
fi

SESSION=$(tmux ls | perl -pe 's/:.*$//' | $COMMAND -p "sessions")

status=$?

if test $status -eq 0
then
        kitty /usr/bin/tmux a -t "$SESSION" &
        disown $!
fi
