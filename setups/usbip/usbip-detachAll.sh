#!/usr/bin/bash

ports=( $(usbip port | sed -n 's/^Port \([0-9]\+\):.*$/\1/p') )

for port in "${ports[@]}"; do
    usbip detach --port $port
done

sleep 2
