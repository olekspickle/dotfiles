#!/bin/bash


 
#     This example will 
# -ss 30            skip the first 30 seconds of the input
# -t 3              create a 3 second output
# fps=24            fps filter sets the frame rate
# scale=640:-1      scale filter will resize the output to 320 pixels wide and automatically determine the height while preserving the aspect ratio. The lanczos scaling algorithm is used in this example.
#     palettegen and paletteuse filters will generate and use a custom palette generated from your input. These filters have many options, so refer to the links for a list of all available options and values. Also see the Advanced options section below.
#     split filter will allow everything to be done in one command and avoids having to create a temporary PNG file of the palette.
#     Control looping with -loop output option but the values are confusing. A value of 0 is infinite looping, -1 is no looping, and 1 will loop once meaning it will play twice. So a value of 10 will cause the GIF to play 11 times.
#
# Advanced options
#
# The palettegen and paletteuse filters have many additional options. The most important are:
#
#     stats_mode (palettegen). You can force the filters to focus the palette on the general picture (full which is the default), only the moving parts (diff), or each individual frame (single). For example, to generate a palette for each individual frame use palettegen=stats_mode=single & paletteuse=new=1.
#
#     dither (paletteuse). Choose the dithering algorithm. There are three main types: deterministic (bayer), error diffusion (all the others including the default sierra2_4a), and none. Your GIF may look better using a particular dithering algorithm, or no dithering at all. If you want to try bayer be sure to test the bayer_scale option too.
out=${2:-"output.gif"}

# simple
ffmpeg -i "$1" -filter_complex "fps=24" -loop 0 "$out"

# resize
# ffmpeg -i "$1" -filter_complex "fps=24,scale=640:-1:flags=lanczos" -loop 0 "$out"
