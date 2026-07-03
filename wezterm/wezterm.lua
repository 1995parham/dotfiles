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
config.max_fps = 60

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

-- Timezone math for the status-bar clocks, computed entirely in Lua so the
-- render callback never spawns a child process. Spawning here used to pin
-- syspolicyd: WezTerm.app is provenance-tracked by macOS Gatekeeper, so every
-- child it spawns is assessed, and on this machine that path errors and does a
-- network round trip per spawn (which heated the chassis). Tehran is a fixed
-- +3:30 (Iran dropped DST); the two US zones follow the standard rule (2nd
-- Sunday of March 02:00 -> 1st Sunday of November 02:00). Validated against the
-- OS `date` across 2024-2028.
local function div(a, b)
    return math.floor(a / b)
end

-- Howard Hinnant's civil->days: days since 1970-01-01, timezone-independent.
local function days_from_civil(y, m, d)
    y = y - (m <= 2 and 1 or 0)
    local era = div(y >= 0 and y or y - 399, 400)
    local yoe = y - era * 400
    local doy = div(153 * (m > 2 and m - 3 or m + 9) + 2, 5) + d - 1
    local doe = yoe * 365 + div(yoe, 4) - div(yoe, 100) + doy
    return era * 146097 + doe - 719468
end

-- epoch (UTC) of the nth Sunday of (y, month) at hour_utc:00 UTC
local function nth_sunday_epoch(y, month, nth, hour_utc)
    local first = days_from_civil(y, month, 1)
    local wd = (first % 7 + 4) % 7 -- 0=Sun; 1970-01-01 was a Thursday (=4)
    local first_sun = 1 + ((7 - wd) % 7)
    return days_from_civil(y, month, first_sun + (nth - 1) * 7) * 86400 + hour_utc * 3600
end

-- US DST offset for a zone with standard offset std_h hours (e.g. -5 Eastern).
-- Returns offset seconds and whether daylight time is in effect.
local function us_offset(now, std_h)
    local y = tonumber(os.date("!%Y", now))
    local start = nth_sunday_epoch(y, 3, 2, 2 - std_h) -- 02:00 local standard
    local finish = nth_sunday_epoch(y, 11, 1, 1 - std_h) -- 02:00 local daylight
    local dst = now >= start and now < finish
    return (std_h + (dst and 1 or 0)) * 3600, dst
end

wezterm.on("update-right-status", function(window, pane)
    -- Each element holds the text for a cell in a "powerline" style << fade
    local cells = {}

    -- Ticking clocks, computed in Lua (no spawn): os.time() is the
    -- TZ-independent Unix epoch and os.date("!...") formats in UTC, so
    -- epoch + zone offset gives that zone's wall clock, seconds and all.
    local now = os.time()
    local p_off, p_dst = us_offset(now, -8) -- US/Pacific
    local e_off, e_dst = us_offset(now, -5) -- US/Eastern
    local clocks = {
        { offset = 12600, abbr = "+0330" }, -- Asia/Tehran, fixed +3:30
        { offset = p_off, abbr = p_dst and "PDT" or "PST" },
        { offset = e_off, abbr = e_dst and "EDT" or "EST" },
    }
    for _, z in ipairs(clocks) do
        table.insert(
            cells,
            wezterm.nerdfonts.fa_clock_o .. "   " .. os.date("!%H:%M:%S", now + z.offset) .. "-" .. z.abbr
        )
    end

    -- An entry for each battery (typically 0 or 1 battery). Pick the icon by
    -- rounding up to the nearest 10% bucket: Material Design has
    -- md_battery_10..md_battery_90 (plus md_battery for full) for the discharging
    -- ramp and md_battery_charging_10..md_battery_charging_100 for charging.
    local function battery_icons(state, percentage)
        local bucket = math.min(100, math.floor(percentage / 10) * 10 + 10)
        local name
        if state == "Charging" then
            name = "md_battery_charging_" .. bucket
        elseif bucket == 100 then
            name = "md_battery"
        else
            name = "md_battery_" .. bucket
        end
        return wezterm.nerdfonts[name] .. " "
    end
    for _, b in ipairs(wezterm.battery_info()) do
        table.insert(
            cells,
            string.format("%s %.0f%% ", battery_icons(b.state, b.state_of_charge * 100), b.state_of_charge * 100)
        )
    end

    -- Plain status text: naz orange (matches the selected tab) on the tab-bar
    -- strip, no capsule.
    window:set_right_status(wezterm.format({
        { Foreground = { Color = "#FD9720" } },
        { Text = " " .. table.concat(cells, "   ") .. " " },
    }))
end)

-- Maple Mono NF: a warm, rounded face with ligatures (calt) and Nerd Font
-- glyphs baked in, so tab/status icons render natively instead of via
-- WezTerm's bundled fallback. Wider than Iosevka Term, so cell_width drops
-- back to 1.0 (no horizontal padding needed). Kept light/small per preference.
-- cv04: alternate `l` with a left bottom bar (Consolas-style foot) so it's
-- unmistakable next to `1`/`I`. Setting harfbuzz_features replaces WezTerm's
-- defaults, so the ligature features (calt/liga/clig) and kern are re-listed
-- here to keep Maple Mono's ligatures working.
config.font = wezterm.font("Maple Mono NF", {
    weight = "Medium",
    harfbuzz_features = { "kern", "liga", "clig", "calt", "cv04=1" },
})
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
-- The render callback computes everything in Lua and spawns nothing at all, so
-- a 1s tick is cheap and never touches syspolicyd: no child process means no
-- macOS Gatekeeper provenance assessment, which is what used to pin syspolicyd
-- and heat the chassis. Smooth ticking seconds, zero exec-errors.
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
