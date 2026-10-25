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

-- main-1 and main-2 open tabbed, like sway's workspace_layout tabbed: the
-- first tiled window becomes a group and every later one joins it.
-- group.auto_group only joins the focused group, so a window sent there from
-- another workspace would start its own group without this.
local tabbed = { ["main-1"] = true, ["main-2"] = true }
hl.on("window.open", function(w)
    if w.floating or w.group or not w.workspace or not tabbed[w.workspace.name] then
        return
    end
    for _, other in ipairs(hl.get_workspace_windows(w.workspace.name)) do
        if other ~= w and other.group and not other.floating then
            other.group:add(w)
            return
        end
    end
    hl.dispatch(hl.dsp.group.toggle({ window = "address:" .. w.address }))
end)
