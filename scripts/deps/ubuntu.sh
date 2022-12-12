#!/usr/bin/env bash

check_apt_package() {
    # check is apt package installed
    local package_name=$1
    dpkg -s "$package_name" &>/dev/null;
}

check_apt_package_ext() {
    local package_name="$1"
    if ! check_apt_package "$package_name"; then
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
- fd
- xclip
- neovim
$LINESEP
"

# TODO Move to separated function
read -p "Continue (y/n)? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

check_command_ext \
    "git" \
    "Git" \
    "https://git-scm.com/book/en/v2/Getting-Started-Installing-Git"
check_command_ext \
    "python3" \
    "Python3" \
    "https://docs.python.org/3/using/unix.html#getting-and-installing-the-latest-version-of-python"
check_command_ext \
    "nvim" \
    "Neovim" \
    "https://github.com/neovim/neovim/wiki/Installing-Neovim"
check_command_ext "fdfind" "fd" "https://github.com/sharkdp/fd"

check_apt_package_ext "python3-venv"
check_apt_package_ext "python3-pip"
check_apt_package_ext "xclip"
