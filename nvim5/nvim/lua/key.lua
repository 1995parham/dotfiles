-- use <space> as a leader key
vim.g.mapleader = ' '

local wk = require("which-key")

-- tabs
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

	o = {
		name = "+open",
		t = { "<cmd>terminal<cr>", "open terminal" }
	},

	f = {
		name = "+files",
		f = { "<cmd>Files<cr>", "find file" },
		n = { "<cmd>enew<cr>", "new file" }
	},

	g = {
		name = "+git",
		g = { "<cmd>Git<cr>", "git" },
	},

        c = {
                name = "+code",
                r = { '<plug>(coc-rename)', "rename" },
                c = { '<cmd>CocList commands<cr>', "coc commands" },
                f = { '<plug>(coc-format)', "format"},
                g = {
                        name = "+goto",
                        d = { '<plug>(coc-definition)', "definition" },
                        i = { '<plug>(coc-implementation)', "implementation" },
                        r = { '<plug>(coc-references)', "references" },
                }
        }
}, { prefix = "<leader>" })

vim.api.nvim_set_keymap('n', '<C-w>n', ':tabnext<CR>', {})
vim.api.nvim_set_keymap('n', '<C-w>p', ':tabnext<CR>', {})

-- terminal
vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n>', {silent = true})

-- coc.vim
vim.api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', {silent = true})
vim.api.nvim_set_keymap('n', 'gv', '<Plug>(coc-type-definition)',
	{silent = true})
vim.api
.nvim_set_keymap('n', 'gi', '<Plug>(coc-implementation)', {silent = true})
vim.api.nvim_set_keymap('n', 'gr', '<Plug>(coc-references)', {silent = true})
