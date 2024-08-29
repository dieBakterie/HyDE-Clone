#!/usr/bin/env bash

# Path to the os-release file
OS_RELEASE_FILE="/etc/os-release"

# Check if the file exists
if [ ! -f "$OS_RELEASE_FILE" ]; then
    echo "Shitty Distro."
    exit 1
fi

# Extract ID_LIKE and ID values from the os-release file
ID_LIKE=$(grep -oP '^ID_LIKE=\K.*' "$OS_RELEASE_FILE" | tr -d '"')
ID=$(grep -oP '^ID=\K.*' "$OS_RELEASE_FILE" | tr -d '"')

# Return ID_LIKE if it exists, otherwise return ID
if [ -n "$ID_LIKE" ]; then
    export ID_LIKE

else
    export ID
fi
