#!/usr/bin/env bash
#|---/ /+----------------------------+---/ /|#
#|--/ /-| Shader installation script |--/ /-|#
#|-/ /--| Prasanth Rangan            |-/ /--|#
#|/ /---+----------------------------+/ /---|#
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
    echo -e "\n\033[0;32m[userprefs]\033[0m Shader: No Shader selected, skipping!"
    exit 1
else
    echo -e "\n\033[0;32m[userprefs]\033[0m Shader: ${myShader}"
    echo "${myShader}" >>"${scrDir}/install_pkg.lst"

    # remove -git from myShader for exec-once command
    if [[ "${myShader}" == *"-git" ]]; then
        myShader=$(echo "${myShader}" | sed -E 's/-git$//')
    fi

    update_shader_config() {
        local file=$1
        local shader_line
        shader_line=$(grep -E 'exec-once = [^ ]+ auto # start [^ ]+ shader' "$file")
        local current_shader
        current_shader=$(echo "$shader_line" | awk '{print $3}')

        if [[ -z "$shader_line" ]]; then
            # Add new shader line if # Night Light section not found
            echo -en "\n\n# Night Light\nexec-once = ${myShader} auto # start ${myShader} shader" >>"$file"
        elif [[ "$current_shader" != "$myShader" ]]; then
            # Update existing shader line
            sed -i "s|^\(exec-once = \)[^ ]*\( auto # start [^ ]* shader\)|\1${myShader} auto # start ${myShader} shader|" "$file"
        fi
    }

    update_keybindings() {
        local file=$1
        if ! grep -q "# Night light" "$file"; then
            echo -en "\n\n# Night light\nbindd = Ctrl , P, Enable Vibrance Hyprshade Shader, exec, hyprshade on vibrance\nbindd = Ctrl, L, Enable blue light filter, exec, hyprshade on blue-light-filter" >>"$file"
        fi
    }

    # Update or add shader config in the configuration file
    update_shader_config "${cloneDir}/Configs/.config/hypr/configs/launchs.conf"

    # Update keybindings if hyprshade is selected
    if [[ "${myShader}" == "hyprshade" ]]; then
        update_keybindings "${cloneDir}/Configs/.config/hypr/configs/keybindings.conf"
    fi
fi
