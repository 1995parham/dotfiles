syntax on
set t_Co=256


"colorscheme molokai
"colorscheme cascadia
"colorscheme zenzike

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
"

" }}}

" Commands {{{
" File formats
autocmd Filetype gitcommit setlocal spell textwidth=72

" }}}

set modeline
set modelines=5

" Command for automating file header creation. {{{
autocmd bufnewfile *.c so /home/parham/.vim/header/c-header.txt
autocmd bufnewfile *.c exe "1, 10 " . "g/File Name :.*/s//File Name : " . expand("%")
autocmd bufnewfile *.c exe "1, 10 " . "g/Creation Date :.*/s//Creation Date : " . strftime("%d-%m-%Y")
autocmd Bufwritepre,filewritepre *.c execute "normal mb"
autocmd Bufwritepre,filewritepre *.c exe "1, 10 " . "g/Last Modified :.*/s/Last Modified :.*/Last Modified : " . strftime("%c")
autocmd bufwritepost,filewritepost *.c execute "normal `b"

autocmd bufnewfile *.cpp so /home/parham/.vim/header/c-header.txt
autocmd bufnewfile *.cpp exe "1, 10 " . "g/File Name :.*/s//File Name : " . expand("%")
autocmd bufnewfile *.cpp exe "1, 10 " . "g/Creation Date :.*/s//Creation Date : " . strftime("%d-%m-%Y")
autocmd Bufwritepre,filewritepre *.cpp execute "normal mb"
autocmd Bufwritepre,filewritepre *.cpp exe "1, 10 " . "g/Last Modified :.*/s/Last Modified :.*/Last Modified : " . strftime("%c")
autocmd bufwritepost,filewritepost *.cpp execute "normal `b"

autocmd bufnewfile *.h so /home/parham/.vim/header/c-header.txt
autocmd bufnewfile *.h exe "1, 10 " . "g/File Name :.*/s//File Name : " . expand("%")
autocmd bufnewfile *.h exe "1, 10 " . "g/Creation Date :.*/s//Creation Date : " . strftime("%d-%m-%Y")
autocmd Bufwritepre,filewritepre *.h execute "normal mb"
autocmd Bufwritepre,filewritepre *.h exe "1, 10 " . "g/Last Modified :.*/s/Last Modified :.*/Last Modified : " . strftime("%c")
autocmd bufwritepost,filewritepost *.h execute "normal `b"

autocmd bufnewfile *.asm so /home/parham/.vim/header/asm-header.txt
autocmd bufnewfile *.asm exe "1, 10 " . "g/File Name :.*/s//File Name : " . expand("%")
autocmd bufnewfile *.asm exe "1, 10 " . "g/Creation Date :.*/s//Creation Date : " . strftime("%d-%m-%Y")
autocmd Bufwritepre,filewritepre *.asm execute "normal mb"
autocmd Bufwritepre,filewritepre *.asm exe "1, 10 " . "g/Last Modified :.*/s/Last Modified :.*/Last Modified : " . strftime("%c")
autocmd bufwritepost,filewritepost *.asm execute "normal `b"
" }}}

if has('gui_running')
  set guifont=Courier
endif
