#!/bin/sh

usermodmap=$HOME/.Xmodmap
xbindkeysrc=$HOME/.xbindkeysrc

setxkbmap -layout us -variant altgr-intl
setxkbmap -option keypad:pointerkeys

[ -f "$xbindkeysrc" ] && hash xbindkeys &>/dev/null && xbindkeys
[ -f "$usermodmap" ] && xmodmap "$usermodmap"

xset r rate 200 45
