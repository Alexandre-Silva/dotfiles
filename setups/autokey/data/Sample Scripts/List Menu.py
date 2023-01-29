choices = ["something", "something else", "a third thing"]
import time
time.sleep(1)

return_code, choice = dialog.list_menu(choices)
time.sleep(1) # wait for window to clear

if return_code == 0:
    keyboard.send_keys("You chose " + choice)

print(return_code, choice)