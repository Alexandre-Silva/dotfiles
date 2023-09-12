#!/usr/bin/env python3

'''
ENV vars that need to be specified:
- GTD_REFILE
- LOGSEQ_REFILE
'''

import os
import time
from dataclasses import dataclass

import dbus
import PySimpleGUI as sg

KEYBINDS_TO_TYPES = {
    't': 'todo',
    'w': 'waiting',
    #
    'n': 'note',
    'i': 'idea',
    'd': 'discussion',
    'r': 'reminder',
    'l': 'log',
}
TYPES = KEYBINDS_TO_TYPES.values()

# i.e. from keyword in this script to LogSeq page reference
LOGSEQ_TYPE_MAP = {
    'note': '#[[t/notes]]',
    'idea': '#[[t/idea]]',
    'reminder': '#[[t/idea]]',
    'log': '#[[t/log]]',
}


@dataclass()
class Ctx():
    type_: str = 'note'

    def validate(self) -> bool:
        assert self.type_ in TYPES


def main():
    window = build_window()

    while True:
        event, values = window.read()

        is_not_input = not isinstance(
            window.find_element_with_focus(),
            (sg.PySimpleGUI.Input, sg.Multiline),
        )

        if event in (sg.WIN_CLOSED, 'Exit', 'Cancel'):
            break

        elif event in ('Submit', ):
            do_save_note(values)
            break

        elif event == 'Enter':
            pass  # just allow enter (using shift-enter) for Multiline element

        elif event.endswith(':tab'):
            key, _ = event.split(':')
            el = window[f'{key}']
            value = values[key]
            el.update(value.replace('\t', ''))
            el.get_next_focus().set_focus()

        elif event.endswith(':stab'):
            key, _ = event.split(':')
            el = window[f'{key}']
            el.get_previous_focus().set_focus()

        if event.startswith('select-radio1:') and is_not_input:
            _, key = event.split(':')
            el = window[f'-radio1:{key}-']
            el.update(value=True)

    # window.hide()
    window.close()
    time.sleep(0.1)


def toggle_checkbox(window, key):
    el = window[key]
    value = not el.get()
    el.update(value=value)
    return value


def build_window() -> sg.Window:
    # sg.set_options(text_justification='right')

    # yapf: disable
    layout = [
        [sg.Text('New note', font=('Helvetica', 16))],
        [sg.Text('use shortcuts for note type when not focused on a text inputs')],
        [sg.Text('_' * 100, size=(65, 1))],

        [sg.Text('title', s=(8, 1)), sg.Input(s=50, key='-title-')],
        [sg.Text('Body', s=(8, 1)), sg.Multiline(s=(50, 8), key='-body-')],

        [sg.Text('_' * 100, size=(65, 1))],
        [sg.Text('Note Type', font=('Helvetica', 15), justification='left')],
        [sg.Radio(k, group_id=1, key=f'-radio1:{k}-') for k in TYPES],

        [sg.Text('_' * 100, size=(65, 1))],
        [sg.Text('Targets', font=('Helvetica', 15), justification='left')],
        [sg.Checkbox('LogSeq (L)', size=(12, 1), key='-logseq-'),],
        [sg.Checkbox('Org (O)', size=(12, 1), key='-org-'),],

        [sg.Text('_' * 100, size=(65, 1))],
        [sg.Submit(), sg.Cancel()],
    ]
    # yapf: enable

    window = sg.Window('Machine Learning Front End',
                       layout,
                       font=("Helvetica", 12),
                       finalize=True)
    # window.finalize()

    # NOTE: binds
    for k, v in KEYBINDS_TO_TYPES.items():
        window.bind(k, f'select-radio1:{v}')
    window.bind('L', 'toggle:logseq')
    window.bind('O', 'toggle:logseq')

    window.bind('<Return>', 'Submit')
    window.bind('<Shift-Return>', 'Enter')
    window.bind('<Escape>', 'Cancel')

    # normally Tab is instert in Multiline element. This changes back to expected behaviour.
    # of focusing next/prev element
    for k in ('-body-', ):
        window[k].bind('<Tab>', ':tab')
        window[k].bind('<Shift-Tab>', ':stab')

    window['-radio1:todo-'].update(value=True)
    window['-logseq-'].update(value=True)
    window['-org-'].update(value=True)

    return window


def do_save_note(values):
    save_logseq, save_org = values['-logseq-'], values['-org-']

    title, body, type_ = values['-title-'], values['-body-'], None
    for k in TYPES:
        if values[f'-radio1:{k}-']:
            type_ = k
    assert type_ is not None

    if save_logseq:
        raw = fmt_logseq(title, body, type_)
        fp = os.environ.get('LOGSEQ_REFILE')
        if fp is not None:
            with open(fp, 'w+') as f:
                f.write(raw)
        else:
            notify("ERROR!", 'LOGSEQ_REFILE not set')

        print('')
        print('logseq')
        print(raw)

    if save_org:
        print('saveing logseq')

        raw = fmt_org(title, body, type_)
        fp = os.environ.get('GTD_REFILE')
        if fp is not None:
            with open(fp, 'w+') as f:
                f.write(raw)
        else:
            notify("ERROR!", 'GTD_REFILE not set')

        print('')
        print('gtd')
        print(raw)

    notify('Saved!', '')


def fmt_logseq(title, body, type_: str) -> str:
    if type_ in ('todo', 'DOING', 'waiting', 'delegated', 'halt'):
        task_name = type_.upper() + ' '
        raw = f'''
* {task_name}{title} #refile
    '''
        if body:
            raw += '\n**' + body

    else:
        ls_type = LOGSEQ_TYPE_MAP[type_]

        raw = f'''
* {title} #refile
:PROPERTIES:
:TYPE: {ls_type}
:END:
    '''
        if body:
            raw += '\n**' + body

    task_name = type_.upper() + ' '
    return raw


def fmt_org(title, body, type_: str) -> str:
    task_name = type_.upper()
    raw = f'''
* {task_name} {title}

{body}
    '''
    return raw


def notify(title, body):
    bus_name = "org.freedesktop.Notifications"
    object_path = "/org/freedesktop/Notifications"
    interface = bus_name

    notify = dbus.Interface(
        dbus.SessionBus().get_object(bus_name, object_path), interface)

    notify.Notify('', 0, '', title, body, [], [], -1)


if __name__ == "__main__":
    main()
