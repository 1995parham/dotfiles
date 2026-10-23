-- key bindings, sway/sway/config translated. where sway leaves a key free,
-- cachyos' noctalia bindings are kept.
local mod = "SUPER"

-- digits and grave by name: hyprland resolves binds through the first layout
-- (us) unless input:resolve_binds_by_sym is set, so they keep working on the
-- ir layout like sway's bindsym --to-code. "code:N" keys do not parse in lua
-- binds on 0.56, they register with an empty key and replace each other.
local function digit(d)
    return tostring(d)
end
local grave = "grave"

-- sway's border none / pixel 1 / normal
local function border(size)
    return function()
        hl.config({ general = { border_size = size } })
    end
end

---------------------------
---- WINDOW MANAGEMENT ----
---------------------------
hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("hyprctl kill"))

hl.bind(mod .. " + U", border(0))
hl.bind(mod .. " + Y", border(1))
hl.bind(mod .. " + N", border(2))

-- move and resize with the mouse (sway's floating_modifier)
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize())

-- focus, vim keys and arrows
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + Left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + Down", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + Up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + Right", hl.dsp.focus({ direction = "right" }))
hl.bind("ALT + Tab", hl.dsp.window.cycle_next())
hl.bind(mod .. " + Tab", hl.dsp.exec_cmd(NOCTALIA .. "window-switcher"))

-- move the focused window, sway's j k l ; and arrows
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "d" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + semicolon", hl.dsp.window.move({ direction = "r" }))
hl.bind(mod .. " + SHIFT + Left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + Down", hl.dsp.window.move({ direction = "d" }))
hl.bind(mod .. " + SHIFT + Up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + Right", hl.dsp.window.move({ direction = "r" }))

-- split: the next window opens right of / below the focused one
hl.bind(mod .. " + S", hl.dsp.layout("preselect r"))
hl.bind(mod .. " + V", hl.dsp.layout("preselect d"))
hl.bind(mod .. " + Q", hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + E", hl.dsp.layout("togglesplit"))
-- sway's tabbed layout is a hyprland group
hl.bind(mod .. " + W", hl.dsp.group.toggle())

hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))
-- sway's sticky toggle
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.pin({ action = "toggle" }))

-- scratchpad
hl.bind(mod .. " + SHIFT + minus", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))
hl.bind(mod .. " + minus", hl.dsp.workspace.toggle_special("scratchpad"))

------------------
---- LAUNCHER ----
------------------
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(LAUNCH .. TERMINAL))
hl.bind(mod .. " + SHIFT + Return", hl.dsp.exec_cmd(LAUNCH .. TERMPAD))
-- this configuration at a glance, to find a key binding
hl.bind(mod .. " + F1", hl.dsp.exec_cmd(LAUNCH .. TERMPAD .. " --command bat " .. os.getenv("HOME") .. "/.config/hypr/config/binds.lua"))
hl.bind(mod .. " + D", hl.dsp.exec_cmd(NOCTALIA .. "panel-toggle launcher"))
hl.bind(mod .. " + period", hl.dsp.exec_cmd(NOCTALIA .. "panel-toggle launcher /emo"))
hl.bind(mod .. " + CONTROL + M", hl.dsp.exec_cmd(LAUNCH .. "pavucontrol"))
hl.bind(mod .. " + F5", hl.dsp.exec_cmd(LAUNCH .. TERMPAD .. " --command ncmpcpp"))
hl.bind(mod .. " + CONTROL + R", hl.dsp.exec_cmd("obs --scene normal --startrecording --minimize-to-tray"))
hl.bind("CONTROL + SHIFT + Escape", hl.dsp.exec_cmd(LAUNCH .. TERMPAD .. " --command btop"))

-- noctalia panels
hl.bind(mod .. " + Z", hl.dsp.exec_cmd(NOCTALIA .. "settings-toggle"))
hl.bind(mod .. " + X", hl.dsp.exec_cmd(NOCTALIA .. "panel-toggle control-center"))
hl.bind(mod .. " + A", hl.dsp.exec_cmd(NOCTALIA .. "panel-toggle control-center notifications"))
hl.bind(mod .. " + SHIFT + V", hl.dsp.exec_cmd(NOCTALIA .. "panel-toggle clipboard"))
hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd(NOCTALIA .. "panel-toggle wallpaper"))
hl.bind(mod .. " + ALT + C", hl.dsp.exec_cmd(NOCTALIA .. "panel-toggle session"))

-- hide/show the bar, sway's bar mode invisible / dock
hl.bind(mod .. " + M", hl.dsp.exec_cmd(NOCTALIA .. "bar-hide"))
hl.bind(mod .. " + SHIFT + M", hl.dsp.exec_cmd(NOCTALIA .. "bar-show"))

-- en/fa layouts (sway's hosts/x-wing.conf xkb_switch_layout next)
hl.bind(mod .. " + space", hl.dsp.exec_cmd(NOCTALIA .. "keyboard-layout-cycle"))

hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload && notify-send -a hyprland reloaded"))

---------------------------
---- HARDWARE CONTROLS ----
---------------------------
-- noctalia shows the osd, replacing sway's dunstify
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(NOCTALIA .. "volume-up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(NOCTALIA .. "volume-down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(NOCTALIA .. "volume-mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(NOCTALIA .. "mic-mute"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(NOCTALIA .. "brightness-up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(NOCTALIA .. "brightness-down"), { locked = true, repeating = true })
-- media over mpris, so any player works (mpd needs mpd-mpris)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(NOCTALIA .. "media toggle"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(NOCTALIA .. "media toggle"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(NOCTALIA .. "media next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(NOCTALIA .. "media previous"), { locked = true })

-------------------
---- UTILITIES ----
-------------------
-- screenshots into ~/Pictures like sway: the screen, the focused window,
-- and noctalia's region capture
local shot = "$(xdg-user-dir PICTURES)/$(date +'%s_grim.png')"
hl.bind("Print", hl.dsp.exec_cmd("grim " .. shot))
hl.bind(mod .. " + Print", hl.dsp.exec_cmd(
    "hyprctl activewindow -j | jq -j '\"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])\"' | grim -g - " .. shot
))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(NOCTALIA .. "screenshot-region"))
hl.bind(mod .. " + P", hl.dsp.exec_cmd("hyprpicker -a -n"))

-------------------------------
---- WORKSPACES & MONITORS ----
-------------------------------
for i = 1, #WORKSPACES do
    -- switch to workspace
    hl.bind(mod .. " + " .. digit(i), hl.dsp.focus({ workspace = i }))
    -- move focused window to workspace
    hl.bind(mod .. " + CONTROL + " .. digit(i), hl.dsp.window.move({ workspace = i, follow = false }))
    -- move to workspace with focused window
    hl.bind(mod .. " + SHIFT + " .. digit(i), hl.dsp.window.move({ workspace = i, follow = true }))
end
hl.bind(mod .. " + " .. grave, hl.dsp.focus({ workspace = WORKSPACE_FOCUS }))
hl.bind(mod .. " + CONTROL + " .. grave, hl.dsp.window.move({ workspace = WORKSPACE_FOCUS, follow = false }))
hl.bind(mod .. " + SHIFT + " .. grave, hl.dsp.window.move({ workspace = WORKSPACE_FOCUS, follow = true }))

-- back and forth, with and without the focused window
hl.bind(mod .. " + B", hl.dsp.focus({ workspace = "previous" }))
hl.bind(mod .. " + SHIFT + B", hl.dsp.window.move({ workspace = "previous", follow = true }))

-- next / previous existing workspace, also on the mouse side buttons
hl.bind(mod .. " + CONTROL + Right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + CONTROL + Left", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("mouse:276", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("mouse:275", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }))
