#!/bin/bash

file_count=$(ls -l | grep ^- | wc -l)

dir_count=$(ls -l | grep ^d | wc -l)

echo "Number of files: $file_count"
echo "Number of directories: $dir_count"
