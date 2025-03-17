#!bin/bash

# Audio utils

# check meta info of an audio
ffmpeg -i in.mp3
ffprobe in.mp3

# convert mp3 to WAV
ffmpeg -i in.mp3 -acodec pcm_u8 out.wav

# create spectrogram of a WAV
sox in.wav -n spectrogram -Y 130 -c "Input file" -o out.png

# reverse audio
ffmpeg -i in.ogg -af areverse out.ogg

# change audio speed: slow down 2x
ffmpeg -i in.ogg -af "atempo=0.5" out.ogg
# video 2x speedup
ffmpeg -i in.mkv -vf "setpts=0.5*PTS" out.mkv

# cut audio
ffmpeg -i in.mp3 -ss 00:40:01.250 -to 00:40:30.700 -c copy out.mp3

# concatenate audio
ffmpeg -i "concat:beat11.mp3|beat2.mp3|beat3.mp3" -acodec copy result2.mp3

# replace audio for a video with an offset
# set offset for any of the inputs + or - sets it ahead or behind
# -itsoffset <+-00:00:00.000> -i <Input>
# map first(0) stream video to first(0) out, and second(1) audio stream to first(0)
# -map 0:v:0  -map 1:a:0
# -c:v copy copy video stream
ffmpeg -i oyaji.mp4 -itsoffset -00:00:00.500 -i oyaji.wav -c:v copy -map 0:v:0 -map 1:a:0 new.mp4
