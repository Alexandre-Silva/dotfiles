#!/bin/sh

tmpfile=$(mktemp /tmp/autoflake.XXXXXX)
cat >"$tmpfile"
autoflake "$@" --in-place "$tmpfile"
cat "$tmpfile"
rm "$tmpfile"
