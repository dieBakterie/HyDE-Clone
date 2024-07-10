#!/usr/bin/env bash
# shellcheck disable=SC1091
# shellcheck disable=SC2154

# set variables
scrDir="$(dirname "$(realpath "$0")")"
source "$scrDir/globalcontrol.sh"

# define functions

if [ $# -eq 0 ]; then
    echo "Usage: $0 --title | --arturl | --artist | --position | --length | --album | --source | --status"
    exit 1
fi

# function to get metadata using playerctl
get_metadata() {
    local key
    key=$1
    playerctl metadata --format "{{ $key }}" 2>/dev/null
}

# function to determine the source and return an icon and text
get_source_info() {
    local trackid
    trackid=$(get_metadata "mpris:trackid")
    case "$trackid" in
        *firefox*) echo -e "Firefox 󰈹" ;;
        *spotify*) echo -e "Spotify " ;;
        *chromium*) echo -e "Chrome " ;;
        *YoutubeMusic*) echo -e "YouTubeMusic " ;;
        *) echo "" ;;
    esac
}

# function to get status using playerctl
get_status() {
    local status
    status=$(playerctl status 2>/dev/null)
    case "$status" in
        "Playing") echo "󰎆" ;;
        "Paused") echo "󱑽" ;;
        "") echo "" ;;
    esac
}

# function to get position using playerctl
get_position() {
    playerctl position 2>/dev/null
}

# function to convert microseconds to minutes and seconds
convert_length() {
    local length=$1
    local seconds=$((length / 1000000))
    local minutes=$((seconds / 60))
    local remaining_seconds=$((seconds % 60))
    printf "%d:%02d m" $minutes $remaining_seconds
}

# function to convert seconds to minutes and seconds
convert_position() {
    local position=$1
    local seconds=${position%.*} # remove fractional part if exists
    local minutes=$((seconds / 60))
    local remaining_seconds=$((seconds % 60))
    printf "%d:%02d" $minutes $remaining_seconds
}

# function to set the MPRIS thumbnail
set_mpris() {
    local thumb
    thumb="${cacheDir}/thumb"
    set_mpris_thumb || { rm -f "${thumb}.*" && exit 1; }
}

# function to get the MPRIS thumbnail
set_mpris_thumb() {
    local artUrl
    artUrl=$(get_metadata "mpris:artUrl")
    [[ "${artUrl}" = "$(cat "${thumb}.inf")" ]] && return 0

    printf "%s\n" "$artUrl" >"${thumb}.inf"

    curl -so "${thumb}.jpg" "$artUrl"
    update_arturl "$thumb.jpg"
}

# function to update the artUrl path in configuration files
update_arturl() {
    local artUrl=$1
    sed -i -e "s|^\(\$artFile = \).*|\1${artUrl}|" "${confDir}/hypr/hyprlock.conf"
    for file in "${confDir}/hyprlock/presets"/*; do
        sed -i -e "s|^\(\$artFile = \).*|\1${artUrl}|" "$file"
        echo -e "\033[0;32m[ARTURL]\033[0m ${artUrl} -> $file"
    done
    echo -e "\033[0;32m[ARTURL]\033[0m ${artUrl} -> $file"
}

# parse the argument
case "$1" in
    --title)
        title=$(get_metadata "xesam:title")
        if [ -z "$title" ]; then
            echo ""
        else
            echo "${title:0:50}" # limit the output to 50 characters
        fi
        ;;
    --arturl)
        url=$(get_metadata "mpris:artUrl")
        if [ -z "$url" ]; then
            echo ""
        else
            if [[ "$url" == file://* ]]; then
                url=${url#file://}
                update_arturl "$url"
            else
                set_mpris
            fi
            echo -e "\033[0;32m[ORIGINAL ARTURL]\033[0m ${url}"
        fi
        ;;
    --artist)
        artist=$(get_metadata "xesam:artist")
        if [ -z "$artist" ]; then
            echo ""
        else
            echo "${artist:0:50}" # limit the output to 50 characters
        fi
        ;;
    --position)
        position=$(get_position)
        length=$(get_metadata "mpris:length")
        if [ -z "$position" ] || [ -z "$length" ]; then
            echo ""
        else
            position_formatted=$(convert_position "$position")
            length_formatted=$(convert_length "$length")
            echo "$position_formatted/$length_formatted"
        fi
        ;;
    --length)
        length=$(get_metadata "mpris:length")
        if [ -z "$length" ]; then
            echo ""
        else
            convert_length "$length"
        fi
        ;;
    --status)
        get_status
        ;;
    --album)
        album=$(get_metadata "xesam:album")
        if [[ -n $album ]]; then
            echo "$album"
        else
            status=$(playerctl status 2>/dev/null)
            if [[ -n $status ]]; then
                echo "No album"
            else
                echo ""
            fi
        fi
        ;;
    --source)
        get_source_info
        ;;
    *)
        echo "Invalid option: $1"
        echo "Usage: $0 --title | --arturl | --artist | --position | --length | --album | --source | --status"
        exit 1
        ;;
esac
