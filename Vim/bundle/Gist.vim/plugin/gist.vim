"=============================================================================
" File: gist.vim
" Author: Yasuhiro Matsumoto <mattn.jp@gmail.com>
" WebPage: http://github.com/mattn/gist-vim
" License: BSD
" GetLatestVimScripts: 2423 1 :AutoInstall: gist.vim
" script type: plugin

if &cp || (exists('g:loaded_gist_vim') && g:loaded_gist_vim)
  finish
endif
let g:loaded_gist_vim = 1

if !exists('g:github_user') && !executable('git')
  echohl ErrorMsg | echomsg "Gist: require 'git' command" | echohl None
  finish
endif

if !executable('curl')
  echohl ErrorMsg | echomsg "Gist: require 'curl' command" | echohl None
  finish
endif

command! -nargs=? -range=% Gist :call gist#Gist(<count>, <line1>, <line2>, <f-args>)

" vim:set et:
