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
    local os_name=$(get_os_name)

    if [ $os_name = "UBUNTU" ]; then
        . $CURR_DIR/deps/ubuntu.sh
    fi

    if [ $os_name = "OSX" ]; then
        . $CURR_DIR/deps/macos.sh
    fi
}
setup_dependencies


#######################################################################
#                         Environment variables                       #
#######################################################################
PY_PATH=$(get_command_path python3)
OS_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
NVIM_CONFIG_DIR="$OS_CONFIG_DIR/nvim"
NVIM_VENV_DIR="$NVIM_CONFIG_DIR/venv"
NVIM_PYTHON="$NVIM_VENV_DIR/bin/python"
NVIM_PACKER_DIR="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"


#######################################################################
#                         Helpers                                     #
#######################################################################
create_venv() {
    python_cmd=$1
    venv_path=$2
    $python_cmd -m venv --copies --clear "$venv_path"
}

create_venv_gui() {
    python_cmd=$1
    venv_path=$2

    msg="Creating new virtual environment $venv_path using $python_cmd.\nPlease wait "
    err_msg="Failed to create virtual environment $venv_path using $python_cmd"
    start_spinner "$msg "
    $(create_venv $python_cmd $venv_path &>/dev/null) || error $err_msg
    stop_spinner
    success "Virtual environment is created: $venv_path"
}

install_py_package() {
    python_cmd=$1
    package_name=$2
    $python_cmd -m pip install --upgrade --quiet --no-input "$package_name"
}

install_py_package_gui() {
    python_cmd=$1
    package_name=$2
    start_spinner "Installing $package_name module "
    error_msg="Unable to install $package_name using $python_cmd"
    $(install_py_package $python_cmd $package_name &>/dev/null) || error $error_msg
    stop_spinner
    success "$package_name module is installed"
}

install_packer() {
    local packer_url="https://github.com/wbthomason/packer.nvim"
    git clone --depth 1 "$packer_url" "$NVIM_PACKER_DIR"
}

install_packer_gui() {
    if [ -d $NVIM_PACKER_DIR ]; then
        info "To update packer it's necessary to remove old version from the $NVIM_PACKER_DIR"
        is_ready
        rm -rf $NVIM_PACKER_DIR
    fi
    install_packer &>/dev/null
}

cleanup() {
    tput cnorm
}
trap cleanup EXIT


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
else
    info "Update nvim configs -> $NVIM_CONFIG_DIR"
fi

cp -r "${CURR_DIR}/../nvim" "$OS_CONFIG_DIR"
is_nvim_config_updated=$?
if [[ $is_nvim_config_updated ]]; then
    success "Neovim configs are updated in ${NVIM_CONFIG_DIR}"
else
    error "Some problem with updating the NeoVim config"
fi


#######################################################################
#              Setup Python virtual environment for NeoVim            #
#######################################################################
echo ""
create_venv_gui "$SYS_PYTHON" "$NVIM_VENV_DIR"


#######################################################################
#              Setup Python based modules for NeoVim                  #
#######################################################################
step "Setup python based modules..."
install_py_package_gui "$NVIM_PYTHON" "wheel"
install_py_package_gui "$NVIM_PYTHON" "pynvim"


#######################################################################
#              Sync NeoVim plugins                                    #
#######################################################################
step "Install NeoVim plugins..."
install_packer_gui
start_spinner "Installing NeoVim plagins"
nvim --headless -c "sleep 2" -c "autocmd User PackerComplete quitall" -c "PackerSync" 2>/dev/null
stop_spinner

success "Done"
