#!/usr/bin/bash
set -euo pipefail
IFS=$'\n\t'

NUM_BACKUPS=5

RSYNC_ARGS=(--archive --hard-links --delete)

RSYNC() {
    echo "RUNNING:" rsync "${RSYNC_ARGS[@]}" "$@"
    rsync "${RSYNC_ARGS[@]}" "$@"
}

LN(){
    echo "RUNNING:" ln --force --symbolic "$@"
    ln --force --symbolic "$@"
}


lilbackup() {
    local sourcedir="$1"
    local backupDirRoot="$2"

    sourcedir="$(realpath "$sourcedir")"
    backupDirRoot="$(realpath "$backupDirRoot")"

    local backupDirAll=( "$backupDirRoot/"* )
    local backupDirOld="${backupDirAll[-1]}" # selects newest dir (name is ordered by timestamp)
    local backupDirNew="$backupDirRoot/$(date -u +'%Y-%m-%d_%H:%M:%S')" # gens new dir with timetamp
    local backupDirNewestLn="$backupDirRoot/.newest" # symbolic link to newest dir

    local extra_args=()
    if [[ -d "$backupDirOld" ]]; then
        extra_args+=( --link-dest="$backupDirOld" )
    fi

    RSYNC "${extra_args[@]}" "$sourcedir" "$backupDirNew"

    echo "GC: removing old backups"
    # regen list due to new backup dir
    backupDirAll=( "$backupDirRoot/"* )
    while [[ ${#backupDirAll[@]} -gt $NUM_BACKUPS ]]; do
        local backupDirOldest="${backupDirAll[0]}" # selects oldest dir
        echo rm --recursive --force "$backupDirOldest"
        rm --recursive --force "$backupDirOldest"
        backupDirAll=( "$backupDirRoot/"* )
    done

    if [[ -e "$backupDirNewestLn" ]]; then rm --force "$backupDirNewestLn"; fi
    LN "$backupDirNew" "$backupDirNewestLn"
}


lilbackup "$@"
