#!/usr/bin/env bash

op=$( echo -e " Poweroff\n Reboot\n Suspend\n Hibernate\n Lock\n Logout" | wofi -i --dmenu | awk '{print tolower($2)}' )

case $op in 
        poweroff)
                ;&
        reboot)
                ;&
	hibernate)
		;&
        suspend)
                systemctl $op
                ;;
        lock)
		swaylock
                ;;
        logout)
                swaymsg exit
                ;;
esac
