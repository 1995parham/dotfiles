-- use <Space> as a leader key
vim.g.mapleader = ' '

-- where these mappings are come from,
-- use t for tabs
-- use b for buffers
-- use o for open
-- use g for git
-- use f for files
-- use c for coc

-- tabs
vim.api.nvim_set_keymap('n', '<Leader>tn', ':tabnext<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>tp', ':tabprevious<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>tc', ':tabnew<CR>', {})

-- buffers
vim.api.nvim_set_keymap('n', '<Leader>bn', ':bnext<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>bp', ':bprevious<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>bk', ':bdelete<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>bb', ':BufferPick<CR>', { silent = true })

-- terminal
vim.api.nvim_set_keymap('n', '<Leader>ot', ':terminal<CR>', { silent = true })
vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n>', { silent = true })

-- fzf.vim
vim.api.nvim_set_keymap('n', '<Leader>ff', ':Files<CR>', { silent = true })

-- git
vim.api.nvim_set_keymap('n', '<Leader>gg', ':Git<CR>', { silent = true })

-- coc.vim
vim.api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', { silent = true })
vim.api.nvim_set_keymap('n', 'gv', '<Plug>(coc-type-definition)', { silent = true })
vim.api.nvim_set_keymap('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
vim.api.nvim_set_keymap('n', 'gr', '<Plug>(coc-references)', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>cc', ':<C-u>CocList commands<CR>', { silent = true })
