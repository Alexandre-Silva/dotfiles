#!/bin/sh
#
#from https://wiki.archlinux.org/index.php/Ranger#Start_a_shell_from_ranger

export AUTOCD="$(realpath "$1")"
$SHELL
