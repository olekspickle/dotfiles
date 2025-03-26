#!bin/bash

# Audio utils
# -hide_banner just removes a huge verbose infodump enabled by default
# no idea why this is a default

# check meta info of an audio
ffmpeg -hide_banner -i in.mp3
ffprobe in.mp3

# Add metadata to a composition
# Note: output must be a different file
ffmpeg -i input.mp3 -c copy -metadata artist="Someone" output.mp3

# convert mp3 to WAV
ffmpeg -hide_banner -i in.mp3 -acodec pcm_u8 out.wav

# convert m4a to mp3
ffmpeg -i in.m4a -c:v copy -c:a libmp3lame -q:a 4 out.mp3

# create spectrogram of a WAV
sox in.wav -n spectrogram -Y 130 -c "Input file" -o out.png

# reverse audio
ffmpeg -hide_banner -i in.ogg -af areverse out.ogg

# change audio speed: slow down 2x
ffmpeg -hide_banner -i in.ogg -af "atempo=0.5" out.ogg
# video 2x speedup
ffmpeg -hide_banner -i in.mkv -vf "setpts=0.5*PTS" out.mkv

# cut audio
ffmpeg -hide_banner -i in.mp3 -ss 00:40:01.250 -to 00:40:30.700 -c copy out.mp3

# concatenate audio
ffmpeg -hide_banner -i "concat:in1.mp3|in2.mp3|in3.mp3" -acodec copy out.mp3

# replace audio for a video with an offset
# set offset for any of the inputs + or - sets it ahead or behind
# -itsoffset <+-00:00:00.000> -i <Input>
# map first(0) stream video to first(0) out, and second(1) audio stream to first(0)
# -map 0:v:0  -map 1:a:0
# -c:v copy copy video stream
ffmpeg -hide_banner -i oyaji.mp4 -itsoffset -00:00:00.500 -i oyaji.wav -c:v copy -map 0:v:0 -map 1:a:0 new.mp4
