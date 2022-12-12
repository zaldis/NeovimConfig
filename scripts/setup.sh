#!/usr/bin/env bash

# to run latest version of this script use command below:
# curl -s https://raw.githubusercontent.com/zaldis/NeovimConfig/main/scripts/setup.sh | bash


set -e  # Exit immediately if a command exits with a non-zero status
clear

CURR_DIR="$(
    cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
    pwd -P
)"


# Load utils functions
. $CURR_DIR/utils.sh


setup_dependencies() {
    # TODO add installation for necessary OS platforms
    local os_name=$(get_os_name)
    if [ $os_name = "UBUNTU" ]; then
        . $CURR_DIR/deps/ubuntu.sh
    fi

    if [ $os_name = "OSX" ]; then
        echo "Installing dependencies for MacOS"
    fi
}
setup_dependencies


#######################################################################
#                         Helpers                                     #
#######################################################################
create_venv() {
    python_cmd=$1
    venv_path=$2
    err_msg="Failed to create virtual environment $venv_path using $python_cmd"
    msg="Creating new virtual environment $venv_path using $python_cmd.\nPlease wait "
    start_spinner "$msg "
    $python_cmd -m venv --copies --clear "$venv_path" &>/dev/null || error "$err_msg"
    stop_spinner
    success "Virtual environment is created: $2"
}

install_py_package() {
    python_cmd=$1
    package_name=$2
    start_spinner "Installing $package_name module "
    $python_cmd -m pip install --upgrade --quiet --no-input "$2" &>/dev/null || error "Unable to install $2 using $1"
    stop_spinner
    success "$package_name module is installed"
}

install_packer() {
    packer_url="https://github.com/wbthomason/packer.nvim"
    dest="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
    git clone --depth 1 "$packer_url" "$dest"
}

cleanup() {
    tput cnorm
}
trap cleanup EXIT


#######################################################################
#                         Environment variables                       #
#######################################################################
PY_PATH=$(get_command_path python3)
OS_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
NVIM_CONFIG_DIR="$OS_CONFIG_DIR/nvim"
NVIM_PYTHON="$NVIM_CONFIG_DIR/venv/bin/python"


#######################################################################
#                         Setup python interpreter                    #
#######################################################################
echo ""
read -rep "Enter the system Python path or press ENTER to keep default [$PY_PATH]: " SYS_PYTHON
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
    info "Copy content to nvim folder -> $NVIM_CONFIG_DIR"
    cp -r "${CURR_DIR}/../nvim" "$OS_CONFIG_DIR"
    is_nvim_config_updated=$?
    if [[ $is_nvim_config_updated ]]; then
        success "Neovim configs copied to ${NVIM_CONFIG_DIR}"
    else
        error "Some problem with updating the NeoVim config"
    fi
else
    success "NeoVim config folder is detected: ${NVIM_CONFIG_DIR}"
fi


#######################################################################
#              Setup Python virtual environment for NeoVim            #
#######################################################################
echo ""
venv_path="$NVIM_CONFIG_DIR/venv/"
create_venv "$SYS_PYTHON" "$venv_path"


#######################################################################
#              Setup Python based modules for NeoVim                  #
#######################################################################
step "Setup python based modules..."
install_py_package "$NVIM_PYTHON" "wheel"
install_py_package "$NVIM_PYTHON" "pynvim"


#######################################################################
#              Sync NeoVim plugins                                    #
#######################################################################
step "Install NeoVim plugins..."
install_packer &>/dev/null
nvim --headless -c "sleep 2" -c "autocmd User PackerComplete quitall" -c "PackerSync" &>/dev/null
success "Done"
