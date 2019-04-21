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
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/02e3f859b8944e749d1ceca4a4c41e49)](https://www.codacy.com/app/1995parham/dotfiles?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=1995parham/dotfiles&amp;utm_campaign=Badge_Grade)

## Introduction

My Personal Ubuntu and OSx configuration files which created in Fall 2013
when I was a BSc Student of the Amirkabir University of Technology.
First thank for your visiting, to find out more about how to use this configuration with NeoVIM, Oh-My-Zsh, etc.
please check the following sections.

## Table of Contents

- [How To...](docs/how.md)
- [VIM](docs/vim.md)
- [ZSH](docs/zsh.md)
- [Home sweet Home](docs/home.md)

## Frameworks
<p align="center">
  <img src="https://raw.githubusercontent.com/neovim/neovim.github.io/master/logos/neovim-logo-600x173.png" />
</p>
<p align="center">
  <img src="https://camo.githubusercontent.com/5c385f15f3eaedb72cfcfbbaf75355b700ac0757/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6f686d797a73682f6f682d6d792d7a73682d6c6f676f2e706e67">
</p>

## [Shecan](https://shecan.ir/) is Awesome :heart_eyes:
```
DNS: 94.232.174.194
```

## Installation
Over-the-Air-Installation :joy:

```sh
curl -L https://raw.githubusercontent.com/1995parham/dotfiles/master/over-the-air-installation.sh | bash
```


Ubuntu Universal Repository (if you are on ubuntu :joy:)

```sh
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
```

Install required softwares with:

```sh
./start.sh env
./start.sh neovim

```

Setup configuration files with:

```sh
./install.sh
```
