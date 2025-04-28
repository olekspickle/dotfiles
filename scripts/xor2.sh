#!/bin/bash

# XOR two strings

xor() {
    key=$1
    length=${#key}
    while read -r -N1 byte
    do
        char=${key:$((i % length)):1}
        ((i++))
        echo $((byte ^ char))
    done
}


echo -n $1 |  xor $2

