#!/bin/bash

# find and replace "apt-get" with "apt" for all files in a directory
find /path/to/directory -type f -exec sed -i 's/apt-get/apt/g' {} +

# simple echo of IPv4 IP addresses assigned to a machine
ip addr | awk '/inet / {sub(/\/.*/, "", $2); print $2}'

# shorten url using curl, sed and is.gd
curl -s -d URL="$1" https://is.gd/create.php | sed '/Your new shortened/!d;s/.*value="\([^"]*\)".*/\1/'

# Gets the X11 Screen resolution
echo $(xrandr | grep '*' | sed 's/\s*\([0-9x]*\).*/\1/')

# remove all files with pattern in name recursively
# example for all pdfs
find -type f -name '*pdf' -print0 | xargs -0 rm

# find large files
find . -type f -size +1100000k |xargs -I% du -sh %

# Generate a quick, lengthy password
head /dev/urandom | md5sum | base64
# Create a random password encrypted with md5 with custom lenght
echo -n $n | md5sum | awk {'print $1'}

# Load functions from a current directory
SCRIPTPATH=$(readlink -f $(dirname $0))
. "$SCRIPTPATH/script.sh"

# Create a tar file with the current date in the name.
tar cfz backup-`date +%F`.tgz somedirs

# This is forcing user to enter password (once).
sudo true

# shell name
me=$(basename $0)

# Check if variable is a number
if [ "$testnum" -eq "$testnum" 2>/dev/null ]; then echo It is numeric

# Delete newline
tr -d "\n" < file1 > file2
# Delete leading whitespace from the start of each line
sed 's/^\s*//' input.txt

# extract json field
field=$(cat $(dirname $0)/some.json | jq -r '.top-object.sub-object.field')

# Probably, most frequent use of diff
diff -Naur --strip-trailing-cr
# Remove executable bit from all files in the current directory recursively, excluding other directories
find . ! -type d -exec chmod -x {}\;

# list all file extensions in a directory
find /path/to/dir -type f | grep -o '\.[^./]*$' | sort | uniq

# Delete Empty Directories
find . -type d -exec rmdir {} \;

# GRUB2: Set Imperial Death March as startup tune
echo 'GRUB_INIT_TUNE=\"480 440 4 440 4 440 4 349 3 523 1 440 4 349 3 523 1 440 8 659 4 659 4 659 4 698 3 523 1 415 4 349 3 523 1 440 8"\"' | sudo tee -a /etc/default/grub > /dev/null && sudo update-grub

# set prompt and terminal title to display hostname, user ID and pwd
export PS1='\[\e]0;\h \u \w\a\]\n\[\e[0;34m\]\u@\h \[\e[33m\]\w\[\e[0;32m\]\n\$ '

# Type strait into a file from the terminal.
cat /dev/tty > FILE

# most used unix commands
cut -d\    -f 1 ~/.bash_history | sort | uniq -c | sort -rn | head -n 10 | sed 's/.*/    &/g'

# Discspace utils
# see your physical disks
sudo lsblk --scsi

# list all partitions and block devices including boot, swap, efi etc.
df -Th

# disable backlight to preserve power as a cronjob
*/10 * * * * echo "0" > /sys/class/backlight/intel_backlight/brightness

# create bootable from terminal, sdX is your volume, check from lsblk
bzcat steamdeck-repair-20250521.10-3.7.7.img.bz2 | sudo dd if=/dev/stdin of=/dev/sdX oflag=sync status=progress bs=128M

# rename a FAT32 volume
sudo fatlabel /dev/sdXX "MA DISK"

# rename an ext4 volume
sudo e2label -L "MA DISK" /dev/sdX

# change LUKS key
sudo cryptsetup luksChangeKey /dev/sdX

# format USB stick to FAT32 volume
# (Optional but recommended) Wipe old signatures. This prevents weird mount issues.
sudo wipefs -a /dev/sdX
sudo parted /dev/sdX --script mklabel msdos
sudo parted /dev/sdX --script mkpart primary fat32 1MiB 100%
sudo mkfs.vfat -F 32 -n MA-USB-STEEK /dev/sdb1

# format USB windows compatible
umount /dev/sdX
sudo fdisk /dev/sdX
# Create a new (dos) partition table: press o and enter.
# Create a new partition: press n, enter and accept default options.
# Change the partition type to HPFS/NTFS/exFAT: press t, enter, 7, enter.
sudo mkfs.exfat -n "my label" /dev/sdX1

