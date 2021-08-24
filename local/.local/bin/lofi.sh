#!/usr/bin/env bash

CUSTOM_PYTHON=~/Envs/tests/bin/python

env DEVELOPER_KEY=$(pass gmail/apikey) $CUSTOM_PYTHON ~/.local/share/lofi/lofi.py --q "$@"
