#!/bin/bash
export DISPLAY=:0
export XAUTHORITY=/home/manuel/.Xauthority
export XDG_RUNTIME_DIR=/run/user/$(id -u)
ACPI=$(acpi)

STATUS=$(echo $ACPI | grep 'Discharging')
BATTERY_LEVEL=$(echo $ACPI | awk '{ print $4 } ' | sed 's/[^[:digit:]]//g' | bc)

BATTERY_DANGER=$(echo $BATTERY_LEVEL | awk '{print $1 < 5}' | bc)

if [[ -n "${STATUS}" ]]
then
	if [[ "$BATTERY_DANGER" -ne "0"  ]]
	then
		notify-send -u critical -i "/usr/share/icons/Paper/16x16/status/xfce-battery-critical.png" -t 3000 "Hibernando el sistema"
		sudo systemctl hibernate
	elif [[ "$BATTERY_LEVEL" -le "10" ]]
	then
		notify-send -u critical -i "/usr/share/icons/Paper/16x16/status/xfce-battery-critical.png" -t 3000 $(echo $ACPI | awk '{ print $5 " " $6 }')
	fi
fi

