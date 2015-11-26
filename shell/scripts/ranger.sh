#!/bin/sh

# Start new ranger instance only if it's not running in current shell
if [ -z "$RANGER_LEVEL" ]
then
    ranger
else
    exit
fi

export RANGERCD=true
$TERMCMD
