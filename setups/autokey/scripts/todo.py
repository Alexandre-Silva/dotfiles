import os
import dbus

def run():
    ret, text = dialog.input_dialog(
        'New GTD todo'
    )

    if ret != 0:
        return

    refile_fp = '{}/gtd/refile.org'.format(os.environ['HOME'])
    with open(refile_fp, 'a') as f:
        f.write('* TODO {}\n\n'.format(text))
    notify('New TODO', text)
    
def notify(summary, body):
    bus_name = "org.freedesktop.Notifications"
    object_path = "/org/freedesktop/Notifications"
    interface = bus_name
    
    notify = dbus.Interface(dbus.SessionBus().get_object(bus_name, object_path), interface)
    
    notify.Notify('', 0, '', summary, body, [], [], -1)

run()