#!/bin/bash
#Richard Cusick 200560006
#Assignment2

# Print messages
print_message() {
    echo "========== $1 =========="
}

# Checks and installs packages
check_and_install_package() {
    if ! dpkg -l | grep -q "$1"; then
        print_message "Installing $1"
        apt-get update
        apt-get install -y "$1"
    else
        print_message "$1 is already installed"
    fi
}

