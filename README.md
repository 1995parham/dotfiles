```
     _       _    __ _ _
  __| | ___ | |_ / _(_) | ___  ___
 / _` |/ _ \| __| |_| | |/ _ \/ __|
| (_| | (_) | |_|  _| | |  __/\__ \
 \__,_|\___/ \__|_| |_|_|\___||___/

 _  ___   ___  ____                   _
/ |/ _ \ / _ \| ___| _ __   __ _ _ __| |__   __ _ _ __ ___
| | (_) | (_) |___ \| '_ \ / _` | '__| '_ \ / _` | '_ ` _ \
| |\__, |\__, |___) | |_) | (_| | |  | | | | (_| | | | | | |
|_|  /_/   /_/|____/| .__/ \__,_|_|  |_| |_|\__,_|_| |_| |_|
                    |_|
```

![GitHub](https://img.shields.io/github/license/1995parham/dotfiles?logo=gnu&style=flat-square)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/1995parham/dotfiles/install?label=install&logo=github&style=flat-square)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/1995parham/dotfiles/lint?label=lint&logo=github&style=flat-square)
[![Ansible](https://img.shields.io/badge/ansible-ready-black?logo=ansible&style=flat-square)](https://github.com/1995parham-me/ansible-role)
![GitHub repo size](https://img.shields.io/github/repo-size/1995parham/dotfiles?style=flat-square)

## Introduction

This repository contains my personal configurations for Ubuntu, Arch Linux (with sway window manager) and apple OSX, which was created in Fall 2013 when I was a lonely B.Sc.' student at the Amirkabir University of Technology.
First, thank you for your visiting. A dotfiles repository is a personal repository, with it, you can manage your configuration between your systems, so I make this repository, a template repository, so you can easily start your personal one from it.
Special thanks to [@elahe-dastan](https://github.com/elahe-dastan) for using this project and reporting its issues. Her unique contribution to this repository and my life is unforgettable.

## Installation

![Compatibility](https://img.shields.io/badge/works%20on-macos-white?logo=macos&style=for-the-badge)
![Compatibility](https://img.shields.io/badge/works%20on-ubuntu-orange?logo=ubuntu&style=for-the-badge)
![Compatibility](https://img.shields.io/badge/works%20on-arch-blue?logo=archlinux&style=for-the-badge)

The following command creates a basic directory structure and clones the _dotfiles_ repository:

```sh
curl -sL https://raw.githubusercontent.com/1995parham/dotfiles/main/over-the-air-installation.sh | bash
```

Install required tools with `pacman`, `brew` or `apt`.

```sh
./start.sh env
```

Install configuration files with soft-links and installs plugins on neovim and vim.
This script don't set the `zsh` as a default shell.

```sh
./install.sh
```

Install useful fonts.

```sh
./start.sh font
```

**Don't** forget the git credential change:

```sh
touch $HOME/.config/git/config
```

**Also** don't forget to install neovim plugins:

```vi
:PackerSync
```

Then you can install other tools with `start.sh`, here are some examples:

```sh
# install docker with proxy (see <Breaking Sanctions> section for more details)
./start.sh docker
# install golang
./start.sh go
# install python
./start.sh python
# and many many more...
```

Configuration of mentioned applications also is a part of this repository.

## Scripts

As mentioned before, `start.sh` can be used to run the installation/helper scripts. these scripts install and setup different tools as below:

|                        Name                         | Description                                                                                                                   |
| :-------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------------------- |
|                        snapp                        | install snapp corporation mail/calender/contacts including davmail, vsyncdir and mutt. also recommends to install thunderbird |
|                [go](https://go.dev/)                | install and configure go. configuration includes goproxy and running `GoInstallBinaries` on neovim                            |
|      [age](https://github.com/FiloSottile/age)      | install age                                                                                                                   |
|                       awesome                       | clone awesome repositories like awesome-rust, awesome-go, etc from github                                                     |
| [alacritty](https://github.com/alacritty/alacritty) | install and configure alacritty                                                                                               |
