## VIM is your IDE

If you are using this dotfiles (neo)vim configuration
you can use following scripts and informations for having better (neo)vim.

### C

If your c file is big and you want to find just a function in it
don't install jetbrains *** stuff, just use CTags in
your vim with following command (it will install with `./scripts/env.sh`).

```sh
sudo apt install ctags
```

### JavaScript

Personally I use [eslint](https://eslint.org/) as linter for my node and js projects.
It can be configured by many aspects and styles. Personally I use standard
style of Javascript which can be configured on eslint by following comamnds and yaml configurations.
You can find more about Javascript standard style [here](https://standardjs.com/).

```sh
# setup project folder
npm init
touch .eslintrc.yml
npm install --save-dev eslint

# node.js
npm install --save-dev eslint-config-standard eslint-plugin-standard eslint-plugin-promise eslint-plugin-import eslint-plugin-node
```

for React applications I think that using `react-script` is enough.

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
python project environment. Build and activate your environment with:

```sh
python3 -m venv $PROJECT_ROOT
. $PROJECT_ROOT/bin/activate
```

after do your works, you can deactivate your virtual
environment with

```sh
deactivate
```

### Go

It's very simple, just execute `:GoInstallBinaries` in vim normal mode,
after that you have complete IDE for go in vim.

| Shortcut         | Description                         |
|:----------------:|:------------------------------------|
| `:GoMetaLinter`  | statically checking Go source       |
| `:GeDoc`         | go doc with [GoExplorer](https://github.com/garyburd/go-explorer) |
| `:GoDoc`         | GoDoc == GeDoc if vim-go is plugged |
| `:GoFillStruct`  | use `fillstruct` to fill a struct literal with default values. Existing values (if any) are preserved. The cursor must be on the struct you wish to fill |
| `:[range]GoAddTags [key],[option] [key1],[option] ...` | adds field tags for the fields of a struct |
| `:GoImpl [receiver] [interface]` | generates method stubs for implementing an interface |

To setup a complete golang environment use [this](https://hackernoon.com/my-neovim-setup-for-go-7f7b6e805876)
medium post.

## Plugins

| #  | Plugin     | #  | Plugin                 |
|:--:|:-----------|:--:|:-----------------------|
| 1  | [easy-align](http://github.com/junegunn/vim-easy-align) | 2  | [cpp-enhanced-highlight](http://github.com/octol/vim-cpp-enhanced-highlight) |
| 3  | [vimtex](http://github.com/lervag/vimtex)     | 4  | [textutil](http://github.com/vim-scripts/textutil.vim)               |
| 5  | [node](http://github.com/moll/vim-node)       | 6  | [jade](http://github.com/digitaltoad/vim-jade)                   |
| 7  | [wakatime](http://github.com/wakatime/vim-wakatime)   | 8  | [zimpl](http://github.com/1995parham/vim-zimpl)                  |
| 9  | [gas](http://github.com/1995parham/vim-gas)        | 10 | [tcpdump](http://github.com/1995parham/vim-tcpdump)                |
| 11 | [spice](http://github.com/1995parham/vim-spice)      | 12 | [tomorrow-night](http://github.com/1995parham/tomorrow-night-vim)         |
| 13 | [avro](http://github.com/aolab/vim-avro)       | 14 | [python-syntax](http://github.com/vim-python/python-syntax)          |
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
| 47 | [ultisnips](http://github.com/SirVer/ultisnips)      | 48 | [vim-nerdtree-tabs](http://github.com/jistr/vim-nerdtree-tabs)      |
| 49 | [Agit](http://github.com/cohama/agit.vim)       | 50 | [vim-buffergator](http://github.com/jeetsukumaran/vim-buffergator)        |
| 51 | [vim-man](http://github.com/vim-utils/vim-man)    | 52 | [go-explorer](http://github.com/garyburd/go-explorer)            |
| 53 | [vim-vue](http://github.com/posva/vim-vue)    | 54 | [vim-vue-syntastic](http://github.com/sekel/vim-vue-syntastic)      |
| 55 | [Jenkinsfile-vim-syntax](http://github.com/martinda/Jenkinsfile-vim-syntax) | 56 | [syntastic-local-eslint](http://github.com/mtscout6/syntastic-local-eslint.vim) |
| 57 | [vim-json](http://github.com/elzr/vim-json)  | 58 | |

## Shortcuts

### Core

#### General Commands

| Shortcut         | Description               |
|:----------------:|:--------------------------|
| `<C-n>`          | toggles [NerdTree](https://github.com/scrooloose/nerdtree)          |
| `<C-h>`          | toggles [SuperTab](https://github.com/ervandew/supertab)          |
| `<C-b>`          | toogles [Buffergator](https://github.com/jeetsukumaran/vim-buffergator)       |
| `<F5>`           | toggles [Tagbar](https://github.com/majutsushi/tagbar)            |
| `<C-u>`          | toggles [utlisnips](https://github.com/SirVer/ultisnips)         |
| `<C-w> <Left>`   | move to left window       |
| `<C-w> <Right>`  | move to right window      |
| `<C-w> <Up>`     | move to up window         |
| `<C-w> <Down>`   | move to down window       |
| `<C-w> s`        | new horizontal window     |
| `<C-w> v`        | new vertical window       |
| `<C-w> n`        | move to next tab          |
| `<C-w> p`        | move to previous tab      |
| `<C-w> c`        | new empty tab             |
| `<C-w> nn`       | move to tab number nn     |
| `-`              | leader Key                |
| `J`              | join lines                |
| `u`              | undo                      |
| `.`              | redo                      |

#### Movement Commands

| Shortcut         | Description                         |
|:----------------:|:------------------------------------|
| `0` `$`          | begin/End of line                   |
| `G` `gg`         | begin/End of file                   |
| `w` `b`          | next/prev word                      |
| `<C-U>` `<C-D>`  | next/prev page                      |
| `H` `M` `L`      | top/mid/btm of win                  |
| `zt` `zz` `zb`   | scroll to top/mid/btm               |
| `%`              | matching parenthesis                |
| `[[ ]]`          | next/prev function/method           |

#### Search Commands

| Shortcut         | Description                         |
|:----------------:|:------------------------------------|
| `*` `#`          | find current word backward/forward  |
| `n` `N`          | next/prev search result             |

#### EX Commands

| Shortcut         | Description               | Shortcut         | Description                         |
|:----------------:|:--------------------------|:----------------:|:------------------------------------|
| `:b name`        | open buffer               | `:bd name`       | delete buffer                       |
| `:edit`          | reload current file       | `:Agit` | git log manager |
| `:edit!`         | reload current file force | `:edit x`        | edit file x                         |
| `:terminal`      | open terminal             | | |

#### Mode Commands

| Shortcut         | Description                         |
|:----------------:|:------------------------------------|
| `<ESC>`          | enter *Normal* mode                 |
| `v`              | enter *Visual* mode                 |
| `V`              | enter *Visual Line* mode            |
| `i`              | enter *Insert* mode                 |
| `I`              | enter *Insert* mode [head of line]  |
| `a`              | enter *Insert* mode [next position] |
| `A`              | enter *Insert* mode [end of line]   |
| `R`              | enter *Replace* mode                |

### NerdTree and Buffergator

| Shortcut | Description              |
|:--------:|:-------------------------|
| `s`      | open file vsplit         |
| `i`      | open file split          |
| `t`      | open file in new tab     |
| `o`      | open & close directory   |
| `m`      | show menu                |
| `I`      | toggle show hidden files |
