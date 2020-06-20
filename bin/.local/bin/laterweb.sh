#!/usr/bin/env bash

py=~/Envs/fordots/bin/python

case $1 in
        "add")
                url=$(xclip -o)
                echo $url | dmenu -p "url"
                if [[ $? -eq 0 ]]
                then
                        $py ~/.local/share/later-pages.py add $url
                else
                        notify-send "Laterweb" "adding webpage aborted"
                fi
                ;;
esac
