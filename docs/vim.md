---
title: VIM for dummy
layout: page
theme: green
---

# VIM for dummy

## VIM is your IDE

If you are using this dotfiles vim configuration
you can use following scripts to have better vim :D

### C

If your c file is big and you want a function in it
do not install jetbrains stuff :D just use CLint in
your vim with following command:

```sh
sudo apt install ctags
```

### JavaScript

Personally I use ESLint as linter for my JS projects
and you can setup it with following command and use it
simply in all of your project.

```sh
# setup eslint globally
sudo npm install -g eslint
sudo npm install -g eslint-plugin-standard
sudo npm install -g eslint-config-standard
# setup project folder
npm init
eslint --init
```

### PHP

Personally I use PHP_CodeSniffer as code style checker
for my php files.

```sh
# setup phpcs globally
composer global require "squizlabs/php_codesniffer=*"
phpcs --config-set default_standard PSR2
```

### Python

It's very good idea to use `pyvenv` in order to creating
python project environment. Build your environment with:

```sh
pyvenv $PROJECT_ROOT
. $PROJECT_ROOT/bin/activate
```

after you do your works you can deactivate your virtual
environment with

```sh
deactivate
```

### Go

It's very simple, just execute `:GoInstallBinaries` in vim normal mode.
After that you have complete IDE for go in vim.


| Shortcut         | Description                         |
|:----------------:|:------------------------------------|
| `:GoMetaLinter`  | Statically checking Go source       |
| `<Leader>gv`     | GoDoc in vertical pane              |
| `:GeDoc`         | GoDoc with [GoExplorer](https://github.com/garyburd/go-explorer)               |
|`:GoDoc`          | GoDoc == GeDoc if vim-go is plugged |


## Plugins

| #  | Plugin     | #  | Plugin                 |
|:--:|:-----------|:--:|:-----------------------|
| 1  | [easy-align](http://github.com/junegunn/vim-easy-align) | 2  | [cpp-enhanced-highlight](http://github.com/octol/vim-cpp-enhanced-highlight) |
| 3  | [vimtex](http://github.com/lervag/vimtex)     | 4  | [textutil](http://github.com/vim-scripts/textutil.vim)               |
| 5  | [node](http://github.com/moll/vim-node)       | 6  | [jade](http://github.com/digitaltoad/vim-jade)                   |
| 7  | [wakatime](http://github.com/wakatime/vim-wakatime)   | 8  | [zimpl](http://github.com/1995parham/vim-zimpl)                  |
| 9  | [gas](http://github.com/1995parham/vim-gas)        | 10 | [tcpdump](http://github.com/1995parham/vim-tcpdump)                |
| 11 | [spice](http://github.com/1995parham/vim-spice)      | 12 | [tomorrow-night](http://github.com/1995parham/tomorrow-night-vim)         |
| 13 | [avro](http://github.com/aolab/vim-avro)       | 14 | [python-syntax](http://github.com/hdima/python-syntax)          |
| 15 | [syntastic](http://github.com/scrooloose/syntastic)  | 16 | [javascript-syntax](http://github.com/jelera/vim-javascript-syntax)      |
| 17 | [js-indent](http://github.com/gavocanov/vim-js-indent)  | 18 | [gitgutter](http://github.com/airblade/vim-gitgutter)              |
| 19 | [airline](http://github.com/vim-airline/vim-airline)    | 20 | [airline-themes](http://github.com/vim-airline/vim-airline-themes)         |
| 21 | [vim2hs](http://github.com/dag/vim2hs)     | 22 | [go](http://github.com/fatih/vim-go)                     |
| 23 | [tagbar](http://github.com/majutsushi/tagbar)     | 24 | [tshark](http://github.com/bps/vim-tshark)                 |
| 25 | [tabular](http://github.com/godlygeek/tabular)    | 26 | [markdown](http://github.com/plasticboy/vim-markdown)               |
| 27 | [bookmarks](http://github.com/MattesGroeger/vim-bookmarks)  | 28 | [html5](http://github.com/othree/html5.vim)                  |
| 29 | [docker](http://github.com/ekalinin/Dockerfile.vim)     | 30 | [css-color](http://github.com/ap/vim-css-color)              |
| 31 | [webapi](http://github.com/mattn/webapi-vim)     | 32 | [tmux](http://github.com/tmux-plugins/vim-tmux)                   |
| 33 | [emmet](http://github.com/mattn/emmet-vim)      | 34 | [supertab](http://github.com/ervandew/supertab)               |
| 35 | [targets](http://github.com/wellle/targets.vim)    | 36 | [rainbow_parentheses](http://github.com/kien/rainbow_parentheses.vim)    |
| 37 | [endwise](http://github.com/tpope/vim-endwise)    | 38 | [fugitive](http://github.com/tpope/vim-fugitive)               |
| 39 | [surround](http://github.com/tpope/vim-surround)   | 40 | [polyglot](http://github.com/sheerun/vim-polyglot)               |
| 41 | [tbone](http://github.com/tpope/vim-tbone)      | 42 | [wildfire](http://github.com/gcmt/wildfire.vim)               |
| 43 | [nerdtree](http://github.com/scrooloose/nerdtree)   | 44 | [js-libraries-syntax](http://github.com/othree/javascript-libraries-syntax.vim)    |
| 45 | [vim-ruby](http://github.com/vim-ruby/vim-ruby)   | 46 | [gocode](http://github.com/nsf/gocode)                 |
| 47 | [taboo](http://github.com/gcmt/taboo.vim)      | 48 | [vim-nerdtree-tabs](http://github.com/jistr/vim-nerdtree-tabs)      |
| 49 | [Agit](http://github.com/cohama/agit.vim)       | 50 | [vim-buffergator](http://github.com/jeetsukumaran/vim-buffergator)        |
| 51 | [vim-man](http://github.com/vim-utils/vim-man)    | 52 | [go-explorer](http://github.com/garyburd/go-explorer)            |


## Shortcuts

### Core

#### General Commands

| Shortcut         | Description               |
|:----------------:|:--------------------------|
| `<C-n>`          | Toggles [NerdTree](https://github.com/scrooloose/nerdtree)          |
| `<C-h>`          | Toggles [SuperTab](https://github.com/ervandew/supertab)          |
| `<C-b>`          | Toogles [Buffergator](https://github.com/jeetsukumaran/vim-buffergator)       |
| `<F5>`           | Toggles [Tagbar](https://github.com/majutsushi/tagbar)            |
| `<C-w> <Left>`   | Move to left window       |
| `<C-w> <Right>`  | Move to right window      |
| `<C-w> <Up>`     | Move to up window         |
| `<C-w> <Down>`   | Move to down window       |
| `<C-w> s`        | New horizontal window     |
| `<C-w> v`        | New vertical window       |
| `<C-w> n`        | Move to next tab          |
| `<C-w> p`        | Move to previous tab      |
| `<C-w> c`        | New empty tab             |
| `<C-w> nn`       | Move to tab number nn     |
| `-`              | Leader Key                |
| `J`              | Join lines                |
| `u`              | Undo                      |
| `.`              | Redo                      |

#### Movement Commands

| Shortcut         | Description                         |
|:----------------:|:------------------------------------|
| `0` `$`          | Begin/End of line                   |
| `G` `gg`         | Begin/End of file                   |
| `w` `b`          | Next/Prev word                      |
| `<C-U>` `<C-D>`  | Next/Prev page                      |
| `H` `M` `L`      | Top/Mid/Btm of win                  |
| `zt` `zz` `zb`   | Scroll to top/mid/btm               |
| `%`              | Matching parenthesis                |

#### Search Commands

| Shortcut         | Description                         |
|:----------------:|:------------------------------------|
| `*` `#`          | Find current word backward/forward  |
| `n` `N`          | Next/Prev search result             |

#### EX Commands

| Shortcut         | Description               | Shortcut         | Description                         |
|:----------------:|:--------------------------|:----------------:|:------------------------------------|
| `:b name`        | Open buffer               | `:bd name`       | Delete buffer                       |
| `:Agit`          | Git log manager           | `:edit`          | Reload current file                 |
| `:edit!`         | Reload current file force | `:edit x`        | Edit file x                         |

#### Mode Commands

| Shortcut         | Description                         |
|:----------------:|:------------------------------------|
| `<ESC>`          | Enter *Normal* mode                 |
| `v`              | Enter *Visual* mode                 |
| `V`              | Enter *Visual Line* mode            |
| `i`              | Enter *Insert* mode                 |
| `I`              | Enter *Insert* mode [head of line]  |
| `a`              | Enter *Insert* mode [next position] |
| `A`              | Enter *Insert* mode [end of line]   |
| `R`              | Enter *Replace* mode                |

### NerdTree and Buffergator

| Shortcut | Description            |
|:--------:|:-----------------------|
| `s`      | open file vsplit       |
| `i`      | open file split        |
| `t`      | open file in new tab   |
| `o`      | open & close directory |
| `m`      | show menu              |

