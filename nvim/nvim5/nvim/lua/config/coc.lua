vim.g.coc_global_extensions = {
    'coc-json', 'coc-html', 'coc-css', 'coc-tsserver',
    'coc-snippets', 'coc-pyright',
    'coc-tslint-plugin', 'coc-rust-analyzer', 'coc-vimtex', 'coc-angular',
    'coc-toml', 'coc-java',
    'coc-prettier', 'coc-texlab', 'coc-clangd',
    'coc-yaml', 'coc-metals'
}

vim.g.coc_filetype_map = {['yaml.docker-compose'] = 'yaml'}

-- highlight the symbol and its references when holding the cursor.
-- scroll in floating window
vim.api.nvim_exec([[
autocmd CursorHold * silent call CocActionAsync('highlight')

inoremap <silent><expr> <c-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<c-j>"
inoremap <silent><expr> <c-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<c-k>"
vnoremap <silent><expr> <c-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<c-j>"
vnoremap <silent><expr> <c-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<c-k>"
]], false)
