#!/usr/bin/env bash

# Portability with bash
export HOSTNAME="${HOST}"

[[ ! -d ~/.zfunctions ]] && mkdir ~/.zfunctions
fpath=( ~/.zfunctions $fpath )
