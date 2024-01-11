#!/bin/bash

pkill xbindkeys

usermodmap=$HOME/.Xmodmap
usermodmaplocal=$HOME/.Xmodmap_local
xbindkeysrc=$HOME/.xbindkeysrc

xset r rate 200 45

numlockx on

setxkbmap -layout us -variant altgr-intl
#setxkbmap -layout pt
# setxkbmap -option keypad:pointerkeys

[ -f "$usermodmap" ] && xmodmap "$usermodmap"
[ -f "$usermodmaplocal" ] && xmodmap "$usermodmaplocal"
[ -f "$xbindkeysrc" ] && hash xbindkeys &>/dev/null && xbindkeys

