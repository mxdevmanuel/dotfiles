#!/usr/bin/env bash
OPTION=$(printf "copy\nupdate\nedit\ndiff\nexit" | dmenu -p "todotxt" )

case $OPTION in 
        "copy")
                echo "copy"
                cp ~/Todo/todo.txt /tmp/todotxt-local.bckp
                rclone sync drive:/todo ~/Todo
                notify-send Todo.txt 'Local todo.txt updated' --icon='/usr/share/icons/Papirus/48x48/apps/gnome-todo.svg' -t 3000\
                ;;
                
        "update")
                echo "update"
                rclone copy drive:/todo/todo.txt /tmp/todotxt-remote.bckp
                rclone sync ~/Todo drive:/todo
                notify-send Todo.txt 'Remote todo.txt synced' --icon='/usr/share/icons/Papirus/48x48/apps/gnome-todo.svg' -t 3000\
                ;;
        "edit")
                echo "edit"
                termite -e "zsh -c \"vim /home/$USER/Todo/todo.txt &&  notify-send Todo.txt 'Remeber to sync the todo file' --icon='/usr/share/icons/Papirus/48x48/apps/gnome-todo.svg' -t 3000\"" &
                disown %1
                ;;
        "diff")
                echo "diff"
                DIFFOPTION=$(printf "remote\nlocal\nexit" | dmenu -p "diff" )
                if [ "$DIFFOPTION" == "remote" ]
                then
                        termite -e "diff /tmp/todotxt-remote.bckp /home/$USER/Todo/todo.txt" --hold &
                        disown %1
                elif [ "$DIFFOPTION" == "local" ]
                then
                        termite -e "diff /tmp/todotxt-local.bckp /home/$USER/Todo/todo.txt" --hold &
                        disown %1
                fi
                ;;
        "exit")
                echo "exit"
                ;;
esac

