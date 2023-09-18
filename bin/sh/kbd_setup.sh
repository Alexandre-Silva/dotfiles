#!/bin/sh

usermodmap=$HOME/.Xmodmap
xbindkeysrc=$HOME/.xbindkeysrc

xset r rate 200 45

numlockx on

setxkbmap -layout us -variant altgr-intl
# setxkbmap -option keypad:pointerkeys

[ -f "$usermodmap" ] && xmodmap "$usermodmap"
[ -f "$xbindkeysrc" ] && hash xbindkeys &>/dev/null && xbindkeys

