#!/usr/bin/env bash
OUTPUT=$(grep -v "^x"  ~/Todo/todo.txt | sort | rofi -dmenu -p tasks)
if [ ! -z "$OUTPUT" ]
then
        termite -e "vim /home/$USER/Todo/todo.txt" &
        disown %1
fi
