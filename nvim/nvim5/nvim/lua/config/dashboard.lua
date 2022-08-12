version = vim.version()

local home = os.getenv("HOME")
local db = require("dashboard")

db.custom_header = {
	"▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄",
	"█▀░██▀▄▄▀█▀▄▄▀█░▄▄█▀▄▄▀█░▄▄▀█░▄▄▀█░████░▄▄▀█░▄▀▄░",
	"██░██▄▀▀░█▄▀▀░█▄▄▀█░▀▀░█░▀▀░█░▀▀▄█░▄▄░█░▀▀░█░█▄█░",
	"█▀░▀██▀▀▄██▀▀▄█▀▀▄█░████▄██▄█▄█▄▄█▄██▄█▄██▄█▄███▄",
	"▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀",
	string.format("neovim %d.%d.%d", version.major, version.minor, version.patch),
	vim.fn.strftime("%c") .. " on " .. vim.fn.hostname(),
	"",
	"",
}

db.custom_footer = {
	"",
	"🧡 2020-02-13 22:26:00",
	"",
}

if packer_plugins ~= nil then
	local count = #vim.tbl_keys(packer_plugins)
	db.custom_footer[4] = "🎉 neovim loaded " .. count .. " plugins"
end

db.custom_center = {
	{
		icon = "  ",
		desc = "Find  File                              ",
		shortcut = "SPC f f",
	},
	{
		icon = "  ",
		desc = "Open Personal dotfiles                  ",
		shortcut = "SPC f d",
	},
	{
		desc = "press space and wait to see more",
	},
}
