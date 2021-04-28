-- automatically ensure that packer.nvim is installed
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

return require('packer').startup(function()
  -- packer can manage itself
  use 'wbthomason/packer.nvim'

  -- naz neovim theme
  use {
    '1995parham/naz.vim',
    config = 'vim.cmd[[colorscheme naz]]'
  }

  -- wakatime
  use 'wakatime/vim-wakatime'

  -- nvim Treesitter configurations and abstraction layer
  use {
    'nvim-treesitter/nvim-treesitter',
    config = function() require('treesitter') end,
  }

  -- fzf is a general-purpose command-line fuzzy finder. 
  use {
		'junegunn/fzf.vim',
		requires = {
			'junegunn/fzf.vim',
			run = './install --bin',
		}
  }

	-- vim dashboard
	use {
		'glepnir/dashboard-nvim',
		config = function() require('dashboard') end,
	}

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

end)
