" Settings {{{
syntax on

" UFT-8 Encoding
set encoding=utf-8
scriptencoding utf-8

" Stick unamed register into system clipboard
if $TMUX ==# ''
        set clipboard+=unnamed
endif

" Correct delete key in OSX
set backspace=eol,start,indent

set autoindent  " Auto indent
set smartindent " Smart indent
set wrap        " Wrap lines
set smarttab
set number
set expandtab
set fileformats=unix,dos,unix

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

" look for a tags file recursively in parent directories
set tags=tags;

" Map <Esc> to exit terminal mode
tnoremap <Esc> <C-\><C-n>

" Let's move between tabs and create them with ease
nmap <C-w>n :tabnext<CR>
nmap <C-w>p :tabprevious<CR>
nmap <C-w>c :tabnew<CR>

" lazy drawing
" https://github.com/tmux/tmux/issues/353#issuecomment-342741778
set lazyredraw
set ttyfast

" }}}

" FileType Configurations {{{

augroup format
        " PHP
        autocmd Filetype php setlocal ts=4 sts=4 sw=4

        " C
        autocmd Filetype c setlocal ts=2 sts=2 sw=2

        " C++
        autocmd Filetype cpp setlocal ts=4 sts=4 sw=4

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
        autocmd BufRead,BufNewFile *.jsx setlocal filetype=javascript.jsx
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
augroup end

" }}}

" Commands {{{

" Command Mappings
command Spellcheck setlocal spell spelllang=en_us

" }}}

" Plugins {{{
call plug#begin('~/.config/nvim/plugged')

" wisely add "end" in ruby, endfunction/endif/more in vim script, etc
Plug 'tpope/vim-endwise'

" Surround.vim is all about "surroundings": parentheses, brackets, quotes, XML tags, and more.
" The plugin provides mappings to easily delete, change and add such surroundings in pairs.
Plug 'tpope/vim-surround'

" Vim plugin for editing rtf,rtfd,doc,wordml files.
Plug 'vim-scripts/textutil.vim'

" Vim bookmark plugin that allows toggling bookmarks per line
" Plug 'MattesGroeger/vim-bookmarks'

" Velenjak Neovim Theme
Plug '1995parham/velenjak.vim'

" Vim plugin, insert or delete brackets, parens, quotes in pair
Plug 'jiangmiao/auto-pairs'

" fugitive.vim: A Git wrapper so awesome, it should be illegal
Plug 'tpope/vim-fugitive'

" A Vim plugin to visualizes the Vim undo tree.
Plug 'simnalamburt/vim-mundo'

" Vim plugin that displays tags in a window, ordered by scope
Plug 'majutsushi/tagbar'

" Vim plugin to list, select and switch between buffers.
Plug 'jeetsukumaran/vim-buffergator'

" vim plugin that provides additional text objects
Plug 'wellle/targets.vim'

" vim-wakatime
Plug 'wakatime/vim-wakatime'

" A solid language pack for Vim.
Plug 'sheerun/vim-polyglot'

" git
Plug 'airblade/vim-gitgutter' " A Vim plugin which shows a git diff in the gutter (sign column) and stages/undoes hunks.
Plug 'cohama/agit.vim'        " A powerful Git log viewer

" nerdtree
Plug 'jistr/vim-nerdtree-tabs'     " NERDTree and tabs together in Vim, painlessly
Plug 'scrooloose/nerdtree'         " A tree explorer plugin for vim.
Plug 'Xuyuanp/nerdtree-git-plugin' " A plugin of NERDTree showing git status

" a simple, easy-to-use Vim alignment plugin.
Plug 'junegunn/vim-easy-align'

" EditorConfig plugin for Vim
Plug 'editorconfig/editorconfig-vim'

" check syntax in Vim asynchronously and fix files, with Language Server Protocol (LSP) support
Plug 'w0rp/ale'

" lean & mean status/tabline for vim that's light as air
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" snippets
Plug 'SirVer/ultisnips'            " UltiSnips - The ultimate snippet solution for Vim
Plug 'honza/vim-snippets'          " vim-snipmate default snippets
Plug 'epilande/vim-react-snippets' " React code snippets for vim

" fuzzy finder (try space with tab)
Plug 'junegunn/fzf.vim'                                           " things you can do with fzf and Vim.
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' } " fzf is a general-purpose command-line fuzzy finder.

" language specific
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }     " Go development plugin for Vim
Plug 'leafgarland/typescript-vim'                      " typescript syntax files for Vim
Plug 'peitalin/vim-jsx-typescript'                     " react JSX syntax highlighting for vim and Typescript
Plug 'Quramy/tsuquyomi'                                " a Vim plugin for TypeScript
Plug 'StanAngeloff/php.vim'                            " an up-to-date Vim syntax for PHP (7.x supported)
Plug 'tmux-plugins/vim-tmux'                           " vim plugin for .tmux.conf.
Plug 'mrk21/yaml-vim'                                  " YAML syntax/indent plugin for Vim
Plug 'vim-scripts/avr8bit.vim'                         " for Atmel 8bit Microcontroller
Plug 'JuliaEditorSupport/julia-vim'                    " Vim support for Julia.
Plug 'ekalinin/Dockerfile.vim'                         " Vim syntax file & snippets for Docker's Dockerfile
Plug 'elzr/vim-json'                                   " A better JSON for Vim: distinct highlighting of keywords vs values, JSON-specific (non-JS) warnings, quote concealing. Pathogen-friendly.
Plug 'posva/vim-vue'                                   " Syntax Highlight for Vue.js components
Plug 'othree/html5.vim'                                " HTML5 omnicomplete and syntax
" Plug 'digitaltoad/vim-jade'                          " Vim syntax highlighting for Pug (formerly Jade) templates.
Plug 'andrewstuart/vim-kubernetes'                     " This package provides kubernetes YAML snippets, as well as a growing number of integrations with kubectl.
Plug 'bps/vim-tshark'                                  " A Vim plugin to make it easy to read pcap dumps.
Plug 'vim-python/python-syntax'                        " Python syntax highlighting for Vim
Plug 'Shirk/vim-gas'                                   " Advanced syntax highlighting for GNU As
Plug 'pangloss/vim-javascript'                         " Vastly improved Javascript indentation and syntax support in Vim
Plug 'othree/javascript-libraries-syntax.vim'          " Syntax for JavaScript libraries
Plug 'plasticboy/vim-markdown'                         " Markdown Vim Mode
Plug 'octol/vim-cpp-enhanced-highlight'                " Additional Vim syntax highlighting for C++
Plug 'ap/vim-css-color'                                " Preview colours in source code while editing
Plug 'rust-lang/rust.vim'                              " Vim configuration for Rust.
Plug 'psf/black'                                       " The uncompromising code formatter
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'} " Semantic Highlighting for Python in Neovim


" vimproc is a great asynchronous execution library for Vim.
Plug 'Shougo/vimproc.vim', {'do' : 'make'}

" easily adds brief author info and license headers
Plug '1995parham/vim-header', { 'do': ':UpdateRemotePlugins' }

" Add plugins to &runtimepath
call plug#end()

" }}}

" Plugins Configurations {{{

" vim-fzf {{{
nmap <leader><tab> :Files<CR>
" }}}

" vim-easy-align {{{
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" }}}

" vim-jsx-typescript {{{
" dark red
hi tsxTagName guifg=#E06C75

" orange
hi tsxCloseString guifg=#F99575
hi tsxCloseTag guifg=#F99575
hi tsxAttributeBraces guifg=#F99575
hi tsxEqual guifg=#F99575

" yellow
hi tsxAttrib guifg=#F8BD7F cterm=italic
" }}}

" wakatime {{{
let g:wakatime_PythonBinary = 'python3'
let g:wakatime_ScreenRedraw = 1
" }}}

" ultisnips {{{
let g:UltiSnipsExpandTrigger = '<c-u>'
let g:UltiSnipsJumpForwardTrigger = '<c-b>'
let g:UltiSnipsJumpBackwardTrigger = '<c-z>'
let g:UltiSnipsEditSplit = 'vertical'
" }}}

" velenjak.vim {{{
if (has('termguicolors'))
        set termguicolors
endif

let g:velenjak_term_italic = 1
colorscheme velenjak
" }}}

" gitgutter {{{
let g:gitgutter_enabled = 1
let g:gitgutter_eager = 0
highlight clear SignColumn
" }}}

" vim-header {{{
let g:header_name = 'Parham Alvani'
let g:header_email = 'parham.alvani@gmail.com'
" }}}

" vim-polygot {{{
let g:polyglot_disabled = ['python', 'javascript']
" }}}

" ale {{{
" error and warning signs.
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'
" enable integration with airline.
let g:airline#extensions#ale#enabled = 1
" phpstan from vendor directory
let g:ale_php_phpstan_executable = system('if ! type git &> /dev/null; then echo phpstan; else PSE=`git rev-parse --show-toplevel 2> /dev/null`/vendor/bin/phpstan; if [ -x "$PSE" ]; then echo -n $PSE; else echo phpstan; fi; fi')
" set golang linters
let g:ale_linters = {'go': ['gometalinter', 'gofmt', 'staticcheck', 'gobuild', 'gosimple', 'golint', 'govet']}
" }}}

" vim-go {{{
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

let g:go_fmt_command = 'goimports'
" Simply press K when over a type or function to get more details.
" au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
set statusline+=go#statusline#Show()
" }}}

" vim-markdown {{{
let g:vim_markdown_math = 1
let g:vim_markdown_folding_disabled = 1
" }}}

" Tagbar {{{
nmap <F5> :TagbarToggle<CR>
" golang tagbar is enabled by vim-go
" }}}

" nerdtree {{{
map <C-n> <plug>NERDTreeTabsToggle<CR>
let g:nerdtree_tabs_open_on_console_startup = 2
let g:nerdtree_tabs_synchronize_view = 0
let g:NERDTreeIndicatorMapCustom = {
    \ 'Modified'  : '✹',
    \ 'Staged'    : '✚',
    \ 'Untracked' : '✭',
    \ 'Renamed'   : '➜',
    \ 'Unmerged'  : '═',
    \ 'Deleted'   : '✖',
    \ 'Dirty'     : '✗',
    \ 'Clean'     : '✔︎',
    \ 'Ignored'   : '☒',
    \ 'Unknown'   : '?'
    \ }
" }}}

" Airline (status line) {{{
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#taboo#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tagbar#enabled = 1

let g:airline_powerline_fonts = 1

let g:airline_theme = 'tomorrow'

let g:airline_section_c = '%{strftime("%c")}'
" }}}

" vim-buffergator {{{
map <C-b> :BuffergatorToggle<CR>
" }}}

" vimtex {{{
let g:vimtex_disable_version_warning = 1
" }}}

" c {{{
let c_gnu = 1
" }}}

" cpp {{{
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
" }}}

" python {{{
let g:python_highlight_all = 1
" }}}

" javascript {{{
let g:javascript_plugin_jsdoc = 1
" }}}

" octave {{{
augroup filetypedetect
        au! BufRead,BufNewFile *.m,*.oct set filetype=octave
augroup END
" }}}

" vim-gas {{{
augroup gas
        autocmd BufRead,BufNewFile *.S set filetype=gas
augroup end
" }}}

"}}}
