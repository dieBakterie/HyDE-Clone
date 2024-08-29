#!/usr/bin/env bash
#|---/ /+--------------------------+---/ /|#
#|--/ /-| Idle installation script |--/ /-|#
#|-/ /--| derDelphin               |-/ /--|#
#|/ /---+--------------------------+/ /---|#

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/global_fn.sh"
if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

echo -e "Select shell:\n[1] zsh\n[2] fish\n[3] bash\n[4] No Shell"
prompt "Enter option number"

case "${promptIn}" in
1) export myShell="zsh" ;;
2) export myShell="fish" ;;
3) export myShell="bash" ;;
4) export myShell="" ;;
*)
    echo -e "...Invalid option selected..."
    exit 1
    ;;
esac

# skip if user selects "" as shell
if [ "${myShell}" == "" ]; then
    echo -e "\n\033[0;32m[SKIP]\033[0m Shell: No Shell selected, skipping!"
    exit 0
else
    echo -e "\n\033[0;32m[SHELL]\033[0m Shell: ${myShell}"
    echo "${myShell}" >>"${scrDir}/install_pkg.lst"
fi
