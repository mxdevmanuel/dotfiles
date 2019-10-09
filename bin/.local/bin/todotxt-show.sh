#!/usr/bin/env bash
OUTPUT=$(grep -v "^x"  ~/Todo/todo.txt | sort | rofi -dmenu -p tasks)

if [ $? ==  10 ]
then
        echo $OUTPUT | todotxt-markdone.sh
elif [ ! -z "$OUTPUT" ]
then
        termite -e "zsh -c \"vim /home/$USER/Todo/todo.txt &&  notify-send Todo.txt 'Remeber to sync the todo file' --icon='/usr/share/icons/Papirus/48x48/apps/gnome-todo.svg' -t 3000\"" &
        disown %1
fi
