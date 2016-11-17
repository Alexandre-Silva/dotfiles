#!/bin/bash

function prepare {
    #Make sure to enable nvidia-xconfig --cool-bits=4
    nvidia-settings -a "GPUFanControlState=1" >&2 || clean_up
}

function clean_up {
    nvidia-settings -a "GPUFanControlState=0" >&2
    exit
}

function log {
    echo -e "$(date '+%F %R:%S')\t$@" #| tee -a "$logfile"
}

function calc_curve {
    if [ $i -eq 0 ];then
        echo 0
    else
        echo "${speed[$i-1]} + (${speed[$i]} - ${speed[$i-1]}) / ((${temps[$i]} - ${temps[$i-1]}) / ($gputemp - ${temps[$i-1]}))" | bc
    fi
}

function main {
    #logfile=$HOME/.cache/nvidia_fan_curve.log
    local step=5s

    local temp2speed_map=(
        # C° %
        45 5
        50 20
        60 50
        85 100
    )

    prepare

    log '-------- Start --------'
    while true; do

        gputemp=$(nvidia-settings -q GPUCoreTemp | awk -F ":" 'NR==2{print $3}' | sed 's/[^0-9]*//g')
        newfanspeed=$(temp2speed.py "${gputemp}" "${temp2speed_map[@]}")
        nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=${newfanspeed}" >/dev/null || clean_up

        log "temp: ${gputemp}C\tfan: ${newfanspeed}%"

        sleep $step
    done
}

trap clean_up SIGHUP SIGINT SIGTERM
main "$@"
clean_up # Should not reach here
