#!/usr/bin/env python3

import sys
import traceback
from typing import List, Tuple

import PySimpleGUI as sg  # noqa
import sh


def main():
    rows = do_fetch_rows()
    window = build_window(rows)

    while True:
        event, values = window.read()
        # print()
        # print(event, values)

        if event in (sg.WIN_CLOSED, 'Exit', 'Cancel'):
            break

        if event in ('Submit', ):
            rows_selected = []
            burn = False  # if true must change default in checkbox

            for i in range(len(rows)):
                key = f'-ROW.{i}-'
                if key in window.AllKeysDict:
                    if window[key].get():
                        rows_selected.append(i)

            burn = window['-burn-'].get()
            preview = window['-preview-'].get()

            paste = merge_to_paste(rows, rows_selected)

            if len(paste) == 0:
                sg.popup('No text to paste (press any key to close):',
                         any_key_closes=True)
                sys.exit(1)

            if preview:
                sg.set_options(text_justification='left')
                sg.popup('Test to pasted (press any key to close):',
                         paste,
                         any_key_closes=True)

            print('Submiting')
            window.hide()
            do_clip2pastebin(paste, burn)
            break

        if event.startswith('toggle-row:'):
            _, key = event.split(':')
            toggle_checkbox(window, f'-{key}-')

        if event.startswith('toggle-burn:'):
            toggle_checkbox(window, '-burn-')

        if event.startswith('toggle-preview:'):
            toggle_checkbox(window, '-preview-')

    window.close()


def toggle_checkbox(window, key):
    el = window[key]
    value = not el.get()
    el.update(value=value)
    return value


def fetch_rows() -> List[Tuple[int, str, str]]:
    '''

    (row_id, text preview, text)
    '''

    out = []
    for i in range(9):
        row = sh.copyq('read', i)

        row_text = str(row)
        if len(row_text) == 0:
            continue

        if '\n' in row_text:
            idx = row_text.find('\n')
            row_text = row_text[:idx] + ' (...)'

        # print(i, f'> {row_text}')
        out.append((i, row_text, str(row)))

    return out


def do_fetch_rows():
    try:
        rows = fetch_rows()
        # print(rows)
        return rows

    except Exception as e:
        err = traceback.format_exc()
        # sg.Window('Error', [[sg.T(err)], [sg.B('Exit')]]).read(close=True)
        sg.popup('error', err)
        sys.exit(1)


def build_window(rows) -> sg.Window:
    sg.set_options(text_justification='right')

    rows_checkboxes = [[
        sg.Checkbox(f'{i+1}: {row_short}', size=(40, 1), key=f'-ROW.{i}-')
    ] for i, (_, row_short, _) in enumerate(rows)]

    # yapf: disable
    layout = [
        [sg.Text('Select rows to merge into post (1-9 to toggle)', font=('Helvetica', 16))],
        *rows_checkboxes,

        [sg.Text('_'  * 100, size=(65, 1))],
        [sg.Text('Options', font=('Helvetica', 15), justification='left')],
        [sg.Checkbox('burn (b)', size=(12, 1), key='-burn-'),],
        [sg.Checkbox('preview (p)', size=(12, 1), key='-preview-'),],

        [sg.Text('_'  * 100, size=(65, 1))],
        [sg.Submit(), sg.Cancel()],
    ]
    # yapf: enable

    window = sg.Window('Machine Learning Front End',
                       layout,
                       font=("Helvetica", 12),
                       finalize=True)

    for i, _ in enumerate(rows):
        window.bind(f'{i+1}', f'toggle-row:ROW.{i}')

    window.bind('b', 'toggle-burn:')
    window.bind('p', 'toggle-preview:')
    window.bind('<Return>', 'Submit')
    window.bind('<Escape>', 'Cancel')

    return window


def merge_to_paste(rows, rows_selected: List[int]) -> str:
    row_ids = rows_selected
    row_ids.sort()

    rows_full = [row for idx, _, row in rows if idx in row_ids]
    paste = '\n'.join(rows_full)

    return paste


def do_clip2pastebin(paste: str, burn: bool):
    try:
        out = pastebin_create(paste, burn=burn)

        outs = str(out).strip()
        sh.copyq('copy', outs)
        sh.notify_send('Paste successful', 'url in clipboard')
        print(out)
        # sg.popup('You entered', out)
        # element.TKButton.bind('<Return>', element._ReturnKeyHandler)

    except Exception as e:
        err = traceback.format_exc()
        sg.popup('error', err)


def pastebin_create(paste, expire='1hour', burn: bool = False) -> str:
    '''
    returns the url of the paste

    expire must be in: 5min, 10min, 1hour, 1day, 1week, 1month, 1year, never,
    '''

    args = []
    args += ['-expire', expire]
    if burn:
        args += ['-burn-after-reading']

    out = sh.privatebin(*args, _in=paste)
    out = out.strip()
    return out


if __name__ == "__main__":
    main()
