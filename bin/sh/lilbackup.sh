#!/usr/bin/bash
set -euo pipefail
IFS=$'\n\t'

NUM_BACKUPS=5

RSYNC_ARGS=(--archive --hard-links --delete)

RUNLOG() {
    echo "RUNNING:" "$@" >&2
    "$@"
}

RSYNC() { RUNLOG rsync "${RSYNC_ARGS[@]}" "$@"; }
LN()    { RUNLOG ln --force --symbolic "$@"; }


lilbackup() {
    local backupDirRoot="$1"; shift
    local sourcedirs=("$@")

    backupDirRoot="$(realpath "$backupDirRoot")"

    if [[ ! -d "$backupDirRoot" ]]; then
        echo "ERROR: backup root dir not found:" "$backupDirRoot" >&2
        exit 1
    fi

    local backupDirAll=( "$backupDirRoot/"* )
    local backupDirOld="${backupDirAll[-1]}" # selects newest dir (name is ordered by timestamp)
    local backupDirNew="$backupDirRoot/$(date -u +'%Y-%m-%d_%H:%M:%S')" # gens new dir with timetamp
    local backupDirNewestLn="$backupDirRoot/.newest" # symbolic link to newest dir

    local extra_args=()
    if [[ -d "$backupDirOld" ]]; then
        extra_args+=( --link-dest="$backupDirOld" )
    fi

    for sourcedir in "${sourcedirs[@]}"; do
        sourcedir="$(realpath "$sourcedir")"
        RSYNC "${extra_args[@]}" "$sourcedir" "$backupDirNew"
    done

    echo "GC: removing old backups"
    # regen list due to new backup dir
    backupDirAll=( "$backupDirRoot/"* )
    while [[ ${#backupDirAll[@]} -gt $NUM_BACKUPS ]]; do
        local backupDirOldest="${backupDirAll[0]}" # selects oldest dir
        echo rm --recursive --force "$backupDirOldest"
        rm --recursive --force "$backupDirOldest"
        backupDirAll=( "$backupDirRoot/"* )
    done

    pacman -Q --explicit | awk '{print $1}' > "$backupDirNew/pacman.pcklist.txt"

    if [[ -e "$backupDirNewestLn" ]]; then rm --force "$backupDirNewestLn"; fi
    LN "$backupDirNew" "$backupDirNewestLn"
}


lilbackup "$@"
