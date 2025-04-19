#!/bin/bash 

# Top ten (or whatever) memory utilizing processes (with children aggregate) - Can be done without the multi-dimensional array
ps axo rss,comm,pid | awk '{ proc_list[$2] += $1; } END { for (proc in proc_list) { printf("%d\t%s\n", proc_list[proc],proc); }}' | sort -n | tail -n 10

# memory usage
ps -e -orss=,args= | sort -b -k1,1n | pr -TW$COLUMNS

# To find which host made maximum number of specific tcp connections
netstat -n | grep '^tcp.*<IP>:<PORT>' | tr " " | awk 'BEGIN{FS="( |:)"}{print $6}' | sort | uniq -c | sort -n -k1 | awk '{if ($1 >= 10){print $2}}'

# extract only ports in the netstat command output
# NR>2 - skips the first two lines of output (the headers)
# split($4,a,":") - splits the 4th field (the local address column) on the colon and stores the results in an array a.
# print a[2] - prints the 2nd element of the array a, which is the port number.
sudo netstat -tulpn | rg postgres | awk 'NR>2 { split($4,a,":"); print a[2] }'
