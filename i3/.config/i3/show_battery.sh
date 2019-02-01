#!/bin/bash

acpi | awk '{print $5 " " $6}' | xargs notify-send -t 5000 -i none
