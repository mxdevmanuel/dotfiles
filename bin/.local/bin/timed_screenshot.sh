#!/usr/bin/env bash
timetoss=$(dmenu -p "Seconds to ss" < /dev/null)

sleep $timetoss && flameshot gui
