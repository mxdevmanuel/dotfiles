#!/bin/bash
cd ~/Imágenes/Wallpapers
ls | rofi -dmenu -p "Wallpapers" |awk '{print ENVIRON["PWD"] "/" $1}' | xargs feh --bg-fill --randomize --recursive

