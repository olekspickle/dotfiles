#!/bin/bash

# download and install youtube-dl
# UPD 04-03-2024: the official youtube-dl is unofficially dead and not works for the most of the time
# moreover if you try the following - you'll get error 451: Unavailable for legal reasons
# sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
# sudo chmod a+rx /usr/local/bin/youtube-dl
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o ~/.local/bin/yt-dlp
chmod a+rx ~/.local/bin/yt-dlp  # Make executable
