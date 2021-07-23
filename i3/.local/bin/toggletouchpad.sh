#!/bin/bash
sc=$(command -v synclient)
if [ ! -z "$sc" ]
then

        if synclient -l | grep "TouchpadOff .*=.*0" ; then
            synclient TouchpadOff=1 ;
        else
            synclient TouchpadOff=0 ;
        fi
fi


# Toggle touchpad status
# Using libinput and xinput

# Use xinput list and do a search for touchpads. Then get the first one and get its name.
xi=$(command -v xinput)
if [ ! -z "$xi" ]
then
        device=$(xinput list | grep -i touchpad | head -n1 | grep -o 'id=[0-9]*' | tr -dc '0-9')

        # If it was activated disable it and if it wasn't disable it
        [[ "$(xinput list-props "$device" | grep -P ".*Device Enabled.*\K.(?=$)" -o)" == "1" ]] &&
            xinput disable "$device" ||
            xinput enable "$device"
fi
