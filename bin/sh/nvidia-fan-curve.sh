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

trap clean_up SIGHUP SIGINT SIGTERM

#logfile=$HOME/.cache/nvidia_fan_curve.log
step=10s

temps=( 45 50 60 80 100 ) # C°
speed=( 5  20 50 80 90  ) # %

prepare

log '-------- Start --------' 
while true; do

    gputemp=$(nvidia-settings -q GPUCoreTemp | awk -F ":" 'NR==2{print $3}' | sed 's/[^0-9]*//g')
    newfanspeed=0

    for i in $(seq 0 $((${#temps[@]} - 1))); do
        if [ "$gputemp" -eq "${temps[$i]}" ]; then
            newfanspeed="${speed[$i]}"
            break
        elif [ "$gputemp" -lt "${temps[$i]}" ]; then
            newfanspeed=$(calc_curve)
            break
        fi
    done

    nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=${newfanspeed}" >/dev/null || clean_up
    log "temp: ${gputemp}C\tfan: ${newfanspeed}%"

    sleep $step 

done

clean_up # Should not reach here


