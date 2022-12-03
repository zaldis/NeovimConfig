#!/bin/bash

#######################################################################
#                         Color constants                             #
#######################################################################
RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
NC='\033[0m' # No color


#######################################################################
#                         Environment variables                       #
#######################################################################
command -v realpath
is_realpath_setup=$?
if [[ $is_realpath_setup -ne 0 ]]; then
    echo -e "${RED}[ERROR]${NC} realpath lib has to be installed as coreutil function"
    echo "Please install following lib: realpath"
    echo "Read more about core utils: https://www.gnu.org/software/coreutils/manual/"
    exit 1
fi

FILE_PATH=$(realpath -- $0)
CURR_DIR=$(dirname -- $FILE_PATH)

NVIM_CONFIG_DIR="${HOME}/.config/nvim"
NVIM_PYTHON="$NVIM_CONFIG_DIR/venv/bin/python"


#######################################################################
#                         Check NeoVim is setup                       #
#######################################################################
echo ""
command -v nvim
is_nvim_setup=$?
if [[ $is_nvim_setup ]]; then
    echo -e "${GREEN}[OK]${NC} NeoVim is found: ${nvim_pathes}"
else
    echo -e "${RED}[ERROR] NeoVim is not found.${NC}"
    echo "Please, install nvim editor (https://github.com/neovim/neovim) and run the script again"
    exit 1
fi


#######################################################################
#                         Setup NeoVim config directory               #
#######################################################################
echo ""
if [[ ! -d $NVIM_CONFIG_DIR ]]; then
    echo "Creating soft link for nvim folder -> $NVIM_CONFIG_DIR"
    ln -s "${CURR_DIR}/../nvim" $NVIM_CONFIG_DIR
    is_nvim_config_linked=$?
    if [[ $is_nvim_config_linked ]]; then
        echo -e "${GREEN}[OK]${NC} Nvim config was linked to ${HOME}/.config/nvim"
    else
        echo -e "${RED}[ERROR] Some problem with linking the NeoVim config.${NC}"
        echo "Please, check Issues section on GitHub and create new one if neccessary"
    fi
else
    echo -e "${GREEN}[OK]${NC} NeoVim config folder is detected: ${NVIM_CONFIG_DIR}"
fi


#######################################################################
#                         Setup python interpreter                    #
#######################################################################
echo ""
read -p "Enter the system Python path (full path or alias): " SYS_PYTHON
py_version=`${SYS_PYTHON} --version`
if [[ $py_version ]]; then
    echo -e "\n${GREEN}[OK]${NC} System Python version: $py_version" 
else
    echo -e "\n${RED}[ERROR] There is no Python interpreter by path: $SYS_PYTHON.${NC}"
    echo "Please, 1) install Python; 2) run script again; 3) enter the correct Python path"
    exit 1
fi


#######################################################################
#              Setup Python virtual environment for NeoVim            #
#######################################################################
echo ""
if [[ ! -d "$NVIM_CONFIG_DIR/venv" ]]; then
    echo -e "Creating new NeoVim virtual environment: ${NVIM_CONFIG_DIR}/venv/"
    $SYS_PYTHON -m venv "${NVIM_CONFIG_DIR}/venv"
    is_venv_created=$?
    if [ $is_venv_created -eq 0 ]; then
        echo -e "${GREEN}[OK]${NC} NeoVim virtual environment is created"
    else
        echo -e "${RED}[ERROR]${NC} Some issue is happen"
    fi
else
    echo -e "${GREEN}[OK]${NC} NeoVim virtual environment has alread existed"
fi


#######################################################################
#              Setup Python based modules for NeoVim                  #
#######################################################################
echo -e "\n${PURPLE}Setup python based modules...${NC}" 

function install_py_module() {
    module=$1

    echo "Installing $module module..."
    $NVIM_PYTHON -m pip install $module
    if [[ $? ]]; then
        echo -e "${GREEN}[OK]${NC} ${module} module is installed"
    else
        echo -e "${RED}[ERROR] Something goes wrong with ${module} installation.${NC}"
        echo "Please, check Issues section on GitHub and create new one if neccessary"
        exit 1
    fi
}

function upgrade_py_module() {
    module=$1

    echo "Upgrading $module module..."
    $NVIM_PYTHON -m pip install $module --upgrade
    if [[ $? ]]; then
        echo -e "${GREEN}[OK]${NC} $module module is upgraded"
    else
        echo -e "${RED}[ERROR] Something goes wrong with $module upgrading.${NC}"
        echo "Please, check Issues section on GitHub and create new one if neccessary"
        exit 1
    fi
}

function setup_py_module() {
    module=$1

    $NVIM_PYTHON -m pip list | grep "$module"
    is_module_installed=$?
    if [[ $is_module_installed -ne 0 ]]; then
        install_py_module $module
    else
        upgrade_py_module $module
    fi
}

setup_py_module "wheel"
echo
setup_py_module "pynvim"


#######################################################################
#              Check Clipboard modules                                #
#######################################################################
echo -e "\n${PURPLE}Check clipboard modules...${NC}" 
is_clipboard_setup=1

command -v pbcopy
is_pbcopy_installed=$?
command -v pbpaste
is_pbpaste_installed=$?
if [[ $is_pbcopy_installed -eq 0 && $is_pbpaste_installed -eq 0 ]]; then
    is_clipboard_setup=0
    echo -e "${GREEN}[OK]${NC} Found clipboard modules for MacOS"
fi

command -v wl-copy
is_wlcopy_installed=$?
command -v wl-paste
is_wlpaste_installed=$?
if [[ $is_wlcopy_installed -eq 0 && $is_wlpaste_installed -eq 0 ]]; then
    is_clipboard_setup=0
    echo -e "${GREEN}[OK]${NC} Found clipboard modules for Linux Wayland UI"
fi

command -v xclip
is_xclip_installed=$?
if [[ $is_xclip_installed -eq 0 ]]; then
    is_clipboard_setup=0
    echo -e "${GREEN}[OK]${NC} Found clipboard modules for Linux XOrg UI"
fi
    
command -v win32yank.exe
is_win32yank_installed=$?
if [[ $is_win32yank_installed -eq 0 ]]; then
    is_clipboard_setup=0
    echo -e "${GREEN}[OK]${NC} Found clipboard modules for Windows WSL"
fi

if [[ $is_clipboard_setup -eq 1 ]]; then
    echo -e "${RED}[ERROR] Clipboard modules are not found. Setup them please and run the script again.${NC}"
    echo "-> pbcopy, pbpaste for MacOS"
    echo "-> wl-copy, wl-paste for Linux on Wayland"
    echo "-> xclip for Linux on XOrg"
    echo "-> win32yank for Linux on Windows WSL"
    exit 1
fi


#######################################################################
#              Check Telescope modules                                #
#######################################################################
command -v fd
is_fd_installed=$?
if [[ $is_fd_installed -eq 0 ]]; then
    echo -e "${GREEN}[OK]${NC} Found fd lib for Telescope"
else
    echo -e "${RED}[ERROR] fd lib is not installed.${NC}"
    echo "Install fd lib and run the setup script again: https://github.com/sharkdp/fd"
fi


#######################################################################
#              Sync NeoVim plugins                                    #
#######################################################################
echo -e "${PURPLE}Sync NeoVim plugins...${NC}"
nvim -c "autocmd User PackerComplete quitall" -c "PackerSync"
# echo "Running NeoVim Health Check..."
# nvim -c ":checkhealth"
