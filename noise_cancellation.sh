#! /bin/bash 

set -euo pipefail; shopt -s failglob # safe mode 

# thx to this reddit post:
# https://www.reddit.com/r/linuxmasterrace/comments/g7mikg/rtx_voice_on_linux/

echo "Installing noise-cancellation plugin..."
./filter_voice.sh

echo "To install frontend to noise cancellation go to https://github.com/josh-richardson/cadmus/"
