#! /bin/bash 

set -euo pipefail; shopt -s failglob # safe mode 

echo "Installing noise-cancellation plugin..."
./filter_voice.sh
