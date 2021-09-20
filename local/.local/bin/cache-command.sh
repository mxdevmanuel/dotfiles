#!/usr/bin/env bash

CACHE_DIR=~/.local/share/cache-command

[[ ! -d $CACHE_DIR ]] && mkdir -p $CACHE_DIR && echo "Creating $CACHE_DIR"

usm=`echo $@ | md5sum | awk '{ print $1 }'`

cache_file="${CACHE_DIR}/${usm}"
if [[ -f $cache_file ]]
then
	cat $cache_file
else
	eval $@ | tee $cache_file
fi
