#!/bin/bash
# This script runs the configure-host.sh script from the current directory to modify two servers and update the local /etc/host file

# Function to display help
display_help() {
	echo "Usage: $0 [--verbose]"
    	exit 1
}

# Variables
VERBOSE=""

# Parsing command-line arguments
while [[ "$#" -gt 0 ]]; do
    	case $1 in
        	--verbose)
			VERBOSE="--verbose"
            		shift
            		;;
        	*)
            		display_help
            		;;
    	esac
done

# Copy and execute the configure-host.sh script on server1
scp configure-host.sh remoteadmin@server1-mgmt:/root
ssh remoteadmin@server1-mgmt -- sudo /root/configure-host.sh $VERBOSE -name loghost -ip 192.168.16.3 -hostentry webhost 192.168.16.4

# Copy and execute the configure-host.sh script on server2
scp configure-host.sh remoteadmin@server2-mgmt:/root
ssh remoteadmin@server2-mgmt -- sudo /root/configure-host.sh $VERBOSE -name webhost -ip 192.168.16.4 -hostentry loghost 192.168.16.3

# Update the local /etc/hosts file
./configure-host.sh $VERBOSE -hostentry loghost 192.168.16.3
./configure-host.sh $VERBOSE -hostentry webhost 192.168.16.4
