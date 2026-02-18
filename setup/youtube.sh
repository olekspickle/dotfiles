#!/bin/bash

# download and install youtube-dl
# UPD 04-03-2024: the official youtube-dl is unofficially dead and not works for the most of the time
# moreover if you try the following - you'll get error 451: Unavailable for legal reasons
# sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
# sudo chmod a+rx /usr/local/bin/youtube-dl
yt_path="/usr/local/bin/yt-dlp"
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o "$yt_path"
sudo chmod a+rx "$yt_path" # Make executable
