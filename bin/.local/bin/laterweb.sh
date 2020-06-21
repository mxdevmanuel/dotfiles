#!/usr/bin/env bash

py=~/Envs/fordots/bin/python
backend=~/.local/share/later-pages.py

case $1 in
        "add")
                url=$(xclip -o)
                echo $url | dmenu -p "url"
                if [[ $? -eq 0 ]]
                then
                        $py $backend add $url
                else
                        notify-send "Laterweb" "adding webpage aborted"
                fi
                ;;
        "open")
                selected=$($py $backend list | rofi -dmenu)
                if [[ $? -eq 0 ]]
                then
                        select-browser.sh $($py $backend get --id $( echo $selected | awk '{print $1}' ))
                fi
                ;;
        "remove")
                selected=$($py $backend list | rofi -dmenu)
                if [[ $? -eq 0 ]]
                then
                        $py $backend remove --id $( echo $selected | awk '{print $1}' )
                fi
                ;;

esac
