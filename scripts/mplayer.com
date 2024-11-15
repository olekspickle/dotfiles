#!/bin/bash 

# Instant mirror from your laptop + webcam (fullscreen+grab)
mplayer -fs -vf screenshot,mirror tv://
# Record camera's output to a avi file
mencoder -tv device=/dev/video1 tv:// -ovc copy -o video.avi
# Remove sound from video file using mencoder
mencoder -ovc copy -nosound input.avi -o output.avi
# Substitute audio track of video file using mencoder
mencoder -ovc copy -audiofile input.mp3 -oac copy input.avi -o output.avi
# Encode a file to MPEG4 format
mencoder video.avi lavc -lavcopts vcodec=mpeg4:vbitrate=800 newvideo.avi
# Download streaming video in mms
mimms  mms://Your_url.wmv
# Stream YouTube URL directly to mplayer.
mplayer -fs -cookies -cookies-file /tmp/cookie.txt $(youtube-dl -g --cookies /tmp/cookie.txt "http://www.youtube.com/watch?v=PTOSvEX-YeY")

