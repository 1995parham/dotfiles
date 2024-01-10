<h1 align="center">1995parham's dotfiles library</h1>
<h6 align="center"> Script Collection for Effortless Dotfile Management </h6>

<p align="center">
     <img alt="GitHub" src="https://img.shields.io/github/license/1995parham/dotfiles.lib?logo=gnu&style=for-the-badge">
     <img alt="GitHub Workflow Status" src="https://img.shields.io/github/actions/workflow/status/1995parham/dotfiles.lib/sh-lint.yaml?logo=github&style=for-the-badge&label=lint">
     <img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/1995parham/dotfiles.lib?style=for-the-badge">
</p>

## Introduction

Discover a new way of managing your dotfiles with **dotfile.lib**, a collection of bash scripts designed to introduce ease and a splash of fun into the maintenance process.
Whether you're setting up a new system or tailoring an existing one, these tools are crafted to streamline your workflow.

## Features

- **Easy Installation 🚀**: Jumpstart your environment setup with scripts that handle the installation of prerequisites.
- **Vibrant Feedback 🌈**: Enjoy colorful console messages that make tracking your progress a visual treat.
- **Proxy Configuration 🇮🇷**: Simplify the complex task of proxy settings with dedicated scripts.
- **And More ✨**: The library is growing—more convenient scripts will continually enrich your setup experience.

Explore **dotfile.lib** and make dotfile management something you look forward to.

## How to use it?

Clone this repository into your `dotfiless` folder under `./scripts/lib`
(here we are using [git-subtree](https://www.atlassian.com/git/tutorials/git-subtree)):

```bash
mkdir scripts
git subtree add --prefix scripts/lib https://github.com/1995parham/dotfiles.lib.git main --squash
```

Then link the `start.sh` into your root's `dotfiles` as follows:

```bash
ln -s scripts/lib/start.sh start.sh
```

Then you can start creating your setup scripts using:

```bash
./start.sh new
```

```text
├── start.sh -> scripts/lib/start.sh
├── 📂 scripts
│   ├── 📂 lib              dotfiles.lib
│   │   ├── start.sh
│   │   ├── require.sh
│   │   ├── message.sh
│   │   └── ...
│   │
│   ├── neovim.sh           user defined scripts for configuring and setup applications
│   ├── git.sh
│   │
│
```
