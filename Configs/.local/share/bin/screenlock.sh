#!/usr/bin/env bash
# shellcheck disable=SC1091
# shellcheck disable=SC2154

scrDir=$(dirname "$(realpath "$0")")
source "$scrDir/globalcontrol.sh"
export -f pkg_installed

# Functions

# Locks the screen depending on lockscreen package
fn_lockscreen() {
    if pkg_installed "swaylock-effects-git"; then
        swaylock
    elif pkg_installed "hyprlock" || pkg_installed "hyprlock-git"; then
        hyprlock
    fi
}

# Sets the idle lock command
fn_check_lockscreen() { # this function is for hypridle/swayidle to set the lockscreen
    if pkg_installed "swaylock-effects-git"; then
        SCREENLOCK=swaylock
    elif pkg_installed "hyprlock" || pkg_installed "hyprlock-git"; then
        SCREENLOCK=hyprlock
    fi
    export SCREENLOCK
    echo "${SCREENLOCK}"
}

# Locks the screen depending on player status
fn_check_playerctl() {
    "${scrDir}/hyprlock.sh" --thumbnail --lock
}

# Displays help message
show_help() {
    echo "Usage: $(basename "$0") [-c] [-l] [-m]"
    echo
    echo "Options:"
    echo "  -c    Set the idle lock command"
    echo "  -l    Lock the screen"
    echo "  -m    Lock the screen depending on player status"
    echo "  -h    Show this help message"
}

# main
main() {
    while getopts ":clmh" opt; do
        case $opt in
        c) fn_check_lockscreen ;;
        l) fn_lockscreen ;;
        m) fn_check_playerctl ;;
        h) show_help ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            show_help
            exit 1
            ;;
        esac
    done
}

main "$@"
