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

-- Custom scheme aligned to naz.vim (1995parham/naz.vim), the Neovim/Vim
-- colorscheme, so vim-inside-wezterm and CLI tools share one true-color
-- palette. naz.vim is a Tomorrow-Night/Monokai hybrid: #323232 base (its
-- Normal bg, matched here so the editor blends into the terminal), pink
-- #F92772 accent, deep-sky-blue functions, aqua types. The tab/status chrome
-- stays a shade darker (#262626) for separation, matching tmux's status bg.
config.colors = {
    foreground = "#E8E8E3", -- naz Normal fg (s:white)
    background = "#323232", -- naz Normal bg (s:black)
    cursor_bg = "#F92772", -- naz pink (Statement accent)
    cursor_fg = "#323232",
    cursor_border = "#F92772",
    selection_fg = "#E8E8E3",
    selection_bg = "#575B61", -- naz lightgrey (Visual selection bg)
    split = "#EF7C66", -- naz softred (echoes tmux's salmon pane border)
    scrollbar_thumb = "#F92772", -- naz pink accent
    compose_cursor = "#EE82EE", -- naz purple (Constant / command prompt)

    -- copy mode's current-line highlight uses the pink accent (mirrors naz
    -- Statement / tmux copy-mode-current-line-number-style)
    copy_mode_active_highlight_bg = { Color = "#F92772" },
    copy_mode_active_highlight_fg = { Color = "#323232" },
    copy_mode_inactive_highlight_bg = { Color = "#575B61" }, -- naz lightgrey
    copy_mode_inactive_highlight_fg = { Color = "#E8E8E3" }, -- naz white

    -- keyboard-overlay labels (QuickSelect / launcher / InputSelector):
    -- naz orange (Identifier) idle, naz blue (Function) for the matched item
    quick_select_label_bg = { Color = "#FD9720" },
    quick_select_label_fg = { Color = "#323232" },
    quick_select_match_bg = { Color = "#00BFFF" },
    quick_select_match_fg = { Color = "#E8E8E3" },
    input_selector_label_bg = { Color = "#FD9720" },
    input_selector_label_fg = { Color = "#323232" },
    launcher_label_bg = { Color = "#FD9720" },
    launcher_label_fg = { Color = "#323232" },

    ansi = {
        "#211F1C", -- black    (naz darkblack)
        "#E73C50", -- red      (naz red)
        "#8AD000", -- green    (naz green)
        "#E6DB74", -- yellow   (naz yellow)
        "#00BFFF", -- blue     (naz blue, Function)
        "#F92772", -- magenta  (naz pink, Statement)
        "#66D9EF", -- cyan     (naz aqua, Type/Keyword)
        "#E8E8E3", -- white    (naz white, Normal fg)
    },
    brights = {
        "#575B61", -- bright black  (naz lightgrey)
        "#FF6347", -- bright red    (naz tomato, Number)
        "#7FFF00", -- bright green  (naz chartreuse, String)
        "#FD9720", -- bright yellow (naz orange, Identifier)
        "#198CFF", -- bright blue   (naz vividblue)
        "#EE82EE", -- bright magenta (naz purple, Constant)
        "#00CED1", -- bright cyan    (naz darkturquoise)
        "#FFFFFF", -- bright white
    },

    tab_bar = {
        background = "#262626", -- darker chrome, distinct from the #323232 content bg
        inactive_tab_edge = "#211F1C", -- naz darkblack, retro tab bar only
        active_tab = { bg_color = "#575B61", fg_color = "#66D9EF", intensity = "Bold" }, -- naz lightgrey / aqua
        inactive_tab = { bg_color = "#262626", fg_color = "#907D57" }, -- naz warmgrey (StatusLineNC)
        inactive_tab_hover = { bg_color = "#323232", fg_color = "#66D9EF" },
        new_tab = { bg_color = "#262626", fg_color = "#907D57" },
        new_tab_hover = { bg_color = "#575B61", fg_color = "#66D9EF" },
    },
}

config.prefer_to_spawn_tabs = true
config.native_macos_fullscreen_mode = true
config.max_fps = 120

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
        return title
    end

    return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, _tabs, _panes, _config, _hover, _max_width)
    local title = tab_title(tab)
    -- 1-based index (like tmux window numbers) so it lines up with tab
    -- navigation. Selected tab: naz orange (Identifier). Unselected: warmgrey.
    local index = tostring(tab.tab_index + 1)
    if tab.is_active then
        return {
            { Foreground = { Color = "#FD9720" } },
            { Text = " " .. index .. " " .. title .. " " },
        }
    end
    return {
        { Foreground = { Color = "#907D57" } },
        { Text = " " .. index .. " " .. title .. " " },
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

    -- Same naz orange foreground as the selected tab, on the darker chrome bg.
    local elements = {}
    for _, cell in ipairs(cells) do
        table.insert(elements, { Background = { Color = "#262626" } })
        table.insert(elements, { Foreground = { Color = "#FD9720" } })
        table.insert(elements, { Text = " " .. cell .. " " })
    end

    window:set_right_status(wezterm.format(elements))
end)

-- Maple Mono NF: a warm, rounded face with ligatures (calt) and Nerd Font
-- glyphs baked in, so tab/status icons render natively instead of via
-- WezTerm's bundled fallback. Wider than Iosevka Term, so cell_width drops
-- back to 1.0 (no horizontal padding needed). Kept light/small per preference.
config.font = wezterm.font("Maple Mono NF", { weight = "Medium" })
config.font_size = 10
config.cell_width = 1.0
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
-- blur radius kept low (8): a larger radius makes the macOS compositor
-- re-blur the whole window backdrop every repaint, which dominates GPU/CPU
-- cost when translucent. 8 keeps a subtle frost without the per-frame tax.
config.window_background_opacity = 0.9
config.macos_window_background_blur = 8

-- cursor
-- animation_fps = 1 + Constant easing makes the cursor blink a simple on/off
-- toggle instead of a per-frame fade animation, so an idle terminal stops
-- repainting continuously (was pinning ~15% CPU at animation_fps = 120).
config.animation_fps = 1
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
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
