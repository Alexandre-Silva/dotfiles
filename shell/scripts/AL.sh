#!/bin/bash -
#===============================================================================
#
#          FILE: AL.sh
#
#          Usage:
#          	AL [@] delay [message timeout]]
#          	where @ denotes absolute time
#          	If not absolute time:
#          	   delay is in minutes
#              timeout is in seconds
#
#           Defaults to 5 minutes delay: "ALARM"
#           Message defaults to "ALARM"
#
#   DESCRIPTION: Issue an alarm using at and xmessage.
#                at executes AL_alarm at given time which includes a sound.
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (),
#  ORGANIZATION:
#       CREATED: 28-10-2015 10:11
#      REVISION:  ---
#===============================================================================
#

PREFIX="now + "
SUFFIX=" minutes"
DELAY=15
MSG='ALARM'
#TO=60
TO=0

function BELL() { while true; do play -q /usr/share/sounds/freedesktop/stereo/bell.oga; sleep 2; done }

if [ "$1" == "-h" ] || [ "$1" == "--help" ]
then
  echo "AL - Issue an alarm"
  echo "     AL [delay (in minutes) [message [timeout (in seconds)]]]"
  echo "   or"
  echo "     AL @ time [message [timeout (in seconds)]]"
  echo "   defaults: delay=15 message=\"ALARM\" timeout=60"
  exit
fi

if [ "$1" == "@" ]
then
  PREFIX=""
  SUFFIX=""
  shift
fi

if [ "$1"x != "x" ]
then
  DELAY=$1
  if [ "$2"x != "x" ]
  then
    MSG="$2"
    if [ "$3"x != "x" ]
    then
      TO=$3
    fi
  fi
fi

# Xdialog Version
#echo "$BELL &; DISPLAY=:0 Xdialog --timeout $TO --msgbox "\"$MSG\"" 0 0; kill %1" | at $PREFIX$DELAY$SUFFIX
echo "AL_alarm $TO $MSG" | at $PREFIX$DELAY$SUFFIX

# xmessage version
# echo "BELL;DISPLAY=:0 xmessage -button OK -default OK -timeout $TO ""$MSG""" | at $PREFIX$DELAY$SUFFIX

if [ "$PREFIX"x != "x" ]
then
    echo "Alarm \""$MSG"\" in $PREFIX$DELAY$SUFFIX using timeout $TO seconds"
else
    echo "Alarm \""$MSG"\" at $DELAY using timeout $TO seconds"
fi
