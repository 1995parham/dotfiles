" Settings {{{
syntax on

" Stick unamed register into system clipboard
set clipboard+=unnamed

" Correct delete key in OSX
set backspace=eol,start,indent

set ai " Auto indent
set si " Smart indent
set wrap " Wrap lines
set smarttab
set number
set ffs=unix,dos,unix
set background=dark

" Use vim, not vi api
set nocompatible

" Get rid of the delay when pressing O (for example)
" http://stackoverflow.com/questions/2158516/vim-delay-before-o-opens-a-new-line
set timeout timeoutlen=1000 ttimeoutlen=100

" Always show status bar
set laststatus=2

" Set the status line to something useful
set statusline=%f\ %=L:%l/%L\ %c\ (%p%%)

" Hide the toolbar
set guioptions-=T

" No backup files
" set nobackup

" No write backup
" set nowritebackup

" No swap file
" set noswapfile

" Always show cursor
set ruler

" Make sure any searches /searchPhrase doesn't need the \c escape character 
set ignorecase

" Ignore case in search
set smartcase

" Autoload files that have changed outside of vim
set autoread

" Highlight tailing whitespace
set list listchars=tab:\ \ ,trail:·

" Mod line supporting
set modeline
set modelines=5

" Set folding type in marker
set foldmethod=marker

" }}}

" Plugins {{{
execute pathogen#infect()
filetype plugin indent on " Required by Pathogen Plugin Manager

" Theme
set background=light
colorscheme Tomorrow-Night

" Airline (status line)
let g:airline_powerline_fonts = 1

" Git gutter
let g:gitgutter_enabled = 1
let g:gitgutter_eager = 0
let g:gitgutter_sign_column_always = 1
highlight clear SignColumn

" Super tab
let g:SuperTabMappingForward = "<C-h>"

" }}}

" Commands {{{
" File formats
autocmd Filetype gitcommit setlocal spell textwidth=72

" }}}

" C syntax {{{
let c_gnu = 1
" }}}

" Python syntax {{{
let python_highlight_all = 1
" }}}

" Command for automating file header creation. {{{
autocmd bufnewfile *.c,*.cpp,*.h,*.s,*.S so $HOME/.vim/header/c-header.txt
autocmd bufnewfile *.c,*.cpp,*.h,*.s,*.S exe "1, 10 " . "g/File Name :.*/s//File Name : " . expand("%")
autocmd bufnewfile *.c,*.cpp,*.h,*.s,*.S exe "1, 10 " . "g/Creation Date :.*/s//Creation Date : " . strftime("%d-%m-%Y")
autocmd Bufwritepre,filewritepre *.c,*.cpp,*.h,*.s,*.S exe "normal mb"
autocmd Bufwritepre,filewritepre *.c,*.cpp,*.h,*.s,*.S exe "1, 10 " . "g/Last Modified :.*/s/Last Modified :.*/Last Modified : " . strftime("%c")
autocmd bufwritepost,filewritepost *.c,*.cpp,*.h,*.s,*.S exe "normal `b"

autocmd bufnewfile Makefile so $HOME/.vim/header/Makefile.txt
autocmd bufnewfile Makefile exe "1, 10 " . "g/Creation Date :.*/s//Creation Date : " . strftime("%d-%m-%Y")

autocmd bufnewfile *.asm so $HOME/.vim/header/asm-header.txt
autocmd bufnewfile *.asm exe "1, 10 " . "g/File Name :.*/s//File Name : " . expand("%")
autocmd bufnewfile *.asm exe "1, 10 " . "g/Creation Date :.*/s//Creation Date : " . strftime("%d-%m-%Y")
autocmd Bufwritepre,filewritepre *.asm exe "normal mb"
autocmd Bufwritepre,filewritepre *.asm exe "1, 10 " . "g/Last Modified :.*/s/Last Modified :.*/Last Modified : " . strftime("%c")
autocmd bufwritepost,filewritepost *.asm exe "normal `b"

autocmd bufnewfile *.bash so $HOME/.vim/header/bash-header.txt
autocmd bufnewfile *.bash exe "1, 10 " . "g/File Name :.*/s//File Name : " . expand("%")
autocmd bufnewfile *.bash exe "1, 10 " . "g/Creation Date :.*/s//Creation Date : " . strftime("%d-%m-%Y")
autocmd Bufwritepre,filewritepre *.bash exe "normal mb"
autocmd Bufwritepre,filewritepre *.bash exe "1, 10 " . "g/Last Modified :.*/s/Last Modified :.*/Last Modified : " . strftime("%c")
autocmd bufwritepost,filewritepost *.bash exe "normal `b"

autocmd bufnewfile *.py so $HOME/.vim/header/python-header.txt
autocmd bufnewfile *.py exe "1, 10 " . "g/File Name :.*/s//File Name : " . expand("%")
autocmd bufnewfile *.py exe "1, 10 " . "g/Creation Date :.*/s//Creation Date : " . strftime("%d-%m-%Y")
autocmd Bufwritepre,filewritepre *.py exe "normal mb"
autocmd Bufwritepre,filewritepre *.py exe "1, 10 " . "g/Last Modified :.*/s/Last Modified :.*/Last Modified : " . strftime("%c")
autocmd bufwritepost,filewritepost *.py exe "normal `b"

autocmd bufnewfile *.vim so $HOME/.vim/header/vim-header.txt
autocmd Bufwritepre,filewritepre *.vim exe "normal mb"
autocmd Bufwritepre,filewritepre *.vim exe "1, 5 " . "g/Last Change:.*/s/Last Change:.*/Last Change:	" . strftime("%Y %b %d")
autocmd bufwritepost,filewritepost *.vim exe "normal `b"

"
" }}}
