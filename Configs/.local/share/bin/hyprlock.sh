#!/usr/bin/env bash
# shellcheck disable=SC2154
# shellcheck disable=SC1091


#// set variables

scrDir="$(dirname "$(realpath "$0")")"
source "$scrDir/globalcontrol.sh"


#// define functions


#// locks screen depending on player status

fn_hyprlock() {
    if [[ $(playerctl status) == Playing ]]; then
        hyprlock --config "${confDir}/hyprlock/presets/hyprlock_music.conf"
    elif [[ $(playerctl status) == Paused ]]; then
        hyprlock --config "${confDir}/hyprlock/presets/hyprlock_music_paused.conf"
    else
        hyprlock
    fi
}


#// sets the background image

fn_background() {
    local wallpaper_path
    wallpaper_path=$(swww query | grep -oP '(?<=image: ).*' | head -n 1)

    #// replace lockFile in the configuration files
    background "${confDir}/hypr/hyprlock.conf" "$wallpaper_path"
    for file in "${confDir}/hyprlock/presets"/*; do
        background "$file" "$wallpaper_path"
    done
}


#// function to update the wallpaperpath in the configuration files

background() {
    local file=$1
    local wallpaper_path=$2

    #// use sed to directly edit the file
    sed -i -e "s|^\(\$wallpaper = \).*|\1${wallpaper_path}|" "$file"
    echo -e "\033[0;32m[BACKGROUND]\033[0m ${wallpaper_path} -> ${file}"
}


#// sets the MPRIS thumbnail

fn_mpris() {
   local thumb
   thumb="${cacheDir}/thumb"
   { mpris_thumb; } || { rm -f "${thumb}.*" && exit 1; }
}


#// get the MPRIS thumbnail

mpris_thumb() {
   local artUrl
   artUrl=$(playerctl metadata --format '{{mpris:artUrl}}')
   [[ "${artUrl}" = "$(cat "${thumb}.inf")" ]] && return 0

   printf "%s\n" "$artUrl" >"${thumb}.inf"

   curl -so "${thumb}.jpg" "$artUrl"
}


#// show help message

ask_help() {
    cat <<HELP
Usage: $(basename "$0") [options]
Options:
  -h, --help        Show this help message
  -l, --lock        Lock the screen
  -b, --background  Set background
  -t, --thumbnail   Set MPRIS thumbnail
HELP
}


#// main function

main() {
    local lock=false
    local background=false
    local thumbnail=false

    while [[ $# -gt 0 ]]; do
        case $1 in
        -h | --help)
            ask_help
            exit 0
            ;;
        -l | --lock) lock=true ;;
        -b | --background) background=true ;;
        -t | --thumbnail) thumbnail=true ;;
        -*)
            #// iterate over combined short options
            for ((i = 1; i < ${#1}; i++)); do
                case ${1:i:1} in
                l) lock=true ;;
                b) background=true ;;
                t) thumbnail=true ;;
                h)
                    ask_help
                    exit 0
                    ;;
                *)
                    echo "Invalid option: -${1:i:1}"
                    ask_help
                    exit 1
                    ;;
                esac
            done
            ;;
        *)
            echo "Invalid option: $1"
            ask_help
            exit 1
            ;;
        esac
        shift
    done

    $lock && fn_hyprlock
    $background && fn_background
    $thumbnail && fn_mpris
}

main "$@"
