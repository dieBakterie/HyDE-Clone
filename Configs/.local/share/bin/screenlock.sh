#!/usr/bin/env bash
# shellcheck disable=SC1091
# shellcheck disable=SC2154

# set variables
scrDir="$(dirname "$(realpath "$0")")"
source "$scrDir/globalcontrol.sh"
export -f pkg_installed

# define functions

# locks the screen depending on lockscreen package
fn_lockscreen() {
    if pkg_installed "swaylock-effects-git"; then
        swaylock
    elif pkg_installed "hyprlock" || pkg_installed "hyprlock-git"; then
        hyprlock
    else
        echo "No supported lockscreen package installed." >&2
        exit 1
    fi
}

# sets the idle lock command
fn_check_lockscreen() { # this function is for hypridle/swayidle to set the lockscreen
    if pkg_installed "swaylock-effects-git"; then
        lockScreen=swaylock
    elif pkg_installed "hyprlock" || pkg_installed "hyprlock-git"; then
        lockScreen=hyprlock
    else
        lockScreen="none"
    fi
    echo "Lock screen: ${lockScreen}"
}

# locks the screen depending on player status
fn_check_playerctl() {
    "${scrDir}/hyprlock.sh" --lock
}

# displays help message
show_help() {
    cat <<HELP
Usage: $(basename "$0") [options]

Options:
  -m    Lock the screen depending on player status
  -h    Show this help message
HELP
}

# main
main() {
    while getopts ":mh" opt; do
        case $opt in
            m)
                fn_check_playerctl
                ;;
            h)
                show_help
                exit 0
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                show_help
                exit 1
                ;;
        esac
    done
}

main "$@"
