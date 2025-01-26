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

config.color_scheme = "Neon Night (Gogh)"

config.prefer_to_spawn_tabs = true
config.native_macos_fullscreen_mode = true

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
        key = "n",
        mods = "CMD",
        action = wezterm.action.EmitEvent("navi"),
    },
}

wezterm.on("navi", function(window, pane)
    if wezterm.target_triple == "aarch64-apple-darwin" or wezterm.target_triple == "x86_64-apple-darwin" then
        window:perform_action(
            wezterm.action.SplitPane({
                direction = "Down",
                size = { Percent = 15 },
                command = { args = { "bash", "-ilc", "navi --print | pbcopy" } },
            }),
            pane
        )
    end
end)

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
    local title = tab_info.tab_title
    -- if the tab title is explicitly set, take that
    if title and #title > 0 then
        return title
    end

    if tab_info.active_pane.title == "ssh" then
        local hostname = ""
        local cwd_uri = tab_info.active_pane.current_working_dir
        if cwd_uri then
            if type(cwd_uri) == "userdata" then
                hostname = cwd_uri.host
            end

            -- Remove the domain name portion of the hostname
            local dot = hostname:find("[.]")
            if dot then
                hostname = hostname:sub(1, dot - 1)
            end

            if hostname == wezterm.hostname() then
                hostname = ""
            end
        end

        -- Otherwise, use the title from the active pane
        -- in that tab
        if hostname ~= "" then
            return hostname
        end
    end

    return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, _tabs, _panes, _config, _hover, _max_width)
    local title = tab_title(tab)
    if tab.is_active then
        return {
            { Foreground = { Color = "orange" } },
            { Text = " " .. title .. " " },
        }
    end
    return title
end)

wezterm.on("update-right-status", function(window, pane)
    -- Each element holds the text for a cell in a "powerline" style << fade
    local cells = {}

    local _, jalali_date, _ = wezterm.run_child_process({ "bash", "-lc", "jdate +%D" })
    table.insert(cells, wezterm.nerdfonts.fa_calendar .. "   " .. jalali_date:gsub("[\n\r]", " "))

    local _, tehran_clock, _ = wezterm.run_child_process({ "bash", "-lc", "TZ='Asia/Tehran' date +%H:%M:%S-%Z" })
    table.insert(cells, wezterm.nerdfonts.fa_clock_o .. "   " .. tehran_clock:gsub("[\n\r]", " "))

    local _, pst_clock, _ = wezterm.run_child_process({ "bash", "-lc", "TZ='US/Pacific' date +%H:%M:%S-%Z" })
    table.insert(cells, wezterm.nerdfonts.fa_clock_o .. "   " .. pst_clock:gsub("[\n\r]", " "))

    local _, est_clock, _ = wezterm.run_child_process({ "bash", "-lc", "TZ='US/Eastern' date +%H:%M:%S-%Z" })
    table.insert(cells, wezterm.nerdfonts.fa_clock_o .. "   " .. est_clock:gsub("[\n\r]", " "))

    -- An entry for each battery (typically 0 or 1 battery)
    local function battery_icons(state, percentage)
        if state == "Charging" then
            if 0 <= percentage and percentage < 10 then
                return wezterm.nerdfonts.md_battery_charging_10 .. " "
            elseif 10 <= percentage and percentage < 20 then
                return wezterm.nerdfonts.md_battery_charging_20 .. " "
            elseif 20 <= percentage and percentage < 30 then
                return wezterm.nerdfonts.md_battery_charging_30 .. " "
            elseif 30 <= percentage and percentage < 40 then
                return wezterm.nerdfonts.md_battery_charging_40 .. " "
            elseif 40 <= percentage and percentage < 50 then
                return wezterm.nerdfonts.md_battery_charging_50 .. " "
            elseif 50 <= percentage and percentage < 60 then
                return wezterm.nerdfonts.md_battery_charging_60 .. " "
            elseif 60 <= percentage and percentage < 70 then
                return wezterm.nerdfonts.md_battery_charging_70 .. " "
            elseif 70 <= percentage and percentage < 80 then
                return wezterm.nerdfonts.md_battery_charging_80 .. " "
            elseif 80 <= percentage and percentage < 90 then
                return wezterm.nerdfonts.md_battery_charging_90 .. " "
            else
                return wezterm.nerdfonts.md_battery_charging_100 .. " "
            end
        else
            if 0 <= percentage and percentage < 10 then
                return wezterm.nerdfonts.md_battery_10 .. " "
            elseif 10 <= percentage and percentage < 20 then
                return wezterm.nerdfonts.md_battery_20 .. " "
            elseif 20 <= percentage and percentage < 30 then
                return wezterm.nerdfonts.md_battery_30 .. " "
            elseif 30 <= percentage and percentage < 40 then
                return wezterm.nerdfonts.md_battery_40 .. " "
            elseif 40 <= percentage and percentage < 50 then
                return wezterm.nerdfonts.md_battery_50 .. " "
            elseif 50 <= percentage and percentage < 60 then
                return wezterm.nerdfonts.md_battery_60 .. " "
            elseif 60 <= percentage and percentage < 70 then
                return wezterm.nerdfonts.md_battery_70 .. " "
            elseif 70 <= percentage and percentage < 80 then
                return wezterm.nerdfonts.md_battery_80 .. " "
            elseif 80 <= percentage and percentage < 90 then
                return wezterm.nerdfonts.md_battery_90 .. " "
            else
                return wezterm.nerdfonts.md_battery .. " "
            end
        end
    end
    for _, b in ipairs(wezterm.battery_info()) do
        table.insert(
            cells,
            string.format("%s %.0f%% ", battery_icons(b.state, b.state_of_charge * 100), b.state_of_charge * 100)
        )
    end

    local cwd_uri = pane:get_current_working_dir()
    if cwd_uri then
        local hostname = ""

        if type(cwd_uri) == "userdata" then
            hostname = cwd_uri.host
        end

        -- Remove the domain name portion of the hostname
        local dot = hostname:find("[.]")
        if dot then
            hostname = hostname:sub(1, dot - 1)
        end

        if hostname ~= "" and hostname ~= wezterm.hostname() then
            table.insert(cells, hostname)
        end
    end

    -- Color palette for the backgrounds of each cell
    local colors = {
        "#ffac14",
        "#ffb327",
        "#ffba3b",
        "#ffc14e",
        "#ffc862",
        "#ffcf76",
        "#ffd589",
    }

    -- The elements to be formatted
    local elements = {}
    -- How many cells have been formatted
    local num_cells = 0

    -- Translate a cell into elements
    local function push(text, is_last)
        local cell_no = num_cells + 1
        table.insert(elements, { Foreground = { Color = colors[cell_no] } })
        table.insert(elements, { Text = " " .. text .. " " })
        if not is_last then
            table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
        end
        num_cells = num_cells + 1
    end

    while #cells > 0 do
        local cell = table.remove(cells, 1)
        push(cell, #cells == 0)
    end

    window:set_right_status(wezterm.format(elements))
end)

config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Light" })
config.font_size = 10
-- TODO (parham): still in the nightly build
-- config.show_close_tab_button_in_tabs = false
config.show_new_tab_button_in_tab_bar = false

-- machine specific configuration based on the hostname
local hostname = wezterm.hostname()

local machines = {
    ["millennium-falcon"] = function() end,
    ["tantive-iv"] = function() end,
}

local machine_config = machines[hostname]
if machine_config then
    machine_config()
end

return config
