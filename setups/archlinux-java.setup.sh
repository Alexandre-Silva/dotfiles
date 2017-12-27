#!/usr/bin/bash

packages=(
    pm:jdk8-openjdk
    pm:openjdk8-doc
    pm:openjdk8-src
)

st_profile() {
    # Configs from arch wik
    export _JAVA_OPTIONS="${_JAVA_OPTIONS:-}"' -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
}
