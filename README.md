```
  __| | ___ | |_ / _(_) | ___  ___
 / _` |/ _ \| __| |_| | |/ _ \/ __|
| (_| | (_) | |_|  _| | |  __/\__ \
 \__,_|\___/ \__|_| |_|_|\___||___/

   ____  _  ___   ___  ____                   _
  / __ \/ |/ _ \ / _ \| ___| _ __   __ _ _ __| |__   __ _ _ __ ___
 / / _` | | (_) | (_) |___ \| '_ \ / _` | '__| '_ \ / _` | '_ ` _ \
| | (_| | |\__, |\__, |___) | |_) | (_| | |  | | | | (_| | | | | | |
 \ \__,_|_|  /_/   /_/|____/| .__/ \__,_|_|  |_| |_|\__,_|_| |_| |_|
  \____/                    |_|
```

[![license](https://img.shields.io/github/license/1995parham/dotfiles.svg?style=flat-square)]()
[![Build Status](https://travis-ci.com/1995parham/dotfiles.svg?branch=master)](https://travis-ci.com/1995parham/dotfiles)

## Introduction

This repository contains my personal configurations for Ubuntu and OSx, which has been created in Fall 2013 when I was a lonely BSc' student at the Amirkabir University of Technology. First of all, thank you for your visiting, to find out more about how to use this configuration with NeoVIM, Oh-My-Zsh, etc. please check the following sections.
Special thanks to [@elahe-dastan](https://github.com/elahe-dastan) for using this project and reporting its issues. Her unique contribution to this repository and my life is unforgettable.

## Installation
The following command creates a basic directory structure and clones the **dotfiles** repository:

```sh
curl -L https://raw.githubusercontent.com/1995parham/dotfiles/master/over-the-air-installation.sh | bash
```

**dotfiles** uses [brew.sh](http://brew.sh) as its main package manager so you must install it.

```sh
./start.sh brew
```

Install required softwares with apt/brew. Please note that this special script will automatically setup the brew environment to use it.

```sh
./start.sh env
```

Install configuration files with soft-links. This script also sets the zsh as a default shell and installs plugins on neovim and vim.

```sh
./install.sh
```

Install useful fonts.

```sh
cd fonts && ./install.sh
```

Persoanlly I have used the following configuration on my [iTerm](https://www.iterm2.com/).

| color-scheme | font-family | size | iv | nn | 
|:------------:|:------------|:----:|:--:|:--:|
| atom | Font Meslo LG S for Powerline | 9pt | 100 | 100 |

At the end you have the following tools at your command:


| Command | Tool |
|:-------:|:-----|
| `vim`   | [vim](https://www.vim.org/) |
| `nvim`  | [NeoVim](https://neovim.io/) |
| `tmux`  | [tmux](https://github.com/tmux/tmux/wiki) |

Then you can install other tools with `start.sh`, here some examples:

```sh
# install docker with proxy (see <Breaking Sanctions> section for more details)
./start.sh -p docker -i
# install golang
./start.sh go
# install python
./start.sh python
# and many many more...
```

## Tips and Tricks

- You can use the following command in **sudo mode** to remove osx lags in our country that happens because of sanctions.

```sh
echo '0.0.0.0 ocsp.apple.com' >> /etc/hosts
```

- Personally I have used [Workona](https://workona.com/) in Chrome.
In order to hide its hidden windows from the OSx dock, check `System Preferences -> Dock -> Minimize windows into application icon`.

## Breaking Sanctions
Our country is under many unfair sanctions so you can use [v2ray](https://www.v2ray.com/en/) to remove these sanctions.
Use following command to install it.

```sh
curl -Ls https://install.direct/go.sh | sudo bash
```

You can configure it in many ways but here is my sample.

```yaml
{
  "inbounds": [
    {
      "port": 1080,
      "protocol": "http"
    }
  ],
  "outbounds": [
    {
      "protocol": "shadowsocks",
      "settings": {
        "servers": [
          {
            "address": "an-awesome-server",
            "method": "chacha20",
            "ota": false,
            "password": "secret",
            "port": 1378
          }
        ]
      }
    }
  ]
}
```

After this you can use the following commands in your shell to enable/disable http(s) proxy.

```sh
proxy_start # enable http(s) proxy
proxy_stop  # disable http(s) proxy
```

Please note that in order to have this proxy on `apt` on linux you must run apt with:

```sh
sudo -E apt ...
```

For having proxy on docker use the following procedure:

```sh
sudo mkdir -p /etc/systemd/system/docker.service.d
```

Then update `/etc/systemd/system/docker.service.d/http-proxy.conf` with:

```
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:1080/"
```

And reload the docker daemon:

```sh
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## vim

## VIM is your IDE

If you are using this dotfiles (neo)vim configuration
you can use following scripts and informations for having better (neo)vim.

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

## zsh

## Shortcuts

### General Commands

| Shortcut         | Description               |
|:----------------:|:--------------------------|
| `<C-R>`          | Enter to history mode     |
| `<C-G>`          | Exit from history mode    |

## VIM Mode Shortcuts

Use `escape` in order to enter vim mode for zsh.

### General Commands

| Shortcut   | Description               |
|:----------:|:--------------------------|
| `dd`       | Delete current line       |
| `$`        | Move to end of line       |
| `0`        | Move to head of line      |

### Search Commands

These commands use for history searching.

| Shortcut         | Description                         |
|:----------------:|:------------------------------------|
| `*` `#`          | Find current word backward/forward  |
| `n` `N`          | Next/Prev search result             |
