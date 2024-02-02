local wezterm = require("wezterm")

local config = {}

config.color_scheme = "Batman"

config.keys = {
	{
		key = "LeftArrow",
		mods = "CMD",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = "RightArrow",
		mods = "CMD",
		action = wezterm.action.ActivateTabRelative(-1),
	},
}

return config
