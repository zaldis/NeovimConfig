#!/usr/bin/env bash
set -e # for debugging
clear
# to run latest version of this script use command below:
# curl -s https://raw.githubusercontent.com/zaldis/NeovimConfig/main/scripts/setup.sh | bash

#######################################################################
#                         Global vars                                 #
#######################################################################

# colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No сolor

SUPPORTED_PLATFORMS=("OSX" "UBUNTU")
LINESEP="======================================================================"

#######################################################################
#                         Color output                                #
#######################################################################

cecho() {
    case $1 in
        black) color=$BLACK ;;
        red) color=$RED ;;
        green) color=$GREEN ;;
        yellow) color=$YELLOW ;;
        blue) color=$BLUE ;;
        purple) color=$PURPLE ;;
        cyan) color=$CYAN ;;
        white) color=$WHITE ;;
    esac

    echo -e "$color$2${NC}"
}

error() {
    issues_url="https://github.com/zaldis/NeovimConfig/issues"
    er_note="\n Check Issues section on GitHub and create new one if neccessary:\n  $issues_url"
    cecho red "❌ $1 $er_note " >&2
    if [[ "$0" = "$BASH_SOURCE" ]]; then
        exit 1
    else
        return 1
    fi
}

info() { cecho white "🔹 $1"; }

success() { cecho green "✅ $1"; }

step() { cecho purple "\n====== $1"; }

#######################################################################
#                         Helpers                                     #
#######################################################################

get_os_type() {
    case "$OSTYPE" in
        darwin*) echo "OSX" ;;
        linux*) (lsb_release -is 2>/dev/null || echo LINUX) | tr '[:lower:]' '[:upper:]' ;;
        solaris*) echo "SOLARIS" ;;
        bsd*) echo "BSD" ;;
        msys*) echo "WINDOWS" ;;
        cygwin*) echo "WINDOWS" ;;
        *) echo "UNKNOWN" ;;
    esac
}

spinner_pid=
start_spinner() {
    set +m
    tput civis
    echo -en "🔹 $1         "
    { while :; do for X in '  •     ' '   •    ' '    •   ' '     •  ' '      • ' '     •  ' '    •   ' '   •    ' '  •     ' ' •      '; do
        echo -en "\b\b\b\b\b\b\b\b$X"
        sleep 0.1
    done; done & } 2>/dev/null
    spinner_pid=$!
}
stop_spinner() {
    { kill -9 $spinner_pid 2>/dev/null && wait; }
    set -m
    echo -en "\033[2K\r"
    tput cnorm
}
trap stop_spinner EXIT
# check if command available
check_command() { command -v "$1" &>/dev/null; }

check_command_ext() {
    CMD_CMD="$1"  # command
    CMD_NAME="$2" # human readable name
    CMD_URL="$3"  # url to docs
    if ! check_command "$CMD_CMD"; then
        cecho red "Please install $CMD_NAME"
        docs_url="$CMD_URL"
        cecho red "Read more about how to install $CMD_NAME here: $CMD_URL"
        error "$CMD_NAME is not installed"
    fi
}

# return command abs path
get_command_path() { command -v "$1"; }

# check is path a valid directory
isdirectory() { [ -d "$1" ]; }

# check is python package installed
check_py_package() { $1 -c "import $2" &>/dev/null; }

# check is apt package installed
check_apt_package() { dpkg -s "$1" &>/dev/null; }

check_apt_package_ext() {
    APT_PACKAGE="$1" # command
    if ! check_apt_package "$APT_PACKAGE"; then
        cecho red "Please install $APT_PACKAGE. Try:\n sudo apt install -y $APT_PACKAGE"
        error "$APT_PACKAGE is not installed"
    fi
}

create_venv() {
    err_msg="Failed to create virtual environment $2 using $1"
    msg="Creating new virtual environment $2 using $1.\nPlease wait "
    start_spinner "$msg "
    $1 -m venv --copies --clear "$2" &>/dev/null || error "$err_msg"
    stop_spinner
    success "Virtual environment is created: $2"
}

install_py_package() {
    start_spinner "Installing $2 module "
    $1 -m pip install --upgrade --quiet --no-input "$2" &>/dev/null || error "Unable to install $2 using $1"
    stop_spinner
    success "$2 module is installed"
}

install_packer() {
    packer_url="https://github.com/wbthomason/packer.nvim"
    dest="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
    git clone --depth 1 "$packer_url" "$dest"
#    nvim -c "autocmd User PackerComplete quitall" -c "PackerSync"
}

cleanup() {
    tput cnorm
}
trap cleanup EXIT

#######################################################################
#                         Initial                                     #
#######################################################################

OS_TYPE=$(get_os_type)
if [[ ! " ${SUPPORTED_PLATFORMS[*]} " =~ " ${OS_TYPE} " ]]; then
    error "Your OS detected as $OS_TYPE and it's not supported platform. Please use: ${SUPPORTED_PLATFORMS[*]}"
fi

#######################################################################
#                         Requirements                                #
#######################################################################

echo "
$LINESEP
Requirements:
- git
- python3
- python3-pip
- python3-venv
- fd
- clipboard module
- neovim
$LINESEP
"

check_command_ext "git" "Git" "https://git-scm.com/book/en/v2/Getting-Started-Installing-Git"
check_command_ext "python3" "Python3" "https://docs.python.org/3/using/unix.html#getting-and-installing-the-latest-version-of-python"
check_command_ext "nvim" "Neovim" "https://github.com/neovim/neovim/wiki/Installing-Neovim"
if [ "$OS_TYPE" = "UBUNTU" ]; then
    check_command_ext "fdfind" "fd" "https://github.com/sharkdp/fd"
    check_apt_package_ext "python3-venv"
    check_apt_package_ext "python3-pip"
    check_apt_package_ext "xclip"
else
    check_command_ext "fd" "fd" "https://github.com/sharkdp/fd"
fi

#check_command_ext "git" "Git" "https://git-scm.com/book/en/v2/Getting-Started-Installing-Git"

read -p "Continue (y/n)? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

#######################################################################
#                         Environment variables                       #
#######################################################################

CURR_DIR="$(
    cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
    pwd -P
)"
PY_PATH=$(get_command_path python3)
OS_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
NVIM_CONFIG_DIR="$OS_CONFIG_DIR/nvim"
NVIM_PYTHON="$NVIM_CONFIG_DIR/venv/bin/python"

#######################################################################
#                         Setup python interpreter                    #
#######################################################################
echo ""
read -r -e -p "Enter the system Python path or press ENTER to keep default [$PY_PATH]: " SYS_PYTHON
SYS_PYTHON="${SYS_PYTHON:-${PY_PATH}}"
info "Chosen Python3 path: $SYS_PYTHON"
py_version=$(${SYS_PYTHON} --version)
if [[ $py_version ]]; then
    success "System Python version: $py_version"
else
    error "Unable to use Python interpreter by path: $SYS_PYTHON"
fi

#######################################################################
#                         Setup NeoVim config directory               #
#######################################################################
echo ""
mkdir -pv "$OS_CONFIG_DIR"
if [[ ! -d $NVIM_CONFIG_DIR ]]; then
    info "Creating soft link for nvim folder -> $NVIM_CONFIG_DIR"
    cp -r "${CURR_DIR}/../nvim" "$OS_CONFIG_DIR"
    is_nvim_config_linked=$?
    if [[ $is_nvim_config_linked ]]; then
        success "Neovim configs copied to ${HOME}/.config/nvim"
    else
        error "Some problem with linking the NeoVim config"
    fi
else
    success "NeoVim config folder is detected: ${NVIM_CONFIG_DIR}"
fi

#######################################################################
#              Setup Python virtual environment for NeoVim            #
#######################################################################
echo ""
venv_path="$NVIM_CONFIG_DIR/venv/"
#info "Creating new NeoVim virtual environment: $venv_path. Please wait..."
create_venv "$SYS_PYTHON" "$venv_path"

#######################################################################
#              Setup Python based modules for NeoVim                  #
#######################################################################
step "Setup python based modules..."

install_py_package "$NVIM_PYTHON" "wheel"
install_py_package "$NVIM_PYTHON" "pynvim"

#######################################################################
#              Check Clipboard modules                                #
#######################################################################
step "Check clipboard module..."

if [ "$OS_TYPE" = "UBUNTU" ]; then
    check_command xclip || error "Unable to find clipboard module (xclip)"
elif [ "$OS_TYPE" = "OSX" ]; then
    (check_command pbcopy && check_command pbpaste) || error "Unable to find Clipboard module (pbcopy/pbpaste)"
else
    sleep 1 || error "Unable to find Clipboard module"
fi

success "Found clipboard module"

#is_clipboard_setup=1
#
#check_command wl-copy
#is_wlcopy_installed=$?
#check_command wl-paste
#is_wlpaste_installed=$?
#if [[ $is_wlcopy_installed -eq 0 && $is_wlpaste_installed -eq 0 ]]; then
#    is_clipboard_setup=0
#    success "Found clipboard modules for Linux Wayland UI"
#fi

#check_command win32yank.exe
#is_win32yank_installed=$?
#if [[ $is_win32yank_installed -eq 0 ]]; then
#    is_clipboard_setup=0
#    success "Found clipboard modules for Windows WSL"
#fi

#if [[ $is_clipboard_setup -eq 1 ]]; then
#    echo "Please setup clipboard modules"
#    echo "-> pbcopy, pbpaste for MacOS"
#    echo "-> wl-copy, wl-paste for Linux on Wayland"
#    echo "-> xclip for Linux on XOrg"
#    echo "-> win32yank for Linux on Windows WSL"
#    error "Clipboard modules are not found. Setup them and run again"
#fi

#######################################################################
#              Sync NeoVim plugins                                    #
#######################################################################
step "Install NeoVim plugins..."
#rm -rf ~/.local/share/nvim/site/pack/packer/start/
install_packer &>/dev/null
nvim --headless -c "sleep 2" -c "autocmd User PackerComplete quitall" -c "PackerSync" &>/dev/null
# echo "Running NeoVim Health Check..."
# nvim -c ":checkhealth"
success "Done"
