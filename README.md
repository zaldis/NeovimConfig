<div align="center">
    <a href="https://github.com/neovim/neovim/releases/tag/stable">
      <img src="https://img.shields.io/badge/Neovim-0.8.0-blueviolet.svg?style=flat-square&logo=Neovim&logoColor=green" alt="Neovim minimum version"/>
    </a>
</div>

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


## Features

**Note:** `Leader` is the `\` button.

- **Autocomplete is called automatically** when you run writing the code. To select the option just use up/down arrows + `Enter`

- **Go to definition:** `g` + `d`

- **Go to references:** `g` + `r`

- **Open documentation:** `Shift` + `k`. To jump into the documentation window just press again `Shift` + `k` (to close the documentation window call `q`)

- **Check all issues in the line:** `Leader` + `e`. To jump into the issues window just press again `Leader` + `e` (to close the documentation window call `q`)

- **Rename a variable:** `Leader` + `r` + `n`. Then write a new name and press `Enter`

- **Searching by file:** `f` + `f`. Then enter the file pattern

- **Searching by content:** `f` + `g`. Then enter the content pattern

- **Searching by Nvim docs:** `f` + `h`. Then enter doc's topic

- **Open/Close file tree:** `Leader` + `t`
    - **Toggle dot files:** `H`
    - **Filter:** `f`
    - **Create new file/folder:** `a`
    - **Rename file/folder:** `r`
    - **Delete file/folder:** `d`

- **Debug:** (read more details in [Wiki](https://github.com/zaldis/NeovimConfig/wiki/Debugger))
    - **Toggle breakpoint:** `Leader` + `d` + `b`
    - **Open REPL:** `Leader` + `d` + `r`
    - **Open scopes:** `Leader` + `d` + `s`
    - **Open call frames:** `Leader` + `d` + `f`
    - **Evaluate expression:** `Leader` + `d` + `e`
    - **Run/Continue debugger:** `<F5>`
    - **Step over:** `<F10>`
    - **Step into:** `<F11>`
    - **Step out:** `<F12>`
