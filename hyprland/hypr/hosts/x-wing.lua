-- x-wing, sway/sway/hosts/x-wing.conf

-- the laptop keyboard's wake up key switches the en/fa layouts too
-- (binds.lua has Super+space for every keyboard)
hl.bind("XF86WakeUp", hl.dsp.exec_cmd(NOCTALIA .. "keyboard-layout-cycle"))

-- output eDP-1 adaptive_sync true
LAPTOP.vrr = 1
apply_monitor_profiles()
