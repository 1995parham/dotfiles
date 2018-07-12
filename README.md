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
[![Travis branch](https://img.shields.io/travis/1995parham/dotfiles/master.svg?style=flat-square)](https://travis-ci.org/1995parham/dotfiles)
[![Codacy Badge](https://img.shields.io/codacy/grade/02e3f859b8944e749d1ceca4a4c41e49.svg?style=flat-square)](https://www.codacy.com/app/1995parham/dotfiles?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=1995parham/dotfiles&amp;utm_campaign=Badge_Grade)

## Introduction

My Personal Ubuntu and OSx configuration files which were cratead in fall 2013.
for more information about how to use this configuration with VIM, Zsh and ... see [here](http://1995parham.github.io/dotfiles/).

## Frameworks
<p align="center">
  <img src="https://raw.githubusercontent.com/neovim/neovim.github.io/master/logos/neovim-logo-600x173.png" />
</p>
<p align="center">
  <img src="https://camo.githubusercontent.com/5c385f15f3eaedb72cfcfbbaf75355b700ac0757/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6f686d797a73682f6f682d6d792d7a73682d6c6f676f2e706e67">
</p>

## [Shecan](https://shecan.ir/) is Awesome
```
DNS: 94.232.174.194
```

## GoProxy is here
Install goproxy from [here](https://github.com/snail007/goproxy) and then you can use following ssh local port forwarding
to create secure http proxy:

```sh
# create secure http(s) proxy
ip=151.80.199.92

ssh -fTN -L 38080:127.0.0.1:38080 $ip

export {http,https,ftp}_proxy=127.0.0.1:38080

unset {http,https,ftp}_proxy

ps aux | grep "ssh -fTN" | grep "38080:" | awk '{print $2}' | xargs kill
```

## Installation

Install required software with:

```sh
./scripts/env.sh
```

Setup configuration files with:

```sh
./install.sh
```

### Tilix

Copy schemes from `tilix/` into `$HOME/.config/tilix/schemes`.
