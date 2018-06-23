# buffalo.zsh
[Buffalo web framework](https://gobuffalo.io/) zsh plugin

## Usage

### Using zsh frameworks

#### [antigen](https://github.com/zsh-users/antigen)

Add `antigen bundle 1995parham/buffalo.zsh` to your `~/.zshrc`.

#### [oh-my-zsh](http://github.com/robbyrussell/oh-my-zsh)

* Clone the repository inside your oh-my-zsh repo:

        git clone https://github.com/1995parham/buffalo.zsh ~/.oh-my-zsh/custom/plugins/buffalo

* Enable it in your `.zshrc` by adding it to your plugin list and reloading the completion:

        plugins=(… buffalo)
        autoload -U compinit && compinit

### Manual installation

* Clone the repository:

        git clone git://github.com/1995parham/buffalo.zsh.git

* Include the directory in your `$fpath`, for example by adding in `~/.zshrc`:

        fpath=(path/to/buffalo.zsh $fpath)

* You may have to force rebuild `zcompdump`:

        rm -f ~/.zcompdump; compinit
