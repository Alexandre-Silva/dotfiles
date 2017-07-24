try_source() {
    file="$1"
    [ -r "${file}" ] && . "${file}"
    unset file
}
