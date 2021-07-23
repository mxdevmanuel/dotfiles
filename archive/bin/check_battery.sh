#!/bin/bash
export DISPLAY=:0
export XAUTHORITY=/home/manuel/.Xauthority
export XDG_RUNTIME_DIR=/run/user/$(id -u)
ACPI=$(acpi)

STATUS=$(echo $ACPI | grep 'Discharging')
BATTERY_LEVEL=$(echo $ACPI | awk '{ print $4 } ' | sed 's/[^[:digit:]]//g' | bc)

BATTERY_DANGER=$(echo $BATTERY_LEVEL | awk '{print $1 < 8}' | bc)

SLEEPTIME=$(xprintidle | xargs printf "%s > 60000\n" | bc)

if [ -n "${STATUS}" ]
then
	if [ "$BATTERY_DANGER" -ne "0" ]
	then
		notify-send -u critical -i "/usr/share/icons/Paper/16x16/status/xfce-battery-critical.png" -t 3000 "Hibernando el sistema"
	elif [ "$BATTERY_LEVEL" -le "32" ]
	then
		notify-send -u critical -i "/usr/share/icons/Paper/16x16/status/xfce-battery-critical.png" -t 3000 $(echo $ACPI | awk '{ print $5 " " $6 }')

	elif [ "$SLEEPTIME" -eq "1" ]
	then
		echo $SLEEPTIME
		systemctl suspend
	fi
fi

