#!/usr/bin/env bash
set -e

trim() {
    local PID=$1
    test -n "$PID" || { echo "Need PID on the cmdline" > /dev/stderr; exit 1; }

    local before=`ps -h -p $PID -O rss  | awk '{print $2}'`
    gdb --batch-silent --eval-command 'print (int)malloc_trim(0)' -p $PID
    local after=`ps -h -p $PID -O rss  | awk '{print $2}'`

    echo "Pid: $PID"
    echo "before: $before"
    echo "after: $after"
    echo "freed: $(($before - $after))"
    echo ""
}

for arg in "$@"; do
    trim $arg
done
