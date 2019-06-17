" Settings {{{
syntax on

" UFT-8 Encoding
scriptencoding utf-8
set encoding=utf-8

" Stick unamed register into system clipboard
if $TMUX == ''
        set clipboard+=unnamed
endif

" Correct delete key in OSX
set backspace=eol,start,indent

set ai " Auto indent
set si " Smart indent
set wrap " Wrap lines
set smarttab
set number
set expandtab
set ffs=unix,dos,unix

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

" Setup cursor shape
set guicursor=

" No backup files
set nobackup

" No write backup
set nowritebackup

" No swap file
set noswapfile

" Set leader key
let mapleader = "\<space>"

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

" Set search results highlighting
set hlsearch

set shell=/bin/bash\ -l

" Map <Esc> to exit terminal mode
tnoremap <Esc> <C-\><C-n>

" Let's move between tabs and create them !
nmap <C-w>n :tabnext<CR>
nmap <C-w>p :tabprevious<CR>
nmap <C-w>c :tabnew<CR>
let n = 1
while n < 10
        execute "map <C-w>" . n . " " . n . "gt"
        let n += 1
endwhile

" }}}

" FileType Configurations {{{

" PHP
autocmd Filetype php setlocal ts=4 sts=4 sw=4

" C
autocmd Filetype c setlocal ts=2 sts=2 sw=2

" C++
autocmd Filetype cpp setlocal ts=4 sts=4 sw=4

" Ruby
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2

" Json
autocmd Filetype json setlocal ts=2 sts=2 sw=2

" Vue
autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.javascript
autocmd Filetype vue.javascript setlocal ts=2 sts=2 sw=2

" Babel configuration
autocmd BufRead,BufNewFile .babelrc setlocal filetype=json

" HTML
autocmd Filetype html setlocal ts=2 sts=2 sw=2

" Less
autocmd Filetype less setlocal ts=2 sts=2 sw=2

" JavaScript
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2

" TypeScript
autocmd BufRead,BufNewFile *.tsx setlocal filetype=typescript.tsx
autocmd Filetype typescript setlocal ts=2 sts=2 sw=2
autocmd Filetype typescript.tsx setlocal ts=2 sts=2 sw=2

" Git commit
autocmd Filetype gitcommit setlocal spell textwidth=72

" Arduino
autocmd Filetype arduino setlocal ts=2 sts=2 sw=2

" ZSH
autocmd FileType zsh setlocal ts=2 sts=2 sw=2

" vugu
autocmd BufRead,BufNewFile *.vugu setlocal filetype=vue

" Cursor
autocmd VimLeave * set guicursor=a:ver30

" }}}

" Commands {{{

" Command Mappings
command Spellcheck setlocal spell spelllang=en_us

" }}}

" Plugins {{{
call plug#begin('~/.config/nvim/plugged')

" static plugins all from the github :)
Plug 'junegunn/vim-easy-align'     " a simple, easy-to-use Vim alignment plugin.
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'lervag/vimtex'
Plug 'vim-scripts/textutil.vim'
Plug 'moll/vim-node'
Plug 'digitaltoad/vim-jade'
Plug 'wakatime/vim-wakatime'
Plug '1995parham/vim-zimpl'
Plug '1995parham/vim-gas'
Plug '1995parham/vim-tcpdump'
Plug '1995parham/tomorrow-night-vim'
Plug '1995parham/vim-spice'
Plug 'aolab/vim-avro'
Plug 'w0rp/ale'                    " check syntax in Vim asynchronously and fix files, with Language Server Protocol (LSP) support
Plug 'pangloss/vim-javascript'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'fatih/vim-go'
Plug 'majutsushi/tagbar'
Plug 'bps/vim-tshark'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'othree/html5.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'ap/vim-css-color'
Plug 'tmux-plugins/vim-tmux'       " vim plugin for .tmux.conf.
Plug 'StanAngeloff/php.vim'        " an up-to-date Vim syntax for PHP (7.x supported)
Plug 'mattn/emmet-vim'
Plug 'ervandew/supertab'
Plug 'wellle/targets.vim'
Plug 'kien/rainbow_parentheses.vim'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-tbone'
Plug 'gcmt/wildfire.vim'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-python/python-syntax'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'cohama/agit.vim'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'posva/vim-vue'
Plug 'elzr/vim-json'
Plug 'kylef/apiblueprint.vim'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'vim-scripts/avr8bit.vim'
Plug 'stephpy/vim-yaml'
Plug 'leafgarland/typescript-vim'  " typescript syntax files for Vim
Plug 'peitalin/vim-jsx-typescript' " react JSX syntax highlighting for vim and Typescript
Plug 'Quramy/tsuquyomi'            " a Vim plugin for TypeScript
Plug 'junegunn/fzf.vim'            " things you can do with fzf and Vim.

" plugins with options
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' } " fzf is a general-purpose command-line fuzzy finder.
Plug '1995parham/vim-header', { 'do': ':UpdateRemotePlugins' }

" Add plugins to &runtimepath
call plug#end()

"}}}

" Plugins Configurations {{{

" vim-fzf
nmap <leader><tab> :Files<CR>

" vim-easy-align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" vim-jsx-typescript
" dark red
hi tsxTagName guifg=#E06C75

" orange
hi tsxCloseString guifg=#F99575
hi tsxCloseTag guifg=#F99575
hi tsxAttributeBraces guifg=#F99575
hi tsxEqual guifg=#F99575

" yellow
hi tsxAttrib guifg=#F8BD7F cterm=italic

" wakatime
let g:wakatime_PythonBinary = 'python3'
let g:wakatime_ScreenRedraw = 1

" ultisnips
let g:UltiSnipsExpandTrigger="<c-u>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"

" tomorrow-night
set background=light
if (has("termguicolors"))
        set termguicolors
endif

colorscheme Tomorrow-Night

" Git gutter
let g:gitgutter_enabled = 1
let g:gitgutter_eager = 0
highlight clear SignColumn

" Super tab
let g:SuperTabMappingForward = "<C-h>"

" Emmmet
" only enable normal mode functions.
let g:user_emmet_mode='n'
let g:user_emmet_leader_key='<C-E>'

" vim-header
let g:header_name = 'Parham Alvani'
let g:header_email = 'parham.alvani@gmail.com'

" vim-polygot
let g:polyglot_disabled = ['python', 'javascript']

" ale
" error and warning signs.
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'
" enable integration with airline.
let g:airline#extensions#ale#enabled = 1
" phpstan from vendor directory
let g:ale_php_phpstan_executable = system('if ! type git &> /dev/null; then echo phpstan; else PSE=`git rev-parse --show-toplevel 2> /dev/null`/vendor/bin/phpstan; if [ -x "$PSE" ]; then echo -n $PSE; else echo phpstan; fi; fi')

" vim-go
" please consider that vim-go is not responsible for validating
" go code. ale does this.
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_methods = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_variable_declarations = 1

let g:go_fmt_command = "goimports"
" Simply press K when over a type or function to get more details.
" au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
set statusline+=go#statusline#Show()

" vim-markdown
let g:vim_markdown_math = 1
let g:vim_markdown_folding_disabled = 1

" Tagbar
nmap <F5> :TagbarToggle<CR>
" golang tagbar is enabled by vim-go

" NerdTree
map <C-n> <plug>NERDTreeTabsToggle<CR>
let g:nerdtree_tabs_open_on_console_startup = 2
let g:nerdtree_tabs_synchronize_view = 0

" Airline (status line)
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#taboo#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tagbar#enabled = 1

let g:airline_powerline_fonts = 1

let g:airline_theme = 'tomorrow'

let g:airline_section_c = '%{strftime("%c")}'

" vim-buffergator
map <C-b> :BuffergatorToggle<CR>

" vimtex
let g:vimtex_disable_version_warning = 1

" C
let c_gnu = 1

" CPP
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1

" Python
let g:python_highlight_all = 1

" javascript
let g:javascript_plugin_jsdoc = 1

" Octave
augroup filetypedetect
        au! BufRead,BufNewFile *.m,*.oct set filetype=octave
augroup END

" Use keywords from Octave syntax language file for autocomplete
if has("autocmd") && exists("+omnifunc")
        autocmd Filetype octave
                                \	if &omnifunc == "" |
                                \	setlocal omnifunc=syntaxcomplete#Complete |
                                \	endif

endif

" PHP
function! PhpSyntaxOverride()
        hi! def link phpDocTags  phpDefine
        hi! def link phpDocParam phpType
endfunction

augroup phpSyntaxOverride
        autocmd!
        autocmd FileType php call PhpSyntaxOverride()
augroup END

"}}}
