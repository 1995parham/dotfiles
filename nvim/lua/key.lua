-- use <Space> as a leader key
vim.g.mapleader = ' '

-- where these mappings are come from,
-- use t for tabs
-- use b for buffers
-- use o for open

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

-- files
vim.api.nvim_set_keymap('n', '<Leader>ff', ':Files<CR>', { silent = true })
