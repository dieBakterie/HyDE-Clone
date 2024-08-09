#!/usr/bin/env bash
# shellcheck disable=SC2154
# shellcheck disable=SC1091

# set variables
scrDir="$(dirname "$(realpath "$0")")"
source "$scrDir/globalcontrol.sh"

# locks screen depending on player status
fn_hyprlock() {
    local player_status
    player_status=$(playerctl status 2>/dev/null)

    case "$player_status" in
        Playing)
            hyprlock --config "${confDir}/hyprlock/presets/hyprlock_music.conf"
            ;;
        Paused)
            hyprlock --config "${confDir}/hyprlock/presets/hyprlock_music_paused.conf"
            ;;
        *)
            hyprlock
            ;;
    esac
}

# show help message
ask_help() {
    cat <<HELP
Usage: $(basename "$0") [options]
Options:
  -h, --help        Show this help message
  -l, --lock        Lock the screen
HELP
}

# main function
main() {
    local lock=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                ask_help
                exit 0
                ;;
            -l|--lock)
                lock=true
                ;;
            -*)
                echo "Invalid option: $1"
                ask_help
                exit 1
                ;;
        esac
        shift
    done

    $lock && fn_hyprlock
}

main "$@"
