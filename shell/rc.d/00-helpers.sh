try_source() {
    local file=''
    for file in "$@"; do
        [ -r "${file}" ] && . "${file}"
    done
}


# verifies if $1 existe in array on $2
# in python it would be if $1 in $2..; something
containsElement ()
{
    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1
}
