#!/usr/bin/env python3

import os
import sys


def main():
    pacman_version = os.popen('pacman -Q linux').read().split(' ')[1]
    current_version = os.popen('uname -r').read().split(' ')[0]
    # print(pacman_version.strip())
    # print(current_version.strip())

    if normalize(pacman_version)  == normalize(current_version):
        print('no')
        sys.exit(0)
    else:
        print('yes')
        sys.exit(1)


def normalize(s) -> str:
    return s.replace('-', '').replace('.', '')


if __name__ == "__main__":
    main()
