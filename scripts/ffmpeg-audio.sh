#!bin/bash

# Audio utils

# check meta info of an audio
ffmpeg -i 30-minute.mp3
ffprobe 30-minute.mp3

# convert mp3 to WAV
ffmpeg -i 30-minute.mp3 -acodec pcm_u8 test.wav

# create spectrogram of a WAV
sox test.wav -n spectrogram -Y 130 -c "Input file" -o test.png

# cut audio
ffmpeg -i stalkers3.mp3 -ss 00:40:01.250 -to 00:40:30.700 -c copy best/beat3.mp3

# concatenate audio
ffmpeg -i "concat:beat11.mp3|beat2.mp3|beat3.mp3" -acodec copy result2.mp3

# replace audio for a video with an offset
# set offset for any of the inputs + or - sets it ahead or behind
# -itsoffset <+-00:00:00.000> -i <Input>
# map first(0) stream video to first(0) out, and second(1) audio stream to first(0)
# -map 0:v:0  -map 1:a:0
# -c:v copy copy video stream
ffmpeg -i oyaji.mp4 -itsoffset -00:00:00.500 -i oyaji.wav -c:v copy -map 0:v:0 -map 1:a:0 new.mp4
