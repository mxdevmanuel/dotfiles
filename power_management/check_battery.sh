#!/bin/bash
export DISPLAY=:0
export XAUTHORITY=/home/manuel/.Xauthority
export XDG_RUNTIME_DIR=/run/user/$(id -u)
ACPI=$(acpi)

STATUS=$(echo $ACPI | grep 'Discharging')
echo $STATUS > idk.sh
echo $USER >> idk.sh
BATTERY_LEVEL=$(echo $ACPI | awk '{ print $4 } ' | sed 's/[^[:digit:]]//g' | bc)
echo $BATTERY_LEVEL >> idk.sh

BATTERY_DANGER=$(echo $BATTERY_LEVEL | awk '{print $1 < 55}' | bc)
echo $BATTERY_DANGER >> idk.sh

if [[ -n "${STATUS}" ]]
then
	if [[ "$BATTERY_DANGER" -ne "0"  ]]
	then
		echo "DANGER" >> idk.sh
		notify-send "Alert" -u critical
		sudo systemctl suspend
	elif [[ "$BATTERY_LEVEL" -le "60" ]]
	then
		echo "ALERT" >> idk.sh
		notify-send "$(echo $ACPI | awk '{ print $5 " " $6 }')" -i battery-low
	fi
fi

