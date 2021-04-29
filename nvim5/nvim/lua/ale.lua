vim.g.ale_sign_error = '⤫'
vim.g.ale_sign_warning = '⚠'

vim.g.ale_rust_cargo_use_clippy = 1

vim.g.ale_linters = {
	go = {'golangci-lint'},
}

vim.g.ale_fixers = {
	['*'] = {'remove_trailing_lines', 'trim_whitespace'},
	python = {'black'},
	rust = {'rustfmt'},
}

vim.g.ale_python_black_options = '--line-length 80'

vim.g.ale_fix_on_save = 1
