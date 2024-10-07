#!/bin/bash

# Create a file with some sample text
echo "This is line one
ABC is in this line
This line doesn't have it
Another ABC line here
No match here
Yet another ABC entry" > count.txt

# Display the content of the file 
echo "Contents of the file 'count.txt':"
cat count.txt
echo

# Count the lines containing the word "ABC"
count=$(grep -c "ABC" count.txt)

# Display the count
echo "Number of lines containing 'ABC': $count"

