#!/bin/bash

# This script when run, selects the X window currently in focus and kills it

X_id="$(xprop -root -notype | sed -n '/^_NET_ACTIVE_WINDOW/ s/^.*# *\|\,.*$//g p')"

xkill -id $X_id
