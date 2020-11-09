" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
                execute 'h '.expand('<cword>')
        else
                call CocAction('doHover')
        endif
endfunction

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" you can use :Prettier to format current buffer.
command! -nargs=0 Prettier :CocCommand prettier.formatFile

let g:coc_global_extensions = [
                        \ 'coc-json', 'coc-html', 'coc-css',
                        \ 'coc-rls', 'coc-tsserver', 'coc-snippets',
                        \ 'coc-python', 'coc-yaml', 'coc-pyright', 'coc-tslint-plugin',
                        \ 'coc-rust-analyzer', 'coc-vimtex', 'coc-angular', 'coc-prettier' ]

let g:coc_filetype_map = {
                        \ 'yaml.docker-compose': 'yaml',
                        \ }
