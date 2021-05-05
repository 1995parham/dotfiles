require('setting')
require('plugin')
require('key')

vim.api.nvim_exec([[
	autocmd BufNewFile,BufRead ~/.config/i3/config set filetype=i3config

	" close the location window automatically when quitting parent window
	augroup qfclose
		au!
		au WinEnter * if winnr('$') == 1 && &buftype == "quickfix"|q|endif
	augroup end
]], false)
