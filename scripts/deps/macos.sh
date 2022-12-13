#!/usr/bin/env bash

step "Setup required MacOS dependencies"

echo "
$LINESEP
Requirements:
- git
- python3
- pip3
- venv
- fd
- pbcopy
- pbpaste
- neovim
$LINESEP
"

is_ready

validate_command \
    "git" \
    "Git" \
    "https://git-scm.com/book/en/v2/Getting-Started-Installing-Git"
validate_command \
    "python3" \
    "Python3" \
    "https://docs.python.org/3/using/unix.html#getting-and-installing-the-latest-version-of-python"
validate_command \
    "nvim" \
    "Neovim" \
    "https://github.com/neovim/neovim/wiki/Installing-Neovim"
validate_command "fd" "fd" "https://github.com/sharkdp/fd"
validate_command "pbcopy" "pbcopy" "https://ss64.com/osx/pbcopy.html"
validate_command "pbpaste" "pbpaste" "https://ss64.com/osx/pbpaste.html"
