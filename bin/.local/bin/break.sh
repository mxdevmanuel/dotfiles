#!/bin/bash
betterlockscreen -l dim &
sleep 300
aplay ~/.local/bin/gong.wav
pkill i3lock
