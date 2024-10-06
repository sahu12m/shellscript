#!/bin/bash

LOG_FILE="cpu_usage_log.txt"

# Monitor and log CPU usage every 5 seconds
while true; do
    # Get the current CPU usage as  percentage and current time
     CPU_USAGE=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}')
     TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

    # Log and print the CPU usage
    echo "$TIMESTAMP - CPU Usage: $CPU_USAGE" | tee -a $LOG_FILE

    # Wait for 5 seconds before checking again
    sleep 5
done


