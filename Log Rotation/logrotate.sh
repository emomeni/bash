#!/bin/bash

# Configuration variables
LOG_DIR="/var/log"                # Directory containing logs
MAX_SIZE="10M"                    # Maximum size of a log file before rotation
ROTATE_COUNT=7                    # Number of rotated logs to keep
COMPRESS=true                     # Compress old logs (true/false)
COMPRESS_METHOD="gzip"            # Compression method: gzip or bzip2
EXTENSIONS=("*.log" "*.txt")      # Log file extensions to target
EXCLUDE_FILES=("access.log" "error.log")  # Files to exclude from rotation
EMAIL="admin@example.com"         # Email address for notifications
VERBOSE=false                     # Enable verbose mode for detailed output

# Function to send email notifications
send_email() {
    local subject="$1"
    local message="$2"
    echo -e "$message" | mail -s "$subject" "$EMAIL"
}

# Function to compress logs
compress_logs() {
    local log_file="$1"
    if [[ "$COMPRESS" == true ]]; then
        if [[ "$COMPRESS_METHOD" == "gzip" ]]; then
            gzip "$log_file"
            echo "Compressed with gzip: $log_file"
        elif [[ "$COMPRESS_METHOD" == "bzip2" ]]; then
            bzip2 "$log_file"
            echo "Compressed with bzip2: $log_file"
        else
            echo "Unsupported compression method: $COMPRESS_METHOD"
        fi
    fi
}

# Function to rotate logs
rotate_logs() {
    local log_file="$1"

    # Check if the log file exists
    if [[ ! -f "$log_file" ]]; then
        echo "Log file not found: $log_file"
        return
    fi

    # Check if the log file is excluded
    for exclude in "${EXCLUDE_FILES[@]}"; do
        if [[ "$log_file" == *"$exclude"* ]]; then
            echo "Excluding log file: $log_file"
            return
        fi
    done

    # Get the size of the log file
    log_size=$(du -b "$log_file" | awk '{print $1}')
    max_bytes=$(echo "$MAX_SIZE" | sed 's/[KM]//')  # Convert MAX_SIZE to bytes

    # Convert K/M to bytes if necessary
    if [[ "$MAX_SIZE" == *K ]]; then
        max_bytes=$((max_bytes * 1024))
    elif [[ "$MAX_SIZE" == *M ]]; then
        max_bytes=$((max_bytes * 1024 * 1024))
    fi

    # Rotate if the log file exceeds the maximum size
    if [[ $log_size -ge $max_bytes ]]; then
        if [[ "$VERBOSE" == true ]]; then
            echo "Rotating log: $log_file"
        fi

        # Create a timestamped backup of the current log
        timestamp=$(date +"%Y%m%d%H%M%S")
        mv "$log_file" "${log_file}.${timestamp}"

        # Compress the rotated log
        compress_logs "${log_file}.${timestamp}"

        # Limit the number of rotated logs
        rotated_logs=$(ls -1 "${log_file}."* 2>/dev/null | sort)
        count=0
        for rotated_log in $rotated_logs; do
            count=$((count + 1))
            if [[ $count -gt $ROTATE_COUNT ]]; then
                if [[ "$VERBOSE" == true ]]; then
                    echo "Deleting old log: $rotated_log"
                fi
                rm -f "$rotated_log"
            fi
        done

        # Create a new empty log file
        touch "$log_file"
        chmod 640 "$log_file"  # Set appropriate permissions

        # Notify via email
        if [[ "$EMAIL" != "" ]]; then
            send_email "Log Rotated: $log_file" "Log file $log_file has been rotated."
        fi
    else
        if [[ "$VERBOSE" == true ]]; then
            echo "Log file within size limit: $log_file"
        fi
    fi
}

# Main script logic
echo "Starting log rotation..."

# Find all log files in the specified directory with the given extensions
for ext in "${EXTENSIONS[@]}"; do
    find "$LOG_DIR" -type f -name "$ext" | while IFS= read -r log_file; do
        rotate_logs "$log_file"
    done
done

echo "Log rotation completed."
