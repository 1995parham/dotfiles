-- automatically ensure that packer.nvim is installed
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({
		"git",
		"clone",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	execute("packadd packer.nvim")
end

return require("packer").startup(function(use)
	-- packer can manage itself
	use({ "wbthomason/packer.nvim" })

	-- a vim alignment plugin
	use({ "junegunn/vim-easy-align" })

	-- vim support for editing fish scripts
	use({ "dag/vim-fish" })

	-- an alternative sudo.vim for vim and neovim
	use({ "lambdalisue/suda.vim" })

	-- vim-kubernetes
	use({ "andrewstuart/vim-kubernetes" })

	-- vim syntax highlighting plugin for json with c-style line (//) and block (/* */) comments.
	use({ "kevinoid/vim-jsonc" })

	-- syntax highlighting for kitty terminal config files.
	use("fladson/vim-kitty")

	-- vim configuration for zig
	use("ziglang/zig.vim")

	-- vim syntax for tmol
	use("cespare/vim-toml")

	-- erlang indentation and syntax for vim
	use("vim-erlang/vim-erlang-runtime")

	-- naz neovim theme
	use({
		"1995parham/naz.vim",
		branch = "main",
		config = function()
			require("colorbuddy").colorscheme("naz")
		end,
		requires = { "tjdevries/colorbuddy.nvim" },
	})

	-- wakatime
	use({ "wakatime/vim-wakatime" })

	-- markdown vim mode
	use({
		"plasticboy/vim-markdown",
		config = function()
			vim.g.vim_markdown_folding_disabled = 1
			vim.g.vim_markdown_math = 1
		end,
		requires = { "godlygeek/tabular" },
	})

	-- nvim Treesitter configurations and abstraction layer
	use({
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("config/treesitter")
		end,
	})

	-- check syntax in vim asynchronously and fix files, with language server protocol (lsp) support
	use({
		"w0rp/ale",
		setup = function()
			require("config/ale")
		end,
	})

	-- vim plugin for shfmt
	use({
		"z0mbix/vim-shfmt",
		ft = { "sh", "zsh", "bash" },
		setup = function()
			vim.g.shfmt_fmt_on_save = 1
		end,
	})

	-- vim dashboard
	use({
		"glepnir/dashboard-nvim",
		config = function()
			require("config/dashboard")
		end,
	})

	-- neovim statusline plugin written in lua
	use({
		"romgrk/barbar.nvim",
		config = function()
			require("config/tabline")
		end,
		requires = { "kyazdani42/nvim-web-devicons" },
	})

	-- vim syntax highlighting for i3 config
	use({ "mboughaba/i3config.vim" })

	-- intellisense engine for vim8 & neovim, full language server protocol support as vscode
	use({
		"neoclide/coc.nvim",
		branch = "release",
		config = function()
			require("config/coc")
		end,
	})

	-- go development plugin for vim
	use({ "fatih/vim-go" })

	-- a vim plugin which shows a git diff in the gutter (sign column) and stages/undoes hunks.
	use({ "airblade/vim-gitgutter" })
	-- a powerful git log viewer
	use({ "cohama/agit.vim" })
	-- fugitive.vim: a git wrapper so awesome, it should be illegal
	use({ "tpope/vim-fugitive" })

	-- vim plugin for .tmux.conf.
	use({ "tmux-plugins/vim-tmux" })

	-- neovim statusline plugin written in lua
	use({
		"glepnir/galaxyline.nvim",
		branch = "main",
		-- use statusline.lua to setup statusline
		config = function()
			require("config/statusline")
		end,
		requires = { "kyazdani42/nvim-web-devicons" },
		after = { "coc.nvim", "nvim-treesitter" },
	})

	-- vimtex: a modern vim and neovim filetype plugin for latex files.
	use("lervag/vimtex")

	--- pop-up menu for code actions to show meta-information and diff preview
	--[[
  use({
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
  })
  --]]

	-- No-nonsense floating terminal plugin for neovim
	use({
		"numToStr/FTerm.nvim",
		config = function()
			require("config/terminal")
		end,
	})

	-- whichkey is a lua plugin for Neovim 0.5 that displays a popup with
	-- possible keybindings of the command you started typing.
	use("folke/which-key.nvim")
end)
