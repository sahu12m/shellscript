#shell script that reads data from one file, converts the text to uppercase, and writes it to another file.

#!/bin/bash

input_file="input.txt"    
output_file="output.txt"  


if [ ! -f "$input_file" ]; then
  echo "Input file does not exist."
  exit 1
fi

while IFS= read -r line; do
  uppercase_line=$(echo "$line" | tr '[:lower:]' '[:upper:]')
  
  # Display the line in uppercase in the terminal
  echo "$uppercase_line"
  
  # Write the uppercase line to the output file
  echo "$uppercase_line" >> "$output_file"
done < "$input_file"

echo "Data has been converted to uppercase and saved to $output_file."

