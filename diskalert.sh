#!/bin/bash

# Define the threshold 
THRESHOLD=10

# Get the current disk usage percentage for the root partition
CURRENT_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')

# Check if the current usage exceeds the threshold
if [ "$CURRENT_USAGE" -gt "$THRESHOLD" ]; then
    echo "Alert: Disk usage has exceeded ${THRESHOLD}%!"
    echo "Current usage: ${CURRENT_USAGE}%"
else
    echo "Disk usage is under control: ${CURRENT_USAGE}%"
fi

