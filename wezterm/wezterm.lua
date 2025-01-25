--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- A GPU-accelerated cross-platform terminal emulator
-- https://wezfurlong.org/wezterm/
--

local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- WezTerm bundles JetBrains Mono, Nerd Font Symbols and Noto Color Emoji fonts
-- and uses those for the default font configuration.

config.color_scheme = "MaterialDark"

config.colors = {
    background = "#2e2e2e",
}

config.prefer_to_spawn_tabs = true

config.keys = {
    {
        key = "LeftArrow",
        mods = "CMD",
        action = wezterm.action.ActivateTabRelative(-1),
    },
    {
        key = "RightArrow",
        mods = "CMD",
        action = wezterm.action.ActivateTabRelative(1),
    },
    {
        key = "LeftArrow",
        mods = "CTRL | SHIFT",
        action = wezterm.action.ActivateTabRelative(-1),
    },
    {
        key = "RightArrow",
        mods = "CTRL | SHIFT",
        action = wezterm.action.ActivateTabRelative(1),
    },
    {
        key = "h",
        mods = "CMD",
        action = wezterm.action.EmitEvent("navi"),
    },
}

wezterm.on("navi", function(window, pane)
    if wezterm.target_triple == "aarch64-apple-darwin" or wezterm.target_triple == "x86_64-apple-darwin" then
        window:perform_action(
            wezterm.action.SpawnCommandInNewWindow({
                args = { "bash", "-ilc", "navi --print | pbcopy" },
            }),
            pane
        )
    end
end)

wezterm.on("update-right-status", function(window, _)
    local hostname = wezterm.nerdfonts.fa_laptop .. " " .. wezterm.hostname()

    local _, jalali_date, _ = wezterm.run_child_process({ "bash", "-lc", "jdate +%D" })
    jalali_date = wezterm.nerdfonts.fa_calendar .. " " .. jalali_date:gsub("[\n\r]", " ")

    local _, tehran_clock, _ = wezterm.run_child_process({ "bash", "-lc", "TZ='Asia/Tehran' date +%H:%M:%S-%Z" })
    tehran_clock = wezterm.nerdfonts.fa_clock_o .. " " .. tehran_clock:gsub("[\n\r]", " ")

    local _, pst_clock, _ = wezterm.run_child_process({ "bash", "-lc", "TZ='America/Los_Angeles' date +%H:%M:%S-%Z" })
    pst_clock = wezterm.nerdfonts.fa_clock_o .. " " .. pst_clock:gsub("[\n\r]", " ")

    local _, est_clock, _ = wezterm.run_child_process({ "bash", "-lc", "TZ='America/New_York' date +%H:%M:%S-%Z" })
    est_clock = wezterm.nerdfonts.fa_clock_o .. " " .. est_clock:gsub("[\n\r]", " ")

    local bat = ""
    for _, b in ipairs(wezterm.battery_info()) do
        local percentage = b.state_of_charge * 100

        if b.state == "Charging" then
            if 0 <= percentage and percentage < 10 then
                bat = wezterm.nerdfonts.md_battery_charging_10 .. " "
            elseif 10 <= percentage and percentage < 20 then
                bat = wezterm.nerdfonts.md_battery_charging_20 .. " "
            elseif 20 <= percentage and percentage < 30 then
                bat = wezterm.nerdfonts.md_battery_charging_30 .. " "
            elseif 30 <= percentage and percentage < 40 then
                bat = wezterm.nerdfonts.md_battery_charging_40 .. " "
            elseif 40 <= percentage and percentage < 50 then
                bat = wezterm.nerdfonts.md_battery_charging_50 .. " "
            elseif 50 <= percentage and percentage < 60 then
                bat = wezterm.nerdfonts.md_battery_charging_60 .. " "
            elseif 60 <= percentage and percentage < 70 then
                bat = wezterm.nerdfonts.md_battery_charging_70 .. " "
            elseif 70 <= percentage and percentage < 80 then
                bat = wezterm.nerdfonts.md_battery_charging_80 .. " "
            elseif 80 <= percentage and percentage < 90 then
                bat = wezterm.nerdfonts.md_battery_charging_90 .. " "
            else
                bat = wezterm.nerdfonts.md_battery_charging_100 .. " "
            end
        else
            if 0 <= percentage and percentage < 10 then
                bat = wezterm.nerdfonts.md_battery_10 .. " "
            elseif 10 <= percentage and percentage < 20 then
                bat = wezterm.nerdfonts.md_battery_20 .. " "
            elseif 20 <= percentage and percentage < 30 then
                bat = wezterm.nerdfonts.md_battery_30 .. " "
            elseif 30 <= percentage and percentage < 40 then
                bat = wezterm.nerdfonts.md_battery_40 .. " "
            elseif 40 <= percentage and percentage < 50 then
                bat = wezterm.nerdfonts.md_battery_50 .. " "
            elseif 50 <= percentage and percentage < 60 then
                bat = wezterm.nerdfonts.md_battery_60 .. " "
            elseif 60 <= percentage and percentage < 70 then
                bat = wezterm.nerdfonts.md_battery_70 .. " "
            elseif 70 <= percentage and percentage < 80 then
                bat = wezterm.nerdfonts.md_battery_80 .. " "
            elseif 80 <= percentage and percentage < 90 then
                bat = wezterm.nerdfonts.md_battery_90 .. " "
            else
                bat = wezterm.nerdfonts.md_battery .. " "
            end
        end

        bat = bat .. string.format("%.0f%%", percentage)
    end

    window:set_right_status(wezterm.format({
        { Foreground = { Color = "#ffffff" } },
        { Text = "  " .. hostname .. "  " },
        { Text = "  " .. tehran_clock .. "  " },
        { Text = "  " .. pst_clock .. "  " },
        { Text = "  " .. est_clock .. "  " },
        { Text = "  " .. jalali_date .. "  " },
        { Text = "  " .. bat .. "  " },
    }))
end)

config.font = wezterm.font("JetBrains Mono", { weight = "Light" })

-- machine specific configuration based on the hostname
local hostname = wezterm.hostname()
if hostname == "millennium-falcon" then
    config.font_size = 10
end
if hostname == "tantive-iv" then
    config.font_size = 10
end

return config
