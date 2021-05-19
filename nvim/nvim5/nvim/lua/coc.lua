vim.g.coc_global_extensions = {
    'coc-json', 'coc-html', 'coc-css', 'coc-rls', 'coc-tsserver',
    'coc-snippets', 'coc-python', 'coc-yaml', 'coc-pyright',
    'coc-tslint-plugin', 'coc-rust-analyzer', 'coc-vimtex', 'coc-angular',
    'coc-prettier', 'coc-texlab',
}

vim.g.coc_filetype_map = {['yaml.docker-compose'] = 'yaml'}

-- highlight the symbol and its references when holding the cursor.
vim.api.nvim_exec([[
autocmd CursorHold * silent call CocActionAsync('highlight')
]], false)
