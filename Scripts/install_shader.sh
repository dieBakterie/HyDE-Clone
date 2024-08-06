#!/usr/bin/env bash
#|---/ /+----------------------------+---/ /|#
#|--/ /-| Shader installation script |--/ /-|#
#|-/ /--| Prasanth Rangan            |-/ /--|#
#|/ /---+----------------------------+/ /---|#

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/global_fn.sh"
if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

echo -e "Select shader:\n[1] hyprshade\n[2] hyprshade-git\n[3] wl-gammarelay-rs\n[4] No Shader"
prompt_timer 120 "Enter option number"

case "${promptIn}" in
1) export myShader="hyprshade" ;;
2) export myShader="hyprshade-git" ;;
3) export myShader="wl-gammarelay-rs" ;;
4) export myShader="" ;;
*)
    echo -e "...Invalid option selected..."
    exit 1
    ;;
esac

# skip if user selects "" as shader
if [ "${myShader}" == "" ]; then
    echo -e "\n\033[0;32m[SKIP]\033[0m Shader: No Shader selected, skipping!"
    exit 0
else
    echo -e "\n\033[0;32m[SHADER]\033[0m Shader: ${myShader}"
    echo "${myShader}" >>"${scrDir}/install_pkg.lst"

    # remove -git from myShader for exec-once command
    if [[ "${myShader}" == *"-git" ]]; then
        myShader=$(echo "${myShader}" | sed -E 's/-git$//')
    fi

    update_shader_config() {
        local file=$1

        if [[ "${myShader}" == "wl-gammarelay-rs" ]]; then
            if ! grep -q "exec-once = wl-gammarelay-rs # start wl-gammarelay-rs" "$file"; then
                echo -e "\n\nexec-once = wl-gammarelay-rs # start wl-gammarelay-rs" >>"$file"
            fi
        elif [[ "${myShader}" == "hyprshade" || "${myShader}" == "hyprshade-git" ]]; then
            if ! grep -q "# Night Light" "$file"; then
                echo -en "\n\n# Night Light\nexec-once = dbus-update-activation-environment --systemd HYPRLAND_INSTANCE_SIGNATURE\nexec = hyprshade auto" >>"$file"
            fi
        fi
    }

    update_keybindings() {
        local file=$1
        # Update keybindings if hyprshade is selected
        if [[ "${myShader}" == "hyprshade" ]]; then
            if ! grep -q "# Night light" "$file"; then
                echo -en "\n\n# Night light\nbindd = Ctrl , P, Enable Vibrance Hyprshade Shader, exec, hyprshade on vibrance\nbindd = Ctrl, L, Enable blue light filter, exec, hyprshade on blue-light-filter" >>"$file"
            fi
        elif [ "${myShader}" == "wl-gammarelay-rs" ]; then
            if ! grep -q "# wl-gammarelay-rs start"; then
                echo -en "\n\nbind = , F6, exec, busctl --user --call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n -500\nbind = , F4, exec, busctl --user --call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n +500"
            fi
        fi
    }

    # Update or add shader config in the configuration file
    update_shader_config "${cloneDir}/Configs/.config/hypr/config/launchs.conf"

    # Add keybindings for myShader
    if [[ "${myShader}" == "hyprshade" || "${myShader}" == "wl-gammarelay-rs" ]]; then
        update_keybindings "${cloneDir}/Configs/.config/hypr/config/keybindings.conf"
    fi
fi

