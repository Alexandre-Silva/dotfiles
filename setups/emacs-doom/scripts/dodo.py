#!/usr/bin/env python3

import glob
import os
from itertools import chain
from pathlib import Path

OUTPUT_DIR = '/tmp/emacs-export'
ORG_DIR = os.getcwd()
ORG_DIRS = ['./', './people/']
ORG_FILES = list(chain.from_iterable([glob.glob(d + '*.org') for d in ORG_DIRS]))
CALDAV_URL = os.environ.get('CALDAV_URL')

if CALDAV_URL is None:
    print("WARNING: CALDAV_URL is unset")


def task_create_output_dir():
    return {
        'actions': [
            f'mkdir --parent {OUTPUT_DIR}',
            f'touch {OUTPUT_DIR}/.sentinel',
        ],
        'targets': [OUTPUT_DIR, f"{OUTPUT_DIR}/.sentinel"],
    }


def task_update_roam_id_locations():
    return {
        'actions': [
            'doomscript ~/dotfiles/setups/emacs-doom/scripts/update-roam-ids.el',
        ],
        'file_dep': ORG_FILES,
    }


def task_convert_org_to_ics():
    for org_file in ORG_FILES:
        ics_file = (Path(OUTPUT_DIR) / org_file).with_suffix('.ics')
        ics_parent = ics_file.parent
        yield {
            'name':
            org_file,
            'actions': [
                f"mkdir --parent {ics_parent}" if not ics_parent.is_dir() else '',
                [
                    "emacs",
                    "-l",
                    "~/.config/emacs/early-init",
                    "-batch",
                    "--eval",
                    f'(setq export-in-directory "{ORG_DIR}" export-out-dir "{OUTPUT_DIR}" export-file "{org_file}")',
                    "-l",
                    "~/dotfiles/setups/emacs-doom/scripts/ics-export.el",
                ],
            ],
            'file_dep': [org_file, f"{OUTPUT_DIR}/.sentinel"],
            'task_dep': ['update_roam_id_locations'],
            'targets': [ics_file],
            'verbosity':
            2,
        }


def task_push_caldav():
    ics_files = list(map(path_org2ics, ORG_FILES))

    actions = [
        f'calutil.py clean --live {CALDAV_URL}',
    ]
    for file in ics_files:
        action = f"calutil.py convert '{file}' '{CALDAV_URL}'"
        actions.append(action)

    return {
        'actions': actions,
        'file_dep': ics_files,
        'verbosity': 2,
    }


def path_org2ics(fp) -> Path:
    return (Path(OUTPUT_DIR) / fp).with_suffix('.ics')
