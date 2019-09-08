#!/bin/bash

DONE=$(grep -i "^x" ~/todo.txt | wc -l)
DUE=$(wc -l < ~/todo.txt)

printf "%d / %d" $DONE $DUE

