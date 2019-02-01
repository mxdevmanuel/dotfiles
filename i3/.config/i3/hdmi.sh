#!/bin/bash
export DISPLAY=:0
export XAUTHORITY=/home/manuel/.Xauthority
export XDG_RUNTIME_DIR=/run/user/$(id -u)

hdmi_active="$(cat /sys/class/drm/card0/*HDMI*/status | grep '^connected')"

echo $hdmi_active

if [[ "$hdmi_active" == "connected" ]]; then
	notify-send -i "/usr/share/icons/Paper/16x16/devices/computer.png" -t 3000 "HDMI: connected"
	exec /home/manuel/.screenlayout/i3.sh &
else
	notify-send -i "/usr/share/icons/Paper/16x16/devices/computer.png" -t 3000 "HDMI: disconnected"
	exec /home/manuel/.screenlayout/single.sh &
fi
