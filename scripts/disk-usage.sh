#!/bin/bash

# If no path is entered, use the current directory
path=${1:-.}
th=${2:-"500M"}

# Analyze the disk usage and sort by size
echo "Analyzing disk usage..."
du -h -d 1 --threshold=$th $path | sort -hr

