-- automatically ensure that packer.nvim is installed
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({
		'git', 'clone', 'https://github.com/wbthomason/packer.nvim',
		install_path
	})
	execute 'packadd packer.nvim'
end

return require('packer').startup(function()
	-- packer can manage itself
	use {'wbthomason/packer.nvim'}

	-- naz neovim theme
	use {
		'1995parham/naz.vim',
		branch = 'main',
		config = function() require('colorbuddy').colorscheme('naz') end,
		requires = {'tjdevries/colorbuddy.nvim'}
	}

	-- wakatime
	use 'wakatime/vim-wakatime'

	-- nvim Treesitter configurations and abstraction layer
	use {
		'nvim-treesitter/nvim-treesitter',
		config = function() require('treesitter') end
	}

	-- fzf is a general-purpose command-line fuzzy finder.
	use {
		'junegunn/fzf.vim',
		requires = {'junegunn/fzf.vim', run = './install --bin'}
	}

	-- check syntax in vim asynchronously and fix files, with language server protocol (lsp) support
	use {
		'w0rp/ale',
		setup = function() require('ale') end
	}

	-- vim plugin for shfmt
	use {
		'z0mbix/vim-shfmt',
		ft = {'sh'},
		setup = function() vim.g.shfmt_fmt_on_save = 1 end
	}

	-- vim dashboard
	use {'glepnir/dashboard-nvim', config = function() require('dashboard') end}

	-- neovim statusline plugin written in lua
	use {
		'romgrk/barbar.nvim',
		config = function() require('tabline') end,
		requires = {'kyazdani42/nvim-web-devicons'}
	}

	-- neovim statusline plugin written in lua
	use {
		'glepnir/galaxyline.nvim',
		branch = 'main',
		-- use statusline.lua to setup statusline
		config = function() require('statusline') end,
		requires = {'kyazdani42/nvim-web-devicons'}
	}

	-- vim syntax highlighting for i3 config
	use {'mboughaba/i3config.vim', ft = {'i3config'}}

	-- intellisense engine for vim8 & neovim, full language server protocol support as vscode
	use {
		'neoclide/coc.nvim',
		branch = 'release',
		config = function() require('coc') end
	}

	-- go development plugin for vim
	use {'fatih/vim-go'}

	-- a vim plugin which shows a git diff in the gutter (sign column) and stages/undoes hunks.
	use {'airblade/vim-gitgutter'}
	-- a powerful git log viewer
	use {'cohama/agit.vim'}
	-- fugitive.vim: a git wrapper so awesome, it should be illegal
	use {'tpope/vim-fugitive'}

	-- whichkey is a lua plugin for Neovim 0.5 that displays a popup with
	-- possible keybindings of the command you started typing.
	use {
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup {
			}
		end
	}
end)
