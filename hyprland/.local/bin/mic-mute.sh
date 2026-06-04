#!/usr/bin/env bash
wpctl set-mute @DEFAULT_SOURCE@ toggle
muted=$(wpctl get-volume @DEFAULT_SOURCE@ | grep -c MUTED)
if [[ $muted == 1 ]]; then
	swayosd-client --custom-icon microphone-sensitivity-muted-symbolic --custom-message 'Microphone'
else
	swayosd-client --custom-icon microphone-sensitivity-high-symbolic --custom-message 'Microphone'
fi
