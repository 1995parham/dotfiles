-- look and feel: cachyos rounding, blur and opacity with sway's colors and gaps,
-- in the orange of the noctalia bars (../../noctalia/bar.toml)
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
        -- floating windows snap to each other and to the screen edges
        snap = {
            enabled = true,
            window_gap = GAPS_IN,
            monitor_gap = GAPS_OUT,
            respect_gaps = true,
        },
    },
    group = {
        col = {
            border_active = ORANGE,
            border_inactive = GRAY,
            border_locked_active = RED,
            border_locked_inactive = GRAY,
        },
        -- tabs you can read: rounded pills like the bar's capsules, the active
        -- one orange with dark text. a group of one shows none, so main-1 and
        -- main-2 (tabbed on simorgh) do not carry an empty strip.
        groupbar = {
            disable_when_only = true,
            height = 22,
            font_size = 12,
            font_weight_active = "bold",
            gradients = true,
            gradient_rounding = 11,
            gradient_round_only_edges = false,
            indicator_height = 0,
            gaps_in = 6,
            gaps_out = 4,
            keep_upper_gap = true,
            text_color = DARK,
            text_color_inactive = LIGHT,
            col = {
                active = ORANGE,
                inactive = alpha(GRAY, "cc"),
                locked_active = RED,
                locked_inactive = alpha(GRAY, "cc"),
            },
        },
    },
    decoration = {
        dim_special = 0.3,
        -- softer squircle corners than plain circles
        rounding = 12,
        rounding_power = 2.5,
        active_opacity = 0.95,
        inactive_opacity = 0.85,
        fullscreen_opacity = 1,
        -- windows float above the wallpaper on a soft shadow, the focused one
        -- deeper
        shadow = {
            enabled = true,
            range = 18,
            render_power = 3,
            offset = { 0, 4 },
            color = "rgba(00000077)",
            color_inactive = "rgba(00000040)",
        },
        -- and a faint orange halo around the focused one
        glow = {
            enabled = true,
            range = 8,
            render_power = 3,
            color = alpha(ORANGE, "30"),
            color_inactive = "rgba(00000000)",
        },
        blur = {
            size = 6,
            passes = 3,
            -- keep the wallpaper's colors through the glass, with a little
            -- grain against banding
            vibrancy = 0.2,
            vibrancy_darkness = 0.1,
            noise = 0.015,
            contrast = 1.0,
            brightness = 0.9,
            special = true,
            popups = true,
        },
    },
})

-- sway's smart_gaps on and smart_borders on: a lone tiled window gets neither
-- gaps nor border.
hl.workspace_rule({ workspace = "w[tv1]", gaps_in = 0, gaps_out = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_in = 0, gaps_out = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0, rounding = 0 })
