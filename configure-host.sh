#!/bin/bash
# Richard Cusick 200560006
# Assignment 3

# Updating hostname

update_hostname() {
	local current_hostname=$(hostname) # Gets the current hostname
	if [ "$current_hostname" != "$HOSTNAME" ]; then # Checks the current hostname against the desired hostname
        	log_message "Changing hostname from $current_hostname to $HOSTNAME"
        	echo "$HOSTNAME" > /etc/hostname # Writes the hostname to /etc/hostname
        	hostname "$HOSTNAME" # Applies the hostname to the running machine
        	sed -i "s/$current_hostname/$HOSTNAME/g" /etc/hosts # Updates the hostname in /etc/host
        	logger "Hostname changed from $current_hostname to $HOSTNAME" # Logs the change using the logger program
    	else
        	log_message "Hostname is already set to $HOSTNAME"
    	fi
}

# Updating IP address
update_ip() {
    	local current_ip=$(hostname -I | awk '{print $1}') # Gets the current IP addres
    	if [ "$current_ip" != "$IPADDRESS" ]; then # Checks the current IP address from the desired IP address
        	log_message "Changing IP address from $current_ip to $IPADDRESS"
        	sed -i "s/$current_ip/$IPADDRESS/g" /etc/hosts # Updates the IP address in /etc/host
        	sed -i "s/$current_ip/$IPADDRESS/g" /etc/netplan/*.yaml # Updates IP address in netplan configuration file
        	netplan apply # Applies the netplan configuration
		logger "IP address changed from $current_ip to $IPADDRESS" # Logs the change using the logger program
	else
		log_message "IP address is already set to $IPADDRESS"
	fi
}

# Updating /etc/hosts entry
update_hosts_entry() {
    if ! grep -q "$HOSTENTRY_NAME" /etc/hosts; then # Checks to see if the desired host is present in /etc/hosts
        log_message "Adding $HOSTENTRY_NAME with IP $HOSTENTRY_IP to /etc/hosts"
        echo "$HOSTENTRY_IP $HOSTENTRY_NAME" >> /etc/hosts # Adds host entry to /etc/hosts
        logger "Added $HOSTENTRY_NAME with IP $HOSTENTRY_IP to /etc/hosts" # Logs the change using the logger program
    else
        log_message "$HOSTENTRY_NAME with IP $HOSTENTRY_IP already exists in /etc/hosts"
    fi
}
