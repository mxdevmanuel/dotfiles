#!/usr/bin/env bash
OPTION=$(printf "copy\nupdate\nedit\nexit" | dmenu -p "todotxt" )

case $OPTION in 
        "copy")
                echo "copy"
                rclone sync drive:/todo ~/Todo
                notify-send Todo.txt 'Local todo.txt updated' --icon='/usr/share/icons/Papirus/48x48/apps/gnome-todo.svg' -t 3000\
                ;;
                
        "update")
                echo "update"
                rclone sync ~/Todo drive:/todo
                notify-send Todo.txt 'Remote todo.txt synced' --icon='/usr/share/icons/Papirus/48x48/apps/gnome-todo.svg' -t 3000\
                ;;
        "edit")
                echo "edit"
                termite -e "zsh -c \"vim /home/$USER/Todo/todo.txt &&  notify-send Todo.txt 'Remeber to sync the todo file' --icon='/usr/share/icons/Papirus/48x48/apps/gnome-todo.svg' -t 3000\"" &
                disown %1
                ;;
        "exit")
                echo "exit"
                ;;
esac

