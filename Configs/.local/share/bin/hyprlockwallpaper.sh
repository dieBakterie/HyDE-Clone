#!/usr/bin/env bash

# lock instance
lockFile="/tmp/lycr$(id -u)$(basename ${0}).lock"
[ -e "${lockFile}" ] && echo "An instance of the script is already running..." && exit 1
touch "${lockFile}"
trap 'rm -f ${lockFile}' EXIT

# define functions

# function to update the wallpaper path in the configuration files
background() {
    local file=$1
    local wallpaper_path=$2

    # update wallpaper in configuration files
    sed -i -e "s|^\(\$wallpaper = \).*|\1${wallpaper_path}|" "$file"
    echo -e "\033[0;32m[BACKGROUND]\033[0m ${wallpaper_path} -> ${file}"
}

# sets the background image for Hyprlock
fn_background() {
    local wallpaper_path=$1

    if [[ -z $wallpaper_path ]]; then
        echo "No wallpaper path provided."
        exit 1
    fi

    # replace wallpaper in the configuration files
    background "${confDir}/hypr/hyprlock.conf" "$wallpaper_path"
    for file in "${confDir}/hyprlock/presets"/*; do
        background "$file" "$wallpaper_path"
    done
}

Wall_Cache()
{
    ln -fs "${wallList[setIndex]}" "${wallSet}"
    ln -fs "${wallList[setIndex]}" "${wallCur}"
    "${scrDir}/swwwallcache.sh" -w "${wallList[setIndex]}" &> /dev/null
    "${scrDir}/swwwallbash.sh" "${wallList[setIndex]}" &
    ln -fs "${thmbDir}/${wallHash[setIndex]}.sqre" "${wallSqr}"
    ln -fs "${thmbDir}/${wallHash[setIndex]}.thmb" "${wallTmb}"
    ln -fs "${thmbDir}/${wallHash[setIndex]}.blur" "${wallBlr}"
    ln -fs "${thmbDir}/${wallHash[setIndex]}.quad" "${wallQad}"
    ln -fs "${dcolDir}/${wallHash[setIndex]}.dcol" "${wallDcl}"
}

Wall_Change() {
    curWall="$(set_hash "${wallSet}")"
    for i in "${!wallHash[@]}" ; do
        if [ "${curWall}" == "${wallHash[i]}" ] ; then
            if [ "${1}" == "n" ] ; then
                setIndex=$(( (i + 1) % ${#wallList[@]} ))
            elif [ "${1}" == "p" ] ; then
                setIndex=$(( i - 1 ))
            fi
            break
        fi
    done
    Wall_Cache
}

# set variables
scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
wallSet="${lycrThemeDir}/wall.set"
wallCur="${cacheDir}/wall.set"
wallSqr="${cacheDir}/wall.sqre"
wallTmb="${cacheDir}/wall.thmb"
wallBlr="${cacheDir}/wall.blur"
wallQad="${cacheDir}/wall.quad"
wallDcl="${cacheDir}/wall.dcol"

# check wall
setIndex=0
[ ! -d "${lycrThemeDir}" ] && echo "ERROR: \"${lycrThemeDir}\" does not exist" && exit 0
wallPathArray=("${lycrThemeDir}")
wallPathArray+=("${wallAddCustomPath[@]}")
get_hashmap "${wallPathArray[@]}"
[ ! -e "$(readlink -f "${wallSet}")" ] && echo "fixig link :: ${wallSet}" && ln -fs "${wallList[setIndex]}" "${wallSet}"

# evaluate options
while getopts "nps:" option ; do
    case $option in
    n )
        # set next wallpaper
        Wall_Change n
        ;;
    p )
        # set previous wallpaper
        Wall_Change p
        ;;
    s )
        # set input wallpaper
        if [ -n "${OPTARG}" ] && [ -f "${OPTARG}" ] ; then
            get_hashmap "${OPTARG}"
        fi
        Wall_Cache
        ;;
    * )
        # invalid option
        echo "... invalid option ..."
        echo "$(basename "${0}") -[option]"
        echo "n : set next wall"
        echo "p : set previous wall"
        echo "s : set input wallpaper"
        exit 1 ;;
    esac
done

# apply wallpaper
echo ":: applying wall :: \"$(readlink -f "${wallSet}")\""
fn_background "$(readlink -f "${wallSet}")" &