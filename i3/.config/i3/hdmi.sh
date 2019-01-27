#!/bin/bash

hdmi_active="$(cat /sys/class/drm/card0/*HDMI*/status | grep '^connected')"

echo $hdmi_active

if [[ "$hdmi_active" == "connected" ]]; then
	echo "Si"
	exec /home/manuel/.screenlayout/i3.sh
else
	exec /home/manuel/.screenlayout/single.sh
	echo "No"
fi
