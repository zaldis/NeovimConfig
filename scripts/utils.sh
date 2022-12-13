#!/usr/bin/env bash

# colors
export BLACK='\033[0;30m'
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export WHITE='\033[1;37m'
export NC='\033[0m' # No сolor

export LINESEP="======================================================================"


#######################################################################
#                            Printers                                 #
#######################################################################
cecho() {
    # Colored echo
    color_name=$1
    message=$2
    case $color_name in
        black) color=$BLACK ;;
        red) color=$RED ;;
        green) color=$GREEN ;;
        yellow) color=$YELLOW ;;
        blue) color=$BLUE ;;
        purple) color=$PURPLE ;;
        cyan) color=$CYAN ;;
        white) color=$WHITE ;;
    esac

    echo -e "$color$message$NC"
}
export -f cecho

error() {
    # Notify the user about the error
    error_message=$1
    issues_url="https://github.com/zaldis/NeovimConfig/issues"
    er_note="\n Check Issues section on GitHub and create new one if neccessary:\n  $issues_url"
    cecho red "❌ $error_message $er_note " >&2
    exit 1
}
export -f error

info() {
    # Print standard message
    message=$1
    cecho white "🔹 $message"; 
}
export -f info

success() {
    # Print the message that action is successfully done
    message=$1
    cecho green "✅ $message"; 
}
export -f success

step() {
    # Print the message about the step of the action
    message=$1
    cecho purple "\n====== $message";
}
export -f step

is_ready() {
    # Ask the user to approve following actions
    read -p "Continue (y/n)? " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
}
export -f is_ready


#######################################################################
#                            Spinner                                  #
#######################################################################
export spinner_pid=
start_spinner() {
    local message=$1

    set +m  # disable job control
    tput civis  # hide cursor
    echo -en "🔹 $message  "
    local asset_delay=0.13
    local spinner_assets=('◜' '◝' '◞' '◟')
    { 
        while :; do 
            for X in ${spinner_assets[@]}; do
                echo -en "\b$X"
                sleep $asset_delay
            done; 
        done & 
    } 2>/dev/null
    spinner_pid=$!
}
export -f start_spinner

stop_spinner() {
    disown $spinner_pid
    kill -9 $spinner_pid && wait
    set -m  # enable job control
    echo -en "\033[2K\r"
    tput cnorm  # display cursor
}
export -f stop_spinner
# Clean the spinner if the script is stopped
trap stop_spinner EXIT


#######################################################################
#                         Deps helpers                                #
#######################################################################
find_command() {
    # Check if command available
    command_name=$1
    command -v "$command_name" &>/dev/null;
}
export -f find_command

validate_command() {
    # Validate dependency
    # If dependency is not installed, print error message with the relevant docs
    cmd_call="$1"  # callable command name
    cmd_name="$2" # human readable command name
    cmd_docs_url="$3"  # url to the docs
    if ! find_command "$cmd_call"; then
        cecho red "Please install $cmd_name"
        cecho red "Read more about how to install $cmd_name here: $cmd_docs_url"
        error "$cmd_name is not installed"
    fi
}
export -f find_command

get_command_path() { 
    # Get command full path
    command_name=$1
    command -v "$command_name"; 
}
export -f get_command_path

check_py_package() {
    # Check is python package installed
    python_cmd=$1
    package_name=$2
    $python_cmd -c "import $package_name" &>/dev/null; 
}
export -f check_py_package


#######################################################################
#                            OS helpers                               #
#######################################################################
isdirectory() {
    # Check is path a valid directory
    dir_path=$1
    [ -d "$dir_path" ];
}
export -f isdirectory

get_linux_os_name() {
    local IFS="="
    local distribution_id_row=(
        $(cat /etc/lsb-release | grep "DISTRIB_ID")
    )
    local os_name="${distribution_id_row[1]}"
    echo $os_name
}

get_os_name() {
    case "$OSTYPE" in
        darwin*) echo "OSX" ;;
        linux*) (get_linux_os_name 2>/dev/null || echo LINUX) | tr '[:lower:]' '[:upper:]' ;;
        solaris*) echo "SOLARIS" ;;
        bsd*) echo "BSD" ;;
        msys*) echo "WINDOWS" ;;
        cygwin*) echo "WINDOWS" ;;
        *) echo "UNKNOWN" ;;
    esac
}
export -f get_os_name
