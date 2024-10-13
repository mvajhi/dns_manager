#!/bin/bash

# Network interface for Wi-Fi
INTERFACE="wlo1"

# Load DNS profiles from an external file
PROFILE_FILE="./.dns_profiles"

# Check if the profile file exists
if [ ! -f "$PROFILE_FILE" ]; then
    echo "Profile file $PROFILE_FILE not found!"
    exit 1
fi

# Source the profile file
source "$PROFILE_FILE"

# Check the number of arguments and validate the command
if [ "$1" == "set" ]; then
    if [ "$#" -lt 2 ]; then
        echo "Usage: $0 set <profile_name>"
        exit 1
    fi
elif [ "$1" == "unset" ]; then
    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 unset"
        exit 1
    fi
else
    echo "Invalid command. Use 'set <profile_name>' or 'unset'."
    exit 1
fi

# Get the active Wi-Fi connection name for the wlo1 interface
ACTIVE_CONNECTION=$(nmcli device status | grep "$INTERFACE" | awk '{print $4}')

if [ -z "$ACTIVE_CONNECTION" ] || [ "$ACTIVE_CONNECTION" == "--" ]; then
    echo "No active Wi-Fi connection found on interface $INTERFACE."
    exit 1
fi

# Set or unset DNS based on the first argument
if [ "$1" == "set" ]; then
    PROFILE_NAME=$2
    
    # Check if the profile name exists in DNS_PROFILES
    if [[ -v DNS_PROFILES["$PROFILE_NAME"] ]]; then
        # Set the DNS servers and disable IPv6
        DNS_SERVERS=${DNS_PROFILES["$PROFILE_NAME"]}
        nmcli con mod "$ACTIVE_CONNECTION" ipv4.dns "$DNS_SERVERS"
        nmcli con mod "$ACTIVE_CONNECTION" ipv4.ignore-auto-dns yes
        nmcli con mod "$ACTIVE_CONNECTION" ipv6.method "disabled"
        nmcli con up "$ACTIVE_CONNECTION"
        echo "DNS for active connection '$ACTIVE_CONNECTION' set to profile '$PROFILE_NAME': $DNS_SERVERS, and IPv6 has been disabled."
    else
        echo "Profile '$PROFILE_NAME' not found. Available profiles are: ${!DNS_PROFILES[@]}"
        exit 1
    fi

elif [ "$1" == "unset" ]; then
    # Unset the DNS servers and re-enable automatic IPv6
    nmcli con mod "$ACTIVE_CONNECTION" ipv4.ignore-auto-dns no
    nmcli con mod "$ACTIVE_CONNECTION" ipv4.dns ""
    nmcli con mod "$ACTIVE_CONNECTION" ipv6.method "auto"
    nmcli con up "$ACTIVE_CONNECTION"
    echo "DNS for active connection '$ACTIVE_CONNECTION' has been unset, and IPv6 has been re-enabled."
fi

