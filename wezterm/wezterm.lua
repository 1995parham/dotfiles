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

config.color_scheme = "Afterglow"

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
}

wezterm.on("update-right-status", function(window, _)
	local hostname = wezterm.nerdfonts.fa_laptop .. " " .. wezterm.hostname()

	local _, jalali_date, _ = wezterm.run_child_process({ "bash", "-lc", "jdate +%D" })
	jalali_date = wezterm.nerdfonts.fa_calendar .. " " .. jalali_date:gsub("[\n\r]", " ")

	local _, clock, _ = wezterm.run_child_process({ "bash", "-lc", "TZ='Asia/Tehran' date +%H:%M:%S" })
	clock = wezterm.nerdfonts.fa_clock_o .. " " .. clock:gsub("[\n\r]", " ")

	window:set_right_status(wezterm.format({
		{ Foreground = { Color = "#ffffff" } },
		{ Text = "  " .. hostname .. "  " },
		{ Text = "  " .. clock .. "  " },
		{ Text = "  " .. jalali_date .. "  " },
	}))
end)

-- machine specific configuration based on the hostname
local hostname = wezterm.hostname()
if hostname == "pegasus" then
	config.font_size = 9
	config.window_background_opacity = 0.95
elseif hostname == "millennium-falcon" then
	config.font_size = 11
end

return config
