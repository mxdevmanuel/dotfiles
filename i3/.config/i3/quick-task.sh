#!/bin/bash

grep -vi "^x" ~/todo.txt | rofi -dmenu -p tasks
