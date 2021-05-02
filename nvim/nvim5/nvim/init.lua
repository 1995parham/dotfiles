require('setting')
require('plugin')
require('key')

vim.api.nvim_exec([[
	autocmd BufNewFile,BufRead ~/.config/i3/config set filetype=i3config
]], false)
