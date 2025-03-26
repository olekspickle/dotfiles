#!bin/bash

# Image processing
# Black and White Filter:
ffmpeg -hide_banner -i input.jpg -vf "colorchannelmixer=.3:.4:.3:0:.3:.4:.3:0:.3:.4:.3" output.jpg

# Vintage Filter:
ffmpeg -hide_banner -i input.jpg -vf "curves=vintage" output.jpg

# High Contrast Filter:
ffmpeg -hide_banner -i input.jpg -vf "eq=contrast=1.5:brightness=0.1:saturation=2" output.jpg

# Sepia Filter:
ffmpeg -hide_banner -i input.jpg -vf "colorchannelmixer=.393:.769:.189:0:.349:.686:.168:0:.272:.534:.131" output.jpg

# Oil Painting Filter:
ffmpeg -hide_banner -i input.jpg -vf "paintoop=10:1:3" output.jpg

# Blur Filter:
ffmpeg -hide_banner -i input.jpg -vf "boxblur=10:5" output.jpg

# Grain Filter:
ffmpeg -hide_banner -i input.jpg -vf "noise=alls=20:allf=t+u" output.jpg

# Vignette Filter:
ffmpeg -hide_banner -i input.jpg -vf "vignette=enable='between(t,1,2)':x='if(lte(t,1),0,(W-w)/2)':y='if(lte(t,1),0,(H-h)/2)':r='if(lte(t,1),0.5*min(W,H),0.9*min(W,H))':m=0" output.jpg

# Negative
ffmpeg -hide_banner -i input.jpg -vf "negate" output.jpg

# drill holes on image
convert -size 20x20 xc:white -fill black -draw "circle 10,10 14,14" miff:- | composite -tile - input.png -compose over miff:- | composite - input.png -compose copyopacity output.png

# Compress image.
# q:v is the main metric 0 being the best quality and 31 being the most compressed one
ffmpeg -hide_banner -i in.jpg -q:v 3 out.jpg

# Resize the image
ffmpeg -hide_banner -i in.png -vf scale=300:300 out.png

# convert video to .gif, r arg for compression (less - more compression)
ffmpeg -hide_banner -i in.mkv -r 8 out.gif

# Generate a (compressed) PDF from images
convert -compress jpeg *.jpg out.pdf

# Video processing
# compress video gracefully using H.264
ffmpeg -hide_banner -i ./in.mp4 -c:v libx264 -preset slow -tune animation -crf 22 out.mp4

# compress using H.265
ffmpeg -hide_banner -i in.mp4 -vcodec libx265 -crf 28 out.mp4

# Cropping a video file in ffmpeg: number of pixels to offset from sides
ffmpeg -hide_banner -i in.avi -croptop 88 -cropbottom 88 -cropleft 360 -cropright 360 out.avi

# Convert mkv to SVCD/DivX
ffmpeg -hide_banner -i in.mkv -target vcd out.avi
