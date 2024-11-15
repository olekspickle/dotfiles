#!bin/bash

# Image processing
# Black and White Filter:
ffmpeg -i input.jpg -vf "colorchannelmixer=.3:.4:.3:0:.3:.4:.3:0:.3:.4:.3" output.jpg

# Vintage Filter:
ffmpeg -i input.jpg -vf "curves=vintage" output.jpg

# High Contrast Filter:
ffmpeg -i input.jpg -vf "eq=contrast=1.5:brightness=0.1:saturation=2" output.jpg

# Sepia Filter:
ffmpeg -i input.jpg -vf "colorchannelmixer=.393:.769:.189:0:.349:.686:.168:0:.272:.534:.131" output.jpg

# Oil Painting Filter:
ffmpeg -i input.jpg -vf "paintoop=10:1:3" output.jpg

# Blur Filter:
ffmpeg -i input.jpg -vf "boxblur=10:5" output.jpg

# Grain Filter:
ffmpeg -i input.jpg -vf "noise=alls=20:allf=t+u" output.jpg

# Vignette Filter:
ffmpeg -i input.jpg -vf "vignette=enable='between(t,1,2)':x='if(lte(t,1),0,(W-w)/2)':y='if(lte(t,1),0,(H-h)/2)':r='if(lte(t,1),0.5*min(W,H),0.9*min(W,H))':m=0" output.jpg

# Negative
ffmpeg -i input.jpg -vf "negate" output.jpg

# drill holes on image
convert -size 20x20 xc:white -fill black -draw "circle 10,10 14,14" miff:- | composite -tile - input.png -compose over miff:- | composite - input.png -compose copyopacity output.png
