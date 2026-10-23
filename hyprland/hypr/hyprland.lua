-- vim: ft=lua
-- hyprland configuration: our sway (sway/sway/config) ported on top of the
-- cachyos hyprland + noctalia setup. noctalia is the shell here, it replaces
-- waybar, rofi, dunst, swaylock, swayidle and swaybg (see ../noctalia).
-- reference: https://wiki.hypr.land/ and /usr/share/hypr/stubs/hl.meta.lua

require("config.variables")
require("config.colors")
require("config.monitors")
require("config.inputs")
require("config.decorations")
require("config.animations")
require("config.misc")
require("config.workspaces")
require("config.autostart")
require("config.binds")
require("config.submaps")
require("config.windowrules")
require("config.apps")

-- host specific configuration, like sway's hosts/`hostname`.conf
local hostname_file = io.open("/etc/hostname", "r")
if hostname_file then
    local host = hostname_file:read("*l")
    hostname_file:close()

    local host_config = os.getenv("HOME") .. "/.config/hypr/hosts/" .. host .. ".lua"
    local host_file = io.open(host_config, "r")
    if host_file then
        host_file:close()
        require("hosts." .. host)
    end
end
