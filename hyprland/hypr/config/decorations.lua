-- look and feel: cachyos rounding, blur and opacity with sway's colors and gaps
hl.config({
    general = {
        gaps_in = GAPS_IN,
        gaps_out = GAPS_OUT,
        -- sway's default_border pixel 2
        border_size = 2,
        extend_border_grab_area = 10,
        resize_on_border = true,
        col = {
            active_border = ORANGE,
            inactive_border = GRAY,
        },
    },
    group = {
        col = {
            border_active = ORANGE,
            border_inactive = GRAY,
            border_locked_active = RED,
            border_locked_inactive = GRAY,
        },
        groupbar = {
            col = {
                active = ORANGE,
                inactive = GRAY,
                locked_active = RED,
                locked_inactive = GRAY,
            },
        },
    },
    decoration = {
        dim_special = 0.3,
        rounding = 10,
        active_opacity = 0.95,
        inactive_opacity = 0.85,
        fullscreen_opacity = 1,
        blur = {
            size = 5,
            passes = 4,
            special = true,
        },
    },
})

-- sway's smart_gaps on and smart_borders on: a lone tiled window gets neither
-- gaps nor border.
hl.workspace_rule({ workspace = "w[tv1]", gaps_in = 0, gaps_out = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_in = 0, gaps_out = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0, rounding = 0 })
