#!bin/bash

# Image processing
# drill holes on image
convert -size 20x20 xc:white -fill black -draw "circle 10,10 14,14" miff:- | composite -tile - input.png -compose over miff:- | composite - input.png -compose copyopacity output.png

# convert video to gif. r arg for compression (less - more compression)
ffmpeg -i my-sample.mkv -r 8 out.gif

# Generate a (compressed) pdf from images
convert -compress jpeg *.jpg mydoc.pdf

# Audio utils
# check meta info of an audio
ffmpeg -i 30-minute.mp3
ffprobe 30-minute.mp3

# Add metadata to a composition
# Note: pitput must be a different file
ffmpeg -i input.mp3 -c copy -metadata artist="Someone" output.mp3

# convert mp3 to WAV
ffmpeg -i 30-minute.mp3 -acodec pcm_u8 test.wav

# convert m4a to mp3
ffmpeg -i input.m4a -c:v copy -c:a libmp3lame -q:a 4 output.mp3

# create spectrogram of a WAV
sox test.wav -n spectrogram -Y 130 -c "Input file" -o test.png

# cut audio
ffmpeg -i stalkers3.mp3 -ss 00:40:01 -to 00:40:30 -c copy best/beat3.mp3

# concatenate audio
ffmpeg -i "concat:beat11.mp3|beat2.mp3|beat3.mp3" -acodec copy result2.mp3

# Video processing
# compress video gracefully using H.264 
ffmpeg -y -i ./in.mp4 -c:v libx264 -preset slow -tune animation -crf 22 output.mp4
# compress using H.265
ffmpeg -i input.mp4 -vcodec libx265 -crf 28 output.mp4

# Cropping a video file in ffmpeg
ffmpeg -i inputfile.avi -croptop 88 -cropbottom 88 -cropleft 360 -cropright 360 outputfile.avi

# Convert mkv to SVCD/DivX
ffmpeg -i movie.mkv -target vcd movie.avi
