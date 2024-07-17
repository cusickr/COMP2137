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

# Configuring netplan
configure_netplan() {
    NETPLAN_FILE="/etc/netplan/01-netcfg.yaml"
    IP_ADDRESS="192.168.16.21/24"

    if ! grep -q "$IP_ADDRESS" "$NETPLAN_FILE"; then
        print_message "Configuring netplan"
        # This is assuming the existing configuration needs to be appended
        echo -e "network:\n  version: 2\n  ethernets:\n    eth0:\n      addresses:\n        - $IP_ADDRESS" > "$NETPLAN_FILE"
        netplan apply
    else
        print_message "Netplan is already configured"
    fi
}

# Configure hosts in /etc
configure_hosts() {
    HOST_ENTRY="192.168.16.21 server1"

    if ! grep -q "$HOST_ENTRY" /etc/hosts; then
        print_message "Updating /etc/hosts"
        sed -i '/server1/d' /etc/hosts
        echo "$HOST_ENTRY" >> /etc/hosts
    else
        print_message "/etc/hosts is already configured"
    fi
}
