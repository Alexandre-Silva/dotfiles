if hash trash-put 2>/dev/null; then
  if [[ "$(du-usage "$XDG_DATA_HOME/Trash/")" -gt "$((256 * 1024 * 1024))" ]] && [[ ! -e "$XDG_RUNTIME_DIR/motd-trash" ]]; then
    echo "WARNING: $XDG_DATA_HOME/Trash/ is using $(du-usageh "$XDG_DATA_HOME/Trash/")"
    touch "$XDG_RUNTIME_DIR/motd-trash"
  fi
fi
