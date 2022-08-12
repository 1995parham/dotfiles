local fterm = require("FTerm")
fterm.setup({
	-- Filetype of the terminal buffer
	ft = "FTerm",

	-- Command to run inside the terminal. It could be a `string` or `table`
	cmd = os.getenv("SHELL") or "zsh",

	-- Neovim's native window border. See `:h nvim_open_win` for more configuration options.
	border = "single",

	-- Close the terminal as soon as shell/command exits.
	-- Disabling this will mimic the native terminal behaviour.
	auto_close = true,

	-- Highlight group for the terminal. See `:h winhl`
	hl = "Normal",

	-- Transparency of the floating window. See `:h winblend`
	blend = 5,

	-- Object containing the terminal window dimensions.
	-- The value for each field should be between `0` and `1`
	dimensions = {
		height = 0.8, -- Height of the terminal window
		width = 0.8, -- Width of the terminal window
		x = 0.5, -- X axis of the terminal window
		y = 0.5, -- Y axis of the terminal window
	},

	-- Callback invoked when the terminal exits.
	-- See `:h jobstart-options`
	on_exit = function() end,

	-- Callback invoked when the terminal emits stdout data.
	-- See `:h jobstart-options`
	on_stdout = function() end,

	-- Callback invoked when the terminal emits stderr data.
	-- See `:h jobstart-options`
	on_stderr = function() end,
})

-- useful tools/commands as floating terminal.

local atop = fterm:new({
	ft = "fterm_atop",
	cmd = "atop",
	dimensions = {
		height = 0.3,
		width = 0.3,
		x = 0.9,
		y = 0.9,
	},
})

function _G.__fterm_atop()
	atop:toggle()
end

local lazydocker = fterm:new({
	ft = "fterm_lazydocker",
	cmd = "lazydocker",
	dimensions = {
		height = 0.8,
		width = 0.8,
		x = 0.5,
		y = 0.5,
	},
})

function _G.__fterm_lazydocker()
	lazydocker:toggle()
end

local ipython = fterm:new({
	ft = "fterm_ipython",
	cmd = "ipython",
	dimensions = {
		height = 0.8,
		width = 0.8,
		x = 0.5,
		y = 0.5,
	},
})

function _G.__fterm_ipython()
	ipython:toggle()
end
