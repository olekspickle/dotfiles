#!/bin/bash

sudo apt install -y python3-dev

cd ~/.vim/plugged/YouCompleteMe 

./install.py --ts-completer --rust-completer
