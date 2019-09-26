#!/bin/bash

wget -q --tries=10 --timeout=20 --spider http://google.com
if [[ $? -eq 0 ]]; then
        echo "Online"
        rclone sync drive:/wallpapers ~/Imágenes/Wallpapers -P
        wget "https://source.unsplash.com/featured/1920x1080/daily/?landscape" -O ~/Imágenes/Wallpapers/Unsplash/$(date -d "today" +"%Y%m%d").jpg
        wget "https://source.unsplash.com/featured/1920x1080/daily/?architecture" -O ~/Imágenes/Wallpapers/Architecture/$(date -d "today" +"%Y%m%d").jpg
        wget "https://source.unsplash.com/featured/1920x1080/daily/?universe" -O ~/Imágenes/Wallpapers/Universe/$(date -d "today" +"%Y%m%d").jpg
        rsync --remove-source-files -a ~/Imágenes/toSync/ ~/Imágenes/Wallpapers
        rmlint ~/Imágenes/Wallpapers
        bash rmlint.sh -p -d
        rm rmlint.*
        rclone sync ~/Imágenes/Wallpapers drive:/wallpapers  -P
else
        echo "Offline"
fi
