#!/bin/bash
# Richard Cusick 200560006
# Assignment2

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

# Configuring UFW
configure_ufw() {
    if ! ufw status | grep -q "Status: active"; then
        print_message "Configuring UFW"
        ufw allow ssh
        ufw allow http
        ufw allow 3128  # Squid web proxy
        ufw enable
    else
        print_message "UFW is already configured"
    fi
}

# Create users
create_user() {
    USER=$1
    PUBLIC_KEY=$2

    if ! id -u "$USER" &>/dev/null; then
        print_message "Creating user $USER"
        useradd -m -s /bin/bash "$USER"
    else
        print_message "User $USER already exists"
    fi

    if [[ -n "$PUBLIC_KEY" ]]; then
        SSH_DIR="/home/$USER/.ssh"
        AUTH_KEYS_FILE="$SSH_DIR/authorized_keys"

        mkdir -p "$SSH_DIR"
        chown "$USER":"$USER" "$SSH_DIR"
        chmod 700 "$SSH_DIR"

        if ! grep -q "$PUBLIC_KEY" "$AUTH_KEYS_FILE"; then
            echo "$PUBLIC_KEY" >> "$AUTH_KEYS_FILE"
            chown "$USER":"$USER" "$AUTH_KEYS_FILE"
            chmod 600 "$AUTH_KEYS_FILE"
        fi
    fi
}

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
    print_message "This script must be run as root"
    exit 1
fi

# Install necessary packages
check_and_install_package "apache2"
check_and_install_package "squid"
check_and_install_package "ufw"

# Configure netplan
configure_netplan

# Configure /etc/hosts
configure_hosts

# Configure UFW
configure_ufw

# Git configuration
git config --global pull.rebase false
git config --global pull.rebase true
git config --global pull.ff only

# Create users and set up SSH keys
create_user "dennis" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4rT3vTt99Ox5kndS4HmgTrKBT8SKzhK4rhGkEVGlCI richard@pc200560006"
create_user "aubrey"
create_user "captain"
create_user "snibbles"
create_user "brownie"
create_user "scooter"
create_user "sandy"
create_user "perrier"
create_user "cindy"
create_user "tiger"
create_user "yoda"

# Adds dennis to sudo group
if ! groups dennis | grep -q "sudo"; then
    usermod -aG sudo dennis
    print_message "Added dennis to sudo group"
else
    print_message "dennis is already in the sudo group"
fi

print_message "Configuration complete"
