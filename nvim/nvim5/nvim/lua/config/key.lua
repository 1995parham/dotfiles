-- use <space> as a leader key
vim.g.mapleader = ' '

local wk = require("which-key")

wk.setup({})

wk.register({
	w = {
		name = "+windows",
		n = { "<cmd>tabnext<cr>", "next tab" },
		p = { "<cmd>tabprevious<cr>", "previous tab" },
		c = { "<cmd>tabnew<cr>", "new tab" },
		s = { "<cmd>split<cr>", "horizental split" },
		v = { "<cmd>vsplit<cr>", "vertical split" },
		q = { "<cmd>tabclose<cr>", "close tab" },
	},

	b = {
		name = "+buffers",
		n = { "<cmd>bnext<cr>", "next buffer" },
		p = { "<cmd>bprevious<cr>", "previous buffer" },
		k = { "<cmd>bdelete<cr>", "delete buffer" },
		b = { "<cmd>BufferPick<cr>", "buffers" },
	},

  p = {
    name = "+project",
    p = { "<cmd>lua require('telescope').extensions.project.project{ isplay_type = 'full' }<cr>", "project" },
		f = { "<cmd>Telescope find_files<cr>", "find file" },
  },

	o = {
		name = "+open",
		e = { "<cmd>terminal<cr>", "terminal" },
		t = { "<cmd>lua require('FTerm').toggle()<cr>", "floating terminal" },
		p = { "<cmd>NvimTreeToggle<cr>", "project sidebar" }
	},

	f = {
		name = "+files",
		f = { "<cmd>lua require 'telescope'.extensions.file_browser.file_browser()<CR>", "browser" },
		g = { "<cmd>Telescope live_grep<cr>", "grep" },
		n = { "<cmd>enew<cr>", "new file" }
	},

	g = {
		name = "+git",
		g = { "<cmd>Git<cr>", "git" },
	},

  e = {
    name = "+execute",
    t = { "<cmd>lua _G.__fterm_atop()<cr>", "atop" },
    d = { "<cmd>lua _G.__fterm_lazydocker()<cr>", "lazydocker" },
    i = { "<cmd>lua _G.__fterm_ipython()<cr>", "ipython" },
  },

	c = {
		name = "+code",
		r = { '<plug>(coc-rename)', "rename" },
		c = { '<cmd>CocList commands<cr>', "coc commands" },
		f = { '<plug>(coc-format)', "format"},
		s = { "<cmd>lua require'telescope.builtin'.treesitter{}<cr>", "symbols" },
    p = { "<cmd>lua require'telescope.builtin'.planets{}<cr>", "planets" },
		g = {
			name = "+goto",
			d = { '<plug>(coc-definition)', "definition" },
			i = { '<plug>(coc-implementation)', "implementation" },
			r = { '<plug>(coc-references)', "references" },
		}
	}
}, { prefix = "<leader>" })

vim.api.nvim_set_keymap('n', '<C-w>n', ':tabnext<CR>', {})
vim.api.nvim_set_keymap('n', '<C-w>p', ':tabprevious<CR>', {})
vim.api.nvim_set_keymap('n', '<C-w>c', ':tabnew<CR>', {})

-- terminal
vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n>', {silent = true})

-- coc.vim
vim.api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', {silent = true})
vim.api.nvim_set_keymap('n', 'gv', '<Plug>(coc-type-definition)',
	{silent = true})
vim.api
.nvim_set_keymap('n', 'gi', '<Plug>(coc-implementation)', {silent = true})
vim.api.nvim_set_keymap('n', 'gr', '<Plug>(coc-references)', {silent = true})

-- easy align

-- start interactive EasyAlign for a motion/text object (e.g. gaip)
vim.api.nvim_set_keymap('n', 'ga', '<Plug>(EasyAlign)', {silent = true})
