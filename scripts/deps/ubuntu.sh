#!/usr/bin/env bash

find_apt_package() {
    # check is apt package installed
    local package_name=$1
    dpkg -s "$package_name" &>/dev/null;
}

validate_apt_package() {
    local package_name="$1"
    if ! find_apt_package "$package_name"; then
        cecho red "Please install $package_name. Try:\n sudo apt install -y $package_name"
        error "$package_name is not installed"
    fi
}


step "Setup required Ubuntu dependencies"

echo "
$LINESEP
Requirements:
- git
- python3
- pip3
- venv
- fdfind
- xclip
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
validate_command "fdfind" "fd" "https://github.com/sharkdp/fd"

validate_apt_package "python3-venv"
validate_apt_package "python3-pip"
validate_apt_package "xclip"
