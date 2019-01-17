#!/usr/bin/env bash

img=/tmp/i3lock.png

scrot $img
if [ ! -z "$1" ]; then
	echo "$1"
	convert $img -pointsize 48 -fill white -font DejaVu-Sans-Mono -gravity center -caption "Hello" $img 
else
	convert $img -blur 0x3 $img
fi
i3lock -i $img
#gpicview $img