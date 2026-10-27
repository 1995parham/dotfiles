-- input configuration, from sway/sway/config.d/input.conf
hl.config({
    input = {
        kb_layout = "us,ir",
        -- sway's focus_follows_mouse no: hovering does not move keyboard focus,
        -- clicking does.
        follow_mouse = 2,
        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
            disable_while_typing = true,
        },
    },
    cursor = {
        -- sway's seat seat0 hide_cursor 3000
        inactive_timeout = 3,
        -- and typing hides it at once, moving it brings it back
        hide_on_key_press = true,
    },
})

-- sway's bindgesture swipe:left/right, three fingers like sway
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
