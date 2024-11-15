#!/bin/bash

# If no path is entered, use the current directory
path=${1:-.}
th=${2:-"500M"}

# Analyze the disk usage and sort by size
echo "Analyzing disk usage..."
du -h -d 1 --threshold=$th $path | sort -hr

# truncate all log files
# In general it's a bad thing to use rm on the log then recreating the filename, 
# if another process has the file open then you don't get the space back until that process closes it's handle on it
# and you can damage it's permissions in ways that are not immediately obvious but cause more problems later on.
truncate /opt/package/logs/*.log --size 0

# truncate one file safely
> /var/log/mail.log
