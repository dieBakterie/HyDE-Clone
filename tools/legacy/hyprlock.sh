#!/usr/bin/env bash
# shellcheck disable=SC1091
# shellcheck disable=SC2154

# source variables
scrDir=$(dirname "$(realpath "$0")")
source "$scrDir/globalcontrol.sh"

fn_hyprlock() {
    if [[ $(playerctl status) == Playing ]]; then
        hyprlock --config "${confDir}/hyprlock/presets/hyprlock_music.conf"
    elif [[ $(playerctl status) == Paused ]]; then
        hyprlock --config "${confDir}/hyprlock/presets/hyprlock_music_paused.conf"
    else
        hyprlock
    fi
}

fn_background() {
    local wallpaper="${cacheDir}/wall.blur"
    local background="${confDir}/hyprlock/hyprlock.png"
    local MIME
    MIME=$(file --mime-type "${wallpaper}" | grep "image/png")
    cp -f "${wallpaper}" "${background}"
    if [[ -z "${MIME}" ]]; then
        magick "${background}"[0] "${background}"
    fi
}

fn_mpris() {
    local thumb="${cacheDir}/mpris"
    { playerctl metadata --format '{{title}}   {{artist}}' && mpris_thumb; } || { rm -f "${thumb}*" && exit 1; }
}

# Generate thumbnail for mpris
mpris_thumb() {
    local artUrl
    artUrl=$(playerctl metadata --format '{{mpris:artUrl}}')
    [[ "${artUrl}" = "$(cat "${thumb}.inf")" ]] && return 0

    printf "%s\n" "$artUrl" >"${thumb}.inf"

    curl -so "${thumb}.png" "$artUrl"
    pkill -USR2 hyprlock # updates the mpris thumbnail
}

main() {
    while getopts ":hbm" opt; do
        case $opt in
        h)
            fn_hyprlock
            ;;
        b)
            fn_background
            ;;
        m)
            fn_mpris
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            exit 1
            ;;
        esac
    done
}

main "$@"
