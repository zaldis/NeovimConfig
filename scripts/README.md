# Installation scripts

## Setup process

To setup configs just run:

```shell
curl -s https://raw.githubusercontent.com/zaldis/NeovimConfig/main/scripts/setup.sh | bash
```

**NOTE:** it's expected that [curl](https://curl.se/) lib is installed in your OS.


## Supported platforms

- Libux/Ubuntu
- MacOS 

For WSL clipboard please check the [Wiki](https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl)


## Debugging

To run the script locally just call:

```shell
export NVIM_CONFIG_DEBUG && {the path to setup.sh}
```


## Auxiliary info

To check that the module is installed just call next command:

```shell
command -v {module name}
```

If module is installed the path with description will be depicted.

For MacOS installation you can use [brew package manager](https://formulae.brew.sh/formula/coreutils)


## For manual installation

### Install the latest neovim

Not all package managers install the latest verstion of the NeoVim. In this case it's necessary to install the program directly.

1. Find the version in the [Releases](https://github.com/neovim/neovim/releases)
2. Install appropriate installation file regarding your OS

To check NeoVim version just run the command: `nvim --version`

### Prepare neovim configurations

1. Check that folder `~/.config/` exists or create new one
2. Copy `nvim` file to the `~/.config/` folder
3. Install [ripgrep](https://github.com/BurntSushi/ripgrep) for the filtering tools
4. Install [lua-language-server](https://github.com/sumneko/lua-language-server/wiki/Getting-Started) to work with [Lua](https://www.lua.org/) LSP. May be helpful for configurations editing. Don't forget to update `PATH` variable.

### Install Plugins

1. Open neovim with command: `nvim`
2. Try to enter: `:Pack` + Tab
3. Check that autocomplete is working
4. Select command: `:PackerSync` + Enter

**Note:** If you don't see autocomplete or see any errors about Packer, Packer may have been removed by accident. Then just run command to install it back:
```shell
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

### Python environment

To apply static type checking for Python it's necessary to install [Pyright](https://pypi.org/project/pyright/) in your virtual environment

```shell
python -m pip install pyright
```

To run debugger it's necessary to install Python adapter [debugpy](https://github.com/microsoft/debugpy/) in your virtual environment

```shell
python -m pip install debugpy
```
