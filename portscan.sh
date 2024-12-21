#!/bin/bash

# Function to check if a port is open
check_port() {
    local hostname=$1
    local port=$2
    if 2>/dev/null echo > /dev/tcp/$hostname/$port; then
        echo "Port $port is open" >> "$hostname.portscanner.txt"
    else
        echo "Port $port is closed" >> "$hostname.portscanner.txt"
    fi
}

# Prompt for the hostname or IP address
read -p "Please specify the IP address or hostname: " hostname

# Validate if the hostname is reachable
if ! ping -c 1 -W 1 "$hostname" &> /dev/null; then
    echo "Error: Unable to reach $hostname. Please check the IP address or hostname."
    exit 1
fi

# Prompt for the port range
read -p "Please specify the port range (e.g., 1-1000): " port_range

# Extract start and end port from the range
start_port=$(echo "$port_range" | cut -d'-' -f1)
end_port=$(echo "$port_range" | cut -d'-' -f2)

# Validate port range input
if ! [[ $start_port =~ ^[0-9]+$ ]] || ! [[ $end_port =~ ^[0-9]+$ ]] || [ $start_port -le 0 ] || [ $end_port -gt 65535 ] || [ $start_port -gt $end_port ]; then
    echo "Error: Invalid port range. Please provide a valid range (e.g., 1-1000)."
    exit 1
fi

# Create a results file
output_file="$hostname.portscanner.txt"
> "$output_file" # Clear the file if it exists

# Inform the user that scanning is starting
echo "Starting port scan on $hostname from port $start_port to $end_port..."
echo "Results will be saved to $output_file."

# Scan ports in parallel
for ((port=start_port; port<=end_port; port++)); do
    check_port "$hostname" "$port" &
    if (( $(jobs | wc -l) >= 100 )); then # Limit to 100 parallel jobs
        wait -n
    fi
done

# Wait for all background jobs to finish
wait

# Inform the user the scan is complete
echo "Port scanning completed. Results saved to $output_file."
