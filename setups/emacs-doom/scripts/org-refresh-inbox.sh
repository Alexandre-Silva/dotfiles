#!/usr/bin/env sh

# Refresh open inbox type org buffers

set -e

# If emacs isn't running, we start a temporary daemon, solely for this window.
if ! emacsclient --suppress-output --eval nil 2>/dev/null; then
  echo "No Emacs daemon/server is available! Nothing to refresh..."
  exit 0
fi

# Fix incompatible terminals that cause odd 'not a valid terminal' errors
[ "$TERM" = "alacritty" ] && export TERM=xterm-256color

# Non-daemon servers flicker a lot if frames are created from terminal, so we do
# it internally instead.
emacsclient -a "" \
  -e "(cl-loop for file-path in '(\"~/Documents/org/Inbox-PC.org\" \"Documents/org/Inbox-orgzly_.org\")
           if (find-buffer-visiting file-path)
           do (kill-buffer (find-buffer-visiting file-path))))"
