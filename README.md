# NeovimConfig
NeoVim configuration for Python Developers


## Requirements

### Install the latest neovim

Not all package managers install the latest verstion of the NeoVim. In this case it's necessary to install the program directly.

1. Find the version in the [Releases](https://github.com/neovim/neovim/releases)
2. Install appropriate installation file regarding your OS

To check NeoVim version just run the command: `nvim --version`

### Prepare neovim configurations

1. Check that folder `~/.config/` exists or create new one
2. Copy `nvim` file to the `~/.config/` folder

### Install Plugins

1. Open neovim with command: `nvim`
2. Try to enter: `:Pack` + Tab
3. Check that autocomplete is working
4. Select command: `:PackerSync` + Enter

**Note:** If you don't see autocomplete or see any errors about Packer, Packer may have been removed by accident. Then just run command to install it back:
```shell
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```
