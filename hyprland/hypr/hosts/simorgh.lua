-- simorgh, the ASUS Zenbook (1920x1200 panel)

-- scale = "auto" picks 1.5 on this panel, which makes everything too big
LAPTOP.scale = 1
apply_monitor_profiles()

-- a trencadís border, the colors of Gaudí's broken-tile mosaics at Park Güell,
-- to go with the Barcelona wallpapers (../../noctalia/wallpaper.toml)
hl.config({
    general = {
        col = {
            active_border = {
                colors = { "rgba(ff6b35ee)", "rgba(f7c548ee)", "rgba(2ec4b6ee)", "rgba(9b5de5ee)" },
                angle = 45,
            },
            inactive_border = { colors = { "rgba(2a3b5caa)", "rgba(3d2a5caa)" }, angle = 45 },
        },
    },
})
