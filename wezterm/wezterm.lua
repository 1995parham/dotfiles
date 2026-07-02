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

-- Custom scheme built from tmux/tmux/colors.conf + status-bar.conf so both
-- terminals share one palette: dark gray base, neon pink for "active",
-- electric cyan/blue for the current-window highlight.
config.colors = {
    foreground = "#d0d0d0",
    background = "#262626", -- tmux colour235 (status bg)
    cursor_bg = "#ff0087", -- tmux colour198 (pane-active-border-style)
    cursor_fg = "#262626",
    cursor_border = "#ff0087",
    selection_fg = "#ffffff",
    selection_bg = "#444444", -- tmux colour238 (current-window bg)
    split = "#ff9d9d", -- tmux pane-border-style fg
    scrollbar_thumb = "#ff0087", -- tmux pane-scrollbars-style fg (colour198)
    compose_cursor = "#d700ff", -- tmux message-style fg (colour165, command prompt)

    -- copy mode's current-line highlight, mirrors tmux
    -- copy-mode-current-line-number-style (fg=colour198, bold)
    copy_mode_active_highlight_bg = { Color = "#ff0087" },
    copy_mode_active_highlight_fg = { Color = "#262626" },
    copy_mode_inactive_highlight_bg = { Color = "#3a3a3a" }, -- colour237
    copy_mode_inactive_highlight_fg = { Color = "#bcbcbc" }, -- colour250

    -- keyboard-overlay labels (QuickSelect / launcher / InputSelector),
    -- same role as tmux's display-panes overlay: colour166 idle, colour33 for
    -- the active/matched item
    quick_select_label_bg = { Color = "#d75f00" },
    quick_select_label_fg = { Color = "#262626" },
    quick_select_match_bg = { Color = "#0087d7" },
    quick_select_match_fg = { Color = "#ffffff" },
    input_selector_label_bg = { Color = "#d75f00" },
    input_selector_label_fg = { Color = "#262626" },
    launcher_label_bg = { Color = "#d75f00" },
    launcher_label_fg = { Color = "#262626" },

    ansi = {
        "#262626", -- black
        "#d70000", -- red      (colour160, bell/error)
        "#87ff00", -- green    (colour118, status bar fg)
        "#ffff00", -- yellow   (colour226, status date)
        "#0087d7", -- blue     (colour33, display-panes-active)
        "#ff0087", -- magenta  (colour198, active border/menu)
        "#5fd7ff", -- cyan     (colour81, current window fg)
        "#bcbcbc", -- white    (colour250)
    },
    brights = {
        "#444444", -- bright black  (colour238)
        "#ff5f00", -- bright red    (colour202)
        "#afffd7", -- bright green  (colour158, mint)
        "#ffaf87", -- bright yellow (colour216, salmon)
        "#5fafff", -- bright blue
        "#d700ff", -- bright magenta (colour165)
        "#00ffd7", -- bright cyan    (colour50, turquoise)
        "#ffffff", -- bright white
    },

    tab_bar = {
        background = "#262626",
        inactive_tab_edge = "#3a3a3a", -- colour237, retro tab bar only
        active_tab = { bg_color = "#444444", fg_color = "#5fd7ff", intensity = "Bold" },
        inactive_tab = { bg_color = "#262626", fg_color = "#af8787" }, -- colour138
        inactive_tab_hover = { bg_color = "#3a3a3a", fg_color = "#5fd7ff" },
        new_tab = { bg_color = "#262626", fg_color = "#af8787" },
        new_tab_hover = { bg_color = "#444444", fg_color = "#5fd7ff" },
    },
}

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

local toggle_pane_id = nil

wezterm.on("toggle_term", function(window, pane)
    local terminal_pane = nil

    if toggle_pane_id then
        local status, p = pcall(function()
            return wezterm.mux.get_pane(toggle_pane_id)
        end)
        if status then
            terminal_pane = p
        else
            terminal_pane = nil
            toggle_pane_id = nil
        end
    end

    wezterm.log_info(terminal_pane)

    if terminal_pane and window:active_pane():pane_id() == terminal_pane:pane_id() then
        window:perform_action(wezterm.action.CloseCurrentPane({ confirm = true }), pane)
        toggle_pane_id = nil
    else
        if terminal_pane then
            terminal_pane:activate()
        else
            local new_pane = pane:split({ direction = "Bottom", size = 0.3 })
            toggle_pane_id = new_pane:pane_id()
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
    -- Orange window-name text, same as tmux's window-status-current-format /
    -- window-status-format #W coloring (colour202 active, colour208 inactive)
    if tab.is_active then
        return {
            { Foreground = { Color = "#ff5f00" } },
            { Text = " " .. title .. " " },
        }
    end
    return {
        { Foreground = { Color = "#ff8700" } },
        { Text = " " .. title .. " " },
    }
end)

wezterm.on("update-right-status", function(window, pane)
    -- Each element holds the text for a cell in a "powerline" style << fade
    local cells = {}

    -- One login-shell spawn instead of four: jdate needs Homebrew on PATH
    -- (hence -l), and the login-shell startup cost dominates over the
    -- actual date/jdate calls, so batching them saves ~75% of the overhead.
    local _, clocks_output, _ = wezterm.run_child_process({
        "bash",
        "-lc",
        "jdate +%D; TZ='Asia/Tehran' date +%H:%M:%S-%Z; TZ='US/Pacific' date +%H:%M:%S-%Z; TZ='US/Eastern' date +%H:%M:%S-%Z",
    })
    local clock_lines = {}
    for line in clocks_output:gmatch("[^\r\n]+") do
        table.insert(clock_lines, line)
    end

    table.insert(cells, wezterm.nerdfonts.fa_calendar .. "   " .. (clock_lines[1] or ""))
    table.insert(cells, wezterm.nerdfonts.fa_clock_o .. "   " .. (clock_lines[2] or ""))
    table.insert(cells, wezterm.nerdfonts.fa_clock_o .. "   " .. (clock_lines[3] or ""))
    table.insert(cells, wezterm.nerdfonts.fa_clock_o .. "   " .. (clock_lines[4] or ""))

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

-- Iosevka Term is Iosevka's own build curated for terminal use; noticeably
-- narrower than JetBrains Mono, which buys back columns in the narrow
-- toggle_term/navi splits. Kept light and small per preference rather than
-- compensating size upward for the narrower glyphs. Icon glyphs still come
-- from WezTerm's bundled Nerd Font Symbols fallback, so no NF-patched build
-- is needed here.
config.font = wezterm.font("Iosevka Term", { weight = "Light" })
config.font_size = 10
config.cell_width = 0.9 -- tighten horizontal spacing between characters
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

-- macOS traffic-light buttons folded into the fancy tab bar, no separate
-- title strip
config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"

-- frosted-glass translucency; tune opacity/blur radius to taste
config.window_background_opacity = 0.9
config.macos_window_background_blur = 20

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

-- Extends the built-in QuickSelect patterns (URLs, paths, git hashes, IPs,
-- numbers) bound to CTRL-SHIFT-Space by default.
config.quick_select_patterns = {
    -- UUIDs, e.g. request/trace ids in logs
    "[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}",
    -- file:line(:col) references from stack traces / compiler errors
    "[\\w./-]+\\.\\w+:\\d+(:\\d+)?",
    -- semver-ish version tags, e.g. v1.2.3 or 1.2.3-rc.1
    "v?\\d+\\.\\d+\\.\\d+(-[0-9A-Za-z.]+)?",
}

return config
