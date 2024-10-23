#Display information about files in the current working directory. 
#!/bin/bash

# Get the present working directory
pwd=$(pwd)

# Print the header
echo "Present Working Directory: $pwd"
echo ""
echo -e "File Name\t\t\tSize (Bytes)\t\tPermissions\t\tCreation Time\t\t\tModification Time"
echo "===================================================================================="

# Iterate through all the files in the current directory
for file in *; do
    if [ -f "$file" ]; then
        # Get the file size
        size=$(stat -c%s "$file")
        
        # Get the file permissions
        permissions=$(stat -c%A "$file")
        
        # Get the file creation and modification times
        creation_time=$(stat -c%w "$file")
        modification_time=$(stat -c%y "$file")
        
        # Print the file information
        echo -e "$file\t\t\t$size\t\t$permissions\t\t$creation_time\t$modification_time"
    fi
done

