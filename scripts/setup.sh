#!/bin/bash

FILE_PATH=$(realpath -- $0)
CURR_DIR=$(dirname -- $FILE_PATH)

NVIM_CONFIG_DIR="${HOME}/.config/nvim"
NVIM_PYTHON="$NVIM_CONFIG_DIR/venv/bin/python"


#######################################################################
#                         Color constants                             #
#######################################################################
RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
NC='\033[0m' # No color


#######################################################################
#                         Check NeoVim is setup                       #
#######################################################################
echo ""
nvim_pathes=$(whereis nvim)
is_nvim_setup=$?
if [[ $is_nvim_setup ]]; then
    echo -e "${GREEN}[OK]${NC} NeoVim is found: ${nvim_pathes}"
else
    echo -e "${RED}[ERROR] NeoVim is not found.${NC}"
    echo "Please, install nvim editor (https://github.com/neovim/neovim) and run the script again"
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

# echo "Running NeoVim Health Check..."
# nvim -c ":checkhealth"
