-- default applications, the same ones sway uses
TERMINAL     = "alacritty"
-- termpad is a floating terminal in the middle of the screen (see apps.lua)
TERMPAD      = TERMINAL .. " --class __termpad"
FILE_MANAGER = "dolphin"
BROWSER      = "firefox"

-- run applications as systemd units under uwsm, as cachyos does
LAUNCH   = "uwsm app -- "
NOCTALIA = "noctalia msg "

-- monitors, empty means any (override them in hosts/<hostname>.lua)
MONITOR1        = ""
PRIMARY_MONITOR = MONITOR1

-- sway workspace names (sway/sway/config: $ws1..$ws9 and $wsf)
WORKSPACES = {
    "main-1",
    "main-2",
    "code",
    "www",
    "vm",
    "apps-1",
    "social-1",
    "social-2",
    "apps-2",
}
WORKSPACE_FOCUS = "name:focus"

-- gaps, kept here so the gaps submap can change them at runtime.
-- sway has inner 14 between windows and outer -2, hyprland applies gaps_in on
-- each side of a window and gaps_out from the screen edge.
GAPS_IN  = 7
GAPS_OUT = 12
