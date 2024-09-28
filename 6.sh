echo "Enter the directory path:"
read dir

if [ -d "$dir" ]; then
    echo "Directory exists. Listing contents:"
    ls "$dir"
else
    echo "Directory does not exist."
fi
