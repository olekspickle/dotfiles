#!bin/bash

############### VIDEO processing ################

# -hide_banner just removes a huge verbose infodump enabled by default
# no idea why this is a default

# Black and White Filter:
ffmpeg -i in.jpg -vf "colorchannelmixer=.3:.4:.3:0:.3:.4:.3:0:.3:.4:.3" out.jpg

# Vintage Filter:
ffmpeg -i in.jpg -vf "curves=vintage" out.jpg

# High Contrast Filter:
ffmpeg -i in.jpg -vf "eq=contrast=1.5:brightness=0.1:saturation=2" out.jpg

# Sepia Filter:
ffmpeg -i in.jpg -vf "colorchannelmixer=.393:.769:.189:0:.349:.686:.168:0:.272:.534:.131" out.jpg

# Oil Painting Filter:
ffmpeg -i in.jpg -vf "paintoop=10:1:3" out.jpg

# Blur Filter:
ffmpeg -i in.jpg -vf "boxblur=10:5" out.jpg

# Grain Filter:
ffmpeg -i in.jpg -vf "noise=alls=20:allf=t+u" out.jpg

# Vignette Filter:
ffmpeg -i in.jpg -vf "vignette=enable='between(t,1,2)':x='if(lte(t,1),0,(W-w)/2)':y='if(lte(t,1),0,(H-h)/2)':r='if(lte(t,1),0.5*min(W,H),0.9*min(W,H))':m=0" out.jpg

# Negative
ffmpeg -i in.jpg -vf "negate" out.jpg

# drill holes on image
convert -size 20x20 xc:white -fill black -draw "circle 10,10 14,14" miff:- | composite -tile - in.png -compose over miff:- | composite - in.png -compose copyopacity out.png

# Compress image.
# q:v is the main metric 0 being the best quality and 31 being the most compressed one
ffmpeg -i in.jpg -q:v 3 out.jpg

# Resize the image
ffmpeg -i in.png -vf scale=300:300 out.png

# convert video to .gif, r arg for compression (less - more compression)
ffmpeg -i in.mkv -r 8 out.gif

# Generate a (compressed) PDF from images
convert -compress jpeg *.jpg out.pdf

# Video processing
# compress video gracefully using H.264
ffmpeg -i ./in.mp4 -c:v libx264 -preset slow -tune animation -crf 22 out.mp4

# compress using H.265
ffmpeg -i in.mp4 -vcodec libx265 -crf 28 out.mp4

# Cropping a video file in ffmpeg: number of pixels to offset from sides
ffmpeg -i in.avi -croptop 88 -cropbottom 88 -cropleft 360 -cropright 360 out.avi

# Cutting video with re-encode to have keyframes in sync(incredibly slow for big videos due to re-encode)
ffmpeg -ss 00:00:05 -i in.mp4 -t 00:00:18 -avoid_negative_ts make_zero -c:v libx264 -c:a aac out.mp4

# Convert mkv to SVCD/DivX
ffmpeg -i in.mkv -target vcd out.avi

# cut
ffmpeg -i in.mp3 -ss 00:40:01.250 -to 00:40:30.700 -c copy out.mp3

# mp4 to webp
ffmpeg -i in.mp4 -vcodec libwebp -filter:v fps=fps=20 -lossless 1 -loop 0 -preset default -an -vsync 0 -s 800:600 out.webp


############### AUDIO processing ################

# check meta info of an audio
ffmpeg -i in.mp3
ffprobe in.mp3

# Add metadata to a composition
# Note: output must be a different file
ffmpeg -i in.mp3 -c copy -metadata artist="Someone" out.mp3

# convert mp3 to WAV
ffmpeg -i in.mp3 -acodec pcm_u8 out.wav

# convert m4a to mp3
ffmpeg -i in.m4a -c:v copy -c:a libmp3lame -q:a 4 out.mp3

# create spectrogram of a WAV
sox in.wav -n spectrogram -Y 130 -c "Input file" -o out.png

# reverse audio
ffmpeg -i in.ogg -af areverse out.ogg

# change audio speed: slow down 2x
ffmpeg -i in.ogg -af "atempo=0.5" out.ogg
# video 2x speedup
ffmpeg -i in.mkv -vf "setpts=0.5*PTS" out.mkv

# concatenate audio
ffmpeg -i "concat:in1.mp3|in2.mp3|in3.mp3" -acodec copy out.mp3

# replace audio for a video with an offset
# set offset for any of the inputs + or - sets it ahead or behind
# -itsoffset <+-00:00:00.000> -i <Input>
# map first(0) stream video to first(0) out, and second(1) audio stream to first(0)
# -map 0:v:0  -map 1:a:0
# -c:v copy copy video stream
ffmpeg -i in_video.mp4 -itsoffset -00:00:00.500 -i in_audio.wav -c:v copy -map 0:v:0 -map 1:a:0 out.mp4
