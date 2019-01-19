#!/usr/bin/env bash
status=$(grep 'focus_follows_mouse' ~/.config/i3/config | gawk '{ print $2 }')
echo "$status"
if [[ "$status" =  "yes" ]]; then
	sed -ie s/focus_follows_mouse\ yes/focus_follows_mouse\ no/ ~/.config/i3/config
	i3-msg 'reload' && notify-send 'Follow focus: '
elif [[ "$status" = "no" ]]; then
	sed -ie s/focus_follows_mouse\ no/focus_follows_mouse\ yes/ ~/.config/i3/config
	i3-msg 'reload' && notify-send 'Follow focus: '
fi
