#!/usr/bin/env bash
TODO=$(grep "^[^x]*" ~/Todo/todo.txt | grep -oh "@\S*" | sort | uniq -c | awk {'print $2":"$1}' | paste -sd " " -)
echo $TODO
