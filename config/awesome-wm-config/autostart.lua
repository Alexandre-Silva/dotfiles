-- Grab only needed enviroment
local awful = require("awful")
local string = string
local io = io
local table = table
local pairs = pairs
local timer = timer
local type = type
local image = image
local capi = {oocairo = oocairo, timer = timer, dbus = dbus}
local tonumber = tonumber
local print = print
local error = error

--- autostart module
local autostart = {}

-- Default paths
local script_path = "/usr/share/awesome/bashets/"
local tmp_folder = "/tmp/"

-- Autostart
function autostart.autostart(dir)
    if not dir then
        do return nil end
    end
    local fd = io.popen("ls -1 -F " .. dir)
    if not fd then
        do return nil end
    end
    for file in fd:lines() do
        local c= string.sub(file,-1)   -- last char
        if c=='*' then  -- executables
            executable = string.sub( file, 1,-2 )
            print("Awesome Autostart: Executing: " .. executable)
            awful.util.spawn_with_shell(dir .. "/" .. executable .. "") -- launch in bg
        elseif c=='@' then  -- symbolic links
            print("Awesome Autostart: Not handling symbolic links: " .. file)
        else
            print ("Awesome Autostart: Skipping file " .. file .. " not executable.")
        end
    end
    io.close(fd)
end

return autostart
