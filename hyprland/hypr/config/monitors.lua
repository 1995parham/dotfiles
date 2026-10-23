-- monitors: https://wiki.hypr.land/Configuring/Basics/Monitors/
-- hyprland applies these on hotplug, so kanshi is not needed.
-- list outputs with `hyprctl monitors`, add per machine rules in hosts/<hostname>.lua
hl.monitor({
    output   = MONITOR1,
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})
