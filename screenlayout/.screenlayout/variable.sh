#!/usr/bin/env bash

if [ "$MACHINE_ENV" == "desktop" ]
then
        $HOME/.screenlayout/bspwm.sh
fi

# Laptop specifics
if [ "$MACHINE_ENV" == "laptop" ]
then
        $HOME/.screenlayout/i3.sh
fi
