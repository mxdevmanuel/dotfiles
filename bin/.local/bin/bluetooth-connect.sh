#!/usr/bin/env bash
notify-send "Disconnecting"
bluetoothctl disconnect
bluetoothctl devices  | rofi -dmenu | awk '{print $2}' | xargs -I% termite -t "rofi-btctl" --hold -e 'bluetoothctl connect %'
