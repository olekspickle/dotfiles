#!/bin/bash 

# rm unwanted big files from git history.
path=$1

function remove_files(){
    if [ -z "$1" ]
    then
        echo $1
        echo You need to specify path, like: 
        echo ./git-rm-files-from-history.sh output/pic.png
        echo Here is what you might want to delete:
        git rev-list --objects --all \
            | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
            | awk '/^blob/ {print substr($0,6)}' \
            | sort -r --numeric-sort --key=2 | head
        exit 1
    fi
    echo "Removing $1 from git history..."
    git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch pics/example.png'  --prune-empty --tag-name-filter cat -- --all
}

echo Note: this will make potentially disruptive changes, you might want to backup the repo before that.
read -p "Continue (y/n)?" choice
case "$choice" in 
    y|Y ) remove_files $1;;
    n|N ) 
        echo "Operation canceled"
        exit 1;;
    * ) echo "invalid";;
esac

