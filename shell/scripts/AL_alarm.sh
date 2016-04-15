#!/bin/bash -

function BELL() { while true; do play -q /usr/share/sounds/freedesktop/stereo/bell.oga; sleep 5; done }

BELL &
DISPLAY=:0 Xdialog --timeout "$1" --msgbox "$2" 0 0
kill %1
