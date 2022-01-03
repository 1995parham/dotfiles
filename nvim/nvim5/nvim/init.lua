require('config/setting')
require('plugin')
require('config/key')
require('config/telescope')

vim.api.nvim_exec([[
	" close the location window automatically when quitting parent window
	augroup qfclose
		au!
		au WinEnter * if winnr('$') == 1 && &buftype == "quickfix"|q|endif
	augroup end
]], false)
