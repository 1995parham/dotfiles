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

This repository contains my personal configurations for Ubuntu, Arch Linux (with sway window manager) and apple OSX,
which was created in Fall 2013 when I was a lonely B.Sc.' student at the Amirkabir University of Technology.
First, thank you for your visiting. A dotfiles repository is a personal repository, with it,
you can manage your configuration between your systems, so I make this repository, a template repository, so you can easily start your personal one from it.
Special thanks to [@elahe-dastan](https://github.com/elahe-dastan) for using this project and reporting its issues. Her unique contribution to this repository and my life is unforgettable.

## Installation

![Compatibility](https://img.shields.io/badge/works%20on-macos-white?logo=macos&style=for-the-badge)
![Compatibility](https://img.shields.io/badge/works%20on-ubuntu-orange?logo=ubuntu&style=for-the-badge)
![Compatibility](https://img.shields.io/badge/works%20on-arch-blue?logo=archlinux&style=for-the-badge)

The following command creates a basic directory structure and clones the _dotfiles_ repository:

```bash
curl -sL https://raw.githubusercontent.com/1995parham/dotfiles/main/over-the-air-installation.sh | bash
```

Install required tools with `pacman`, `brew` or `apt`.

```bash
./start.sh env
```

Install configuration files with soft-links and installs plugins on vim.
This script don't set the `zsh` as a default shell, so you need to set it manually.

```bash
./install.sh
```

Install useful fonts.

```bash
./start.sh font
```

**Don't** forget changing the git username and email:

```bash
touch $HOME/.config/git/config
```

**Also** don't forget to install neovim plugins:

```vim
:PlugInstall
```

Then you can install other tools with `start.sh`, here are some examples:

```bash
# install docker with proxy
./start.sh docker
# install golang
./start.sh go
# install python
./start.sh python
# and many many more...
```

Configuration of mentioned applications also is a part of this repository.

## Window Managers

I am using `sway` and `hyprland` as my primary window managers. This repository
structured around creating soft-links and because of that the duplicate configurations
between these window managers are gathered in `sway/`.

> Read more on [wiki](https://github.com/1995parham/dotfiles/wiki)...
