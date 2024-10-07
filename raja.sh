#!/bin/bash

# Create a file with some sample text
echo "This is line one
ABC is in this line
This line doesn't have it
Another ABC line here
No match here
Yet another ABC entry" > raja.txt

# Display the content of the file (optional)
echo "Contents of the file 'raja.txt':"
cat raja.txt
echo

# Count the lines containing the word "ABC"
count=$(grep -c "ABC" raja.txt)

# Display the count
echo "Number of lines containing 'ABC': $count"

