#!/usr/bin/env bash
status=$(grep 'own_window_type' ~/.config/conky/conky.conf | gawk '{ print $2 }')
file=~/.config/conky/conky.conf
echo "$status"
if [[ "$status" =  "override" ]]; then
	sed -ie s/own_window_type\ override/own_window_type\ normal/ "$file"
	touch "$file"
elif [[ "$status" = "normal" ]]; then
	sed -ie s/own_window_type\ normal/own_window_type\ override/ "$file"
	touch "$file"
fi
