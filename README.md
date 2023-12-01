<div align="center">
    <a href="https://github.com/neovim/neovim/releases/tag/stable">
      <img src="https://img.shields.io/badge/Neovim-0.10.0-blueviolet.svg?style=flat-square&logo=Neovim&logoColor=green" alt="Neovim minimum version"/>
    </a>
</div>

# NeovimConfig
NeoVim configuration for Python Developers


## Installation

To setup configs for NeoVim just call:

```shell
curl -s https://raw.githubusercontent.com/zaldis/NeovimConfig/main/scripts/setup.sh | bash
```

**WARNING:** Don't forget to read the documentation for setup.sh and install required libraries! You can find documentation in the same folder as the script in the README file.


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

- **Debug:** (read more details in [Wiki](https://github.com/zaldis/NeovimConfig/wiki/NVIM-Debugger-Manual))
    - **Toggle breakpoint:** `Leader` + `d` + `b`
    - **Open REPL:** `Leader` + `d` + `r`
    - **Open scopes:** `Leader` + `d` + `s`
    - **Open call frames:** `Leader` + `d` + `f`
    - **Evaluate expression:** `Leader` + `d` + `e`
    - **Run/Continue debugger:** `<F5>`
    - **Step over:** `<F10>`
    - **Step into:** `<F11>`
    - **Step out:** `<F12>`
