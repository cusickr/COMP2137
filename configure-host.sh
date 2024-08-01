#!/bin/bash
# Richard Cusick 200560006
# Assignment 3

# Updating hostname

update hostname {
	local current_hostname=$(hostname) #Gets the current hostname
	if [ "$current_hostname" != "$HOSTNAME" ]; then #Checks if the current hostname is different from the desired hostname
        	log_message "Changing hostname from $current_hostname to $HOSTNAME"
        	echo "$HOSTNAME" > /etc/hostname #Writes the hostname to /etc/hostnam
        	hostname "$HOSTNAME" #Applies the hostname to the running machine
        	sed -i "s/$current_hostname/$HOSTNAME/g" /etc/hosts #Updates the hostname in /etc/host
        	logger "Hostname changed from $current_hostname to $HOSTNAME" # Logs the change using the logger progra
    	else
        	log_message "Hostname is already set to $HOSTNAME"
    	fi
}

