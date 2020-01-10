#!/usr/bin/env bash
bluetoothctl devices  | rofi -dmenu | awk '{print $2}' | xargs -I% termite -t "rofi-btctl" --hold -e 'bluetoothctl connect %'
