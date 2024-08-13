#!/bin/bash

# Display the banner
echo "                                                           "
echo " _____         _      ____  _                             "
echo "|  |  |___ ___| |_   |    \|_|___ ___ ___ _ _ ___ ___ _ _ "
echo "|     | . |_ -|  _|  |  |  | |_ -|  _| . | | | -_|  _| | |"
echo "|__|__|___|___|_|    |____/|_|___|___|___|\_/|___|_| |_  |"
echo "                                                    |___|"
echo "                                                          "
    echo "--------------------------------------------------------------"
    echo "  For any queries please contact : leaulhamdmoeen@gmail.com"
    echo "--------------------------------------------------------------"
    echo "                                                               "

# Function to determine the class of an IP address
get_ip_class() {
    ip=$1
    IFS='.' read -r -a octets <<< "$ip"
    if [ "${octets[0]}" -ge 1 ] && [ "${octets[0]}" -le 126 ]; then
        echo "Class A"
    elif [ "${octets[0]}" -ge 128 ] && [ "${octets[0]}" -le 191 ]; then
        echo "Class B"
    elif [ "${octets[0]}" -ge 192 ] && [ "${octets[0]}" -le 223 ]; then
        echo "Class C"
    else
        echo "Unknown"
    fi
}

# Function to determine the network range based on the IP class
get_network_range() {
    ip=$1
    IFS='.' read -r -a octets <<< "$ip"
    ip_class=$(get_ip_class "$ip")

    if [ "$ip_class" == "Class A" ]; then
        network_range="${octets[0]}.0.0.0/8"
    elif [ "$ip_class" == "Class B" ]; then
        network_range="${octets[0]}.${octets[1]}.0.0/16"
    elif [ "$ip_class" == "Class C" ]; then
        network_range="${octets[0]}.${octets[1]}.${octets[2]}.0/24"
    else
        echo "Unsupported IP class for scanning."
        exit 1
    fi
    echo $network_range
}

# Function to lookup the manufacturer name for a MAC address
get_producer_name_online() {
    mac_prefix=$(echo $1 | cut -d: -f1-3)
    # Query the MAC address lookup API
    response=$(curl -s "https://api.macvendors.com/$mac_prefix")
    if [ -n "$response" ]; then
        echo "$response"
    else
        echo "Unknown"
    fi
}

# Prompt the user for the IP address
read -p "Enter the IP address to scan: " ip_address

# Debug output for IP address
echo "Debug: IP Address = '$ip_address'"

# Ensure an IP address was provided
if [ -z "$ip_address" ]; then
    echo "Error: An IP address must be specified."
    exit 1
fi

# Determine the class of the IP address
ip_class=$(get_ip_class "$ip_address")
echo "                                           "
echo "The IP address $ip_address is in $ip_class."

# Get the network range based on the IP class
network_range=$(get_network_range "$ip_address")
echo "                                           "
echo "Scanning network range: $network_range..."

# Perform a fast nmap scan to get IP and MAC addresses
nmap -sn --max-retries=2 --host-timeout=100ms -oG - $network_range | awk '/Up$/{print $2}' > live_hosts.txt

# Print the header for the table
echo "------------------------------------------------------"
printf "%-15s %-20s %s\n" "IP Address" "MAC Address" "Producer Name"
printf "%-15s %-20s %s\n" "--------- " "-------------------" "----------------"

# Print each row in the table
while read -r ip; do
    mac=$(arp -n $ip | awk '/ether/ {print $3}')
    if [ -n "$mac" ]; then
        producer_name=$(get_producer_name_online "$mac")
        printf "%-15s %-20s %s\n" "$ip" "$mac" "$producer_name"
    fi
done < live_hosts.txt

# Clean up
rm live_hosts.txt
