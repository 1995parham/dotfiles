syntax on
set t_Co=256

colorscheme molokai
colorscheme cascadia
colorscheme zenzike

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
set smarttab
set number
set ffs=unix,dos,unix
set background=dark

set modeline
set modelines=5

autocmd bufnewfile *.c so /home/parham/.vim/header/c-header.txt
autocmd bufnewfile *.c exe "1, 10 " . "g/File Name :.*/s//File Name : " .expand("%")
autocmd bufnewfile *.c exe "1, 10 " . "g/Creation Date :.*/s//Creation Date : " .strftime("%d-%m-%Y")
autocmd Bufwritepre,filewritepre *.c execute "normal ma"
autocmd Bufwritepre,filewritepre *.c exe "1," . 10 . "g/Last Modified :.*/s/Last Modified :.*/Last Modified : " .strftime("%c")
autocmd bufwritepost,filewritepost *.c execute "normal `a"

autocmd bufnewfile *.cpp so /home/parham/.vim/header/c-header.txt
autocmd bufnewfile *.cpp exe "1, 10 " . "g/File Name :.*/s//File Name : " .expand("%")
autocmd bufnewfile *.cpp exe "1, 10 " . "g/Creation Date :.*/s//Creation Date : " .strftime("%d-%m-%Y")
autocmd Bufwritepre,filewritepre *.cpp execute "normal ma"
autocmd Bufwritepre,filewritepre *.cpp exe "1," . 10 . "g/Last Modified :.*/s/Last Modified :.*/Last Modified : " .strftime("%c")
autocmd bufwritepost,filewritepost *.cpp execute "normal `a"

autocmd bufnewfile *.h so /home/parham/.vim/header/c-header.txt
autocmd bufnewfile *.h exe "1, 10 " . "g/File Name :.*/s//File Name : " .expand("%")
autocmd bufnewfile *.h exe "1, 10 " . "g/Creation Date :.*/s//Creation Date : " .strftime("%d-%m-%Y")
autocmd Bufwritepre,filewritepre *.h execute "normal ma"
autocmd Bufwritepre,filewritepre *.h exe "1," . 10 . "g/Last Modified :.*/s/Last Modified :.*/Last Modified : " .strftime("%c")
autocmd bufwritepost,filewritepost *.h execute "normal `a"

filetype plugin on
filetype indent on

if has('gui_running')
  set guifont=Courier
endif
