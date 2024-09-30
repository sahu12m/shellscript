#!/bin/bash

# 1
echo "Current working directory:"
pwd
echo "==================================="

# 2. 
echo "List of files in current directory (detailed view):"
ls -l
echo "==================================="

# 3. 
echo "Navigating to /tmp directory"
cd /tmp
echo "Current directory after navigation:"
pwd
echo "=================================="

# 4. 
echo "Creating a new directory named 'panda'"
mkdir panda
echo "================================="

# 5. 
echo "Navigating to 'panda'"
cd   panda
echo "Current directory after navigation:"
pwd
echo "================================="

# 6. 
echo "Creating a new file named 'jk.txt' and write text" 
touch jk.txt
echo "Hello, This is mananmohan
      i from odisha
      i am Graduate
      i love to play cricket
      my favorite player is MS dhoni
      i love to cooking also
      i father is teacher
      i have one brother
      i love to golden retriever dog
      i am here to learn DevOps
      DevOps with AWS"> "jk.txt"
echo "=================================="

# 7. 
echo "Displaying the contents of 'jk.txt'"
cat jk.txt
echo "=================================="

# 8. 
echo "Copying 'jk.txt' to /tmp"
cp jk.txt /tmp
echo "================================"

# 9. 
echo "Moving 'jk.txt' to /tmp"
mv jk.txt /tmp
echo "=================================="

# 10.
echo "Deleting the copied file '/tmp/jk.txt'"
rm /tmp/jk.txt
echo "======================================"

# 11.
echo "System information:"
uname -a
echo "====================================="

# 12. 
echo "Disk usage:"
df -h
echo "===================================="

# 13.
echo "Memory usage:"
free -h
echo "===================================="

# 14. 
echo "Current running processes:"
ps aux
echo "====================================="

# 15. 
echo "Searching for 'DevOps' in '/tmp/myfile_moved.txt':"
grep "DevOps" /tmp/myfile_moved.txt
echo "====================================="

# 16. 
echo "Displaying the last 10 lines of '/tmp/myfile_moved.txt':"
tail -n 10 /tmp/myfile_moved.txt
echo "========================================"

# 17. 
echo "Exiting the script now!"
exit 
