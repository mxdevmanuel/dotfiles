#!/usr/bin/env bash
status=$(grep 'workspace_auto_back_and_forth' ~/.config/i3/config | gawk '{ print $2 }')
echo "$status"
if [[ "$status" =  "yes" ]]; then
	sed -ie s/workspace_auto_back_and_forth\ yes/workspace_auto_back_and_forth\ no/ ~/.config/i3/config
	i3-msg 'reload' && notify-send "Back and forth: "
elif [[ "$status" = "no" ]]; then
	sed -ie s/workspace_auto_back_and_forth\ no/workspace_auto_back_and_forth\ yes/ ~/.config/i3/config
	i3-msg 'reload' && notify-send "Back and forth: "
fi
