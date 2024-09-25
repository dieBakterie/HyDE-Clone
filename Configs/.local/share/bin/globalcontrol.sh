#!/usr/bin/env bash

# lycr envs
export confDir="${XDG_CONFIG_HOME:-$HOME/.config}"
export lycrConfDir="${confDir}/lycr"
export cacheDir="$HOME/.cache/lycr"
export thmbDir="${cacheDir}/thumbs"
export dcolDir="${cacheDir}/dcols"
export hashMech="sha1sum"

get_hashmap()
{
    unset wallHash
    unset wallList
    unset skipStrays
    unset verboseMap

    for wallSource in "$@"; do
        [ -z "${wallSource}" ] && continue
        [ "${wallSource}" == "--skipstrays" ] && skipStrays=1 && continue
        [ "${wallSource}" == "--verbose" ] && verboseMap=1 && continue

        hashMap=$(find "${wallSource}" -type f \( -iname "*.gif" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -exec "${hashMech}" {} + | sort -k2)
        if [ -z "${hashMap}" ] ; then
            echo "WARNING: No image found in \"${wallSource}\""
            continue
        fi

        while read -r hash image ; do
            wallHash+=("${hash}")
            wallList+=("${image}")
        done <<< "${hashMap}"
    done

    if [ -z "${#wallList[@]}" ] || [[ "${#wallList[@]}" -eq 0 ]] ; then
        if [[ "${skipStrays}" -eq 1 ]] ; then
            return 1
        else
            echo "ERROR: No image found in any source"
            exit 1
        fi
    fi

    if [[ "${verboseMap}" -eq 1 ]] ; then
        echo "// Hash Map //"
        for indx in "${!wallHash[@]}" ; do
            echo ":: \${wallHash[${indx}]}=\"${wallHash[indx]}\" :: \${wallList[${indx}]}=\"${wallList[indx]}\""
        done
    fi
}

get_themes()
{
    unset thmSortS
    unset thmListS
    unset thmWallS
    unset thmSort
    unset thmList
    unset thmWall

    while read -r thmDir ; do
        if [ ! -e "$(readlink "${thmDir}/wall.set")" ] ; then
            get_hashmap "${thmDir}" --skipstrays || continue
            echo "fixig link :: ${thmDir}/wall.set"
            ln -fs "${wallList[0]}" "${thmDir}/wall.set"
        fi
        [ -f "${thmDir}/.sort" ] && thmSortS+=("$(head -1 "${thmDir}/.sort")") || thmSortS+=("0")
        thmListS+=("$(basename "${thmDir}")")
        thmWallS+=("$(readlink "${thmDir}/wall.set")")
    done < <(find "${lycrConfDir}/themes" -mindepth 1 -maxdepth 1 -type d)

    while IFS='|' read -r sort theme wall ; do
        thmSort+=("${sort}")
        thmList+=("${theme}")
        thmWall+=("${wall}")
    done < <(parallel --link echo "{1}\|{2}\|{3}" ::: "${thmSortS[@]}" ::: "${thmListS[@]}" ::: "${thmWallS[@]}" | sort -n -k 1 -k 2)

    if [ "${1}" == "--verbose" ] ; then
        echo "// Theme Control //"
        for indx in "${!thmList[@]}" ; do
            echo -e ":: \${thmSort[${indx}]}=\"${thmSort[indx]}\" :: \${thmList[${indx}]}=\"${thmList[indx]}\" :: \${thmWall[${indx}]}=\"${thmWall[indx]}\""
        done
    fi
}

[ -f "${lycrConfDir}/lycr.conf" ] && source "${lycrConfDir}/lycr.conf"

case "${enableWallDcol}" in
    0|1|2|3) ;;
    *) enableWallDcol=0 ;;
esac

if [[ -z "${lycrTheme}" || ! -d "${lycrConfDir}/themes/${lycrTheme}" ]] ; then
    get_themes
    lycrTheme="${thmList[0]}"
fi

export lycrTheme
export lycrThemeDir="${lycrConfDir}/themes/${lycrTheme}"
export wallbashDir="${lycrConfDir}/wallbash"
export enableWallDcol

# hypr vars
if printenv HYPRLAND_INSTANCE_SIGNATURE &> /dev/null; then
    hypr_border="$(hyprctl -j getoption decoration:rounding | jq '.int')"
    export hypr_border
    hypr_width="$(hyprctl -j getoption general:border_size | jq '.int')"
    export hypr_width
fi

# extra fns
pkg_installed()
{
    local pkgIn="$1"
    if pacman -Qi "${pkgIn}" &> /dev/null ; then
        return 0
    elif pacman -Qi "flatpak" &> /dev/null && flatpak info "${pkgIn}" &> /dev/null ; then
        return 0
    elif command -v "${pkgIn}" &> /dev/null ; then
        return 0
    else
        return 1
    fi
}

if pkg_installed dunst && pkg_installed swaync || pkg_installed dunst-git && pkg_installed swaync-git; then
    echo "Error you should not have dunst and swaync installed at the same time!"
    exit 1
    elif pkg_installed dunst || pkg_installed dunst-git; then
        icoDir="$HOME/.local/share/icons"
    elif pkg_installed swaync || pkg_installed swaync-git; then
        icoDir="$HOME/.local/share/icons"
    export icoDir
fi

get_aurhlpr()
{
    if pkg_installed yay
    then
        aurhlpr="yay"
    elif pkg_installed paru
    then
        aurhlpr="paru"
    fi
}

set_conf()
{
    local varName="${1}"
    local varData="${2}"
    touch "${lycrConfDir}/lycr.conf"

    if [ "$(grep -c "^${varName}=" "${lycrConfDir}/lycr.conf")" -eq 1 ] ; then
        sed -i "/^${varName}=/c${varName}=\"${varData}\"" "${lycrConfDir}/lycr.conf"
    else
        echo "${varName}=\"${varData}\"" >> "${lycrConfDir}/lycr.conf"
    fi
}

set_hash()
{
    local hashImage="${1}"
    "${hashMech}" "${hashImage}" | awk '{print $1}'
}