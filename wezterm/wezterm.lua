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

config.color_scheme = "Railscasts (dark) (terminal.sexy)"

config.prefer_to_spawn_tabs = true
config.native_macos_fullscreen_mode = true
config.max_fps = 240

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
        key = "h",
        mods = "CTRL | SHIFT",
        action = wezterm.action.ActivateTabRelative(-1),
    },
    {
        key = "RightArrow",
        mods = "CTRL | SHIFT",
        action = wezterm.action.ActivateTabRelative(1),
    },
    {
        key = "l",
        mods = "CTRL | SHIFT",
        action = wezterm.action.ActivateTabRelative(1),
    },
    {
        key = "i",
        mods = "CMD | ALT",
        action = wezterm.action.ShowDebugOverlay,
    },
    {
        key = "n",
        mods = "CMD",
        action = wezterm.action.EmitEvent("navi"),
    },
    {
        key = "s",
        mods = "CMD",
        action = wezterm.action.EmitEvent("toggle_term"),
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

wezterm.on("toggle_term", function(window, pane)
    local terminal_pane = nil

    if TOGGLE_PANE_ID then
        local status, p = pcall(function()
            return wezterm.mux.get_pane(TOGGLE_PANE_ID)
        end)
        if status then
            terminal_pane = p
        else
            terminal_pane = nil
            TOGGLE_PANE_ID = nil
        end
    end

    wezterm.log_info(terminal_pane)

    if terminal_pane and window:active_pane():pane_id() == terminal_pane:pane_id() then
        window:perform_action(wezterm.action.CloseCurrentPane({ confirm = true }), pane)
        TOGGLE_PANE_ID = nil
    else
        if terminal_pane then
            terminal_pane:activate()
        else
            local new_pane = pane:split({ direction = "Bottom", size = 0.3 })
            TOGGLE_PANE_ID = new_pane:pane_id()
        end
    end
end)

local function tab_title(tab_info)
    local title = tab_info.tab_title

    -- if the tab title is explicitly set, take that
    if title and #title > 0 then
        return wezterm.nerdfonts.fa_circle .. "   " .. title
    end

    return wezterm.nerdfonts.fa_circle .. "   " .. tab_info.active_pane.title
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

-- config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Light" })
config.font_size = 10
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

config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.underline_thickness = "1.5pt"

-- cursor
config.animation_fps = 120
config.cursor_blink_ease_in = "EaseOut"
config.cursor_blink_ease_out = "EaseOut"
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 650

config.adjust_window_size_when_changing_font_size = false
config.window_close_confirmation = "NeverPrompt"

config.visual_bell = {
    fade_in_function = "EaseIn",
    fade_in_duration_ms = 250,
    fade_out_function = "EaseOut",
    fade_out_duration_ms = 250,
    target = "CursorColor",
}

config.automatically_reload_config = true
config.status_update_interval = 1000

config.scrollback_lines = 20000

config.hyperlink_rules = {
    -- Matches: a URL in parens: (URL)
    {
        regex = "\\((\\w+://\\S+)\\)",
        format = "$1",
        highlight = 1,
    },
    -- Matches: a URL in brackets: [URL]
    {
        regex = "\\[(\\w+://\\S+)\\]",
        format = "$1",
        highlight = 1,
    },
    -- Matches: a URL in curly braces: {URL}
    {
        regex = "\\{(\\w+://\\S+)\\}",
        format = "$1",
        highlight = 1,
    },
    -- Matches: a URL in angle brackets: <URL>
    {
        regex = "<(\\w+://\\S+)>",
        format = "$1",
        highlight = 1,
    },
    -- Then handle URLs not wrapped in brackets
    {
        regex = "\\b\\w+://\\S+[)/a-zA-Z0-9-]+",
        format = "$0",
    },
    -- implicit mailto link
    {
        regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
        format = "mailto:$0",
    },
}

return config
