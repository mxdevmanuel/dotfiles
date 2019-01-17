#!/usr/bin/env bash
hdmi_active="$(cat /sys/class/drm/card0/*HDMI*/status |grep '^connected')"
if [[ ! -z "$hdmi_active" ]]; then
	xrandr --output HDMI1 --mode 1920x1080 --pos 0x0 --rotate normal --output LVDS1 --primary --mode 1366x768 --pos 1920x312 --rotate normal --output VIRTUAL1 --off --output DP1 --off --output VGA1 --off
else
	xrandr --output HDMI1 --off --output LVDS1 --primary --mode 1366x768 --pos 0x0 --rotate normal --output VIRTUAL1 --off --output DP1 --off --output VGA1 --off
fi
