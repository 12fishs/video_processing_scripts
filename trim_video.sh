#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Trims and encodes video with encoding options"
    echo "Usage: $0 <video> <start> <end>."
    echo "Options to set in script: cropping, lossless output, youtube output, or individual frames."
    echo "Time format: [HH:]MM:SS[.m...]"
    exit 1
fi

VID="$1"
START="$2"
END="$3"

VIDNAME="${VID%.*}"
OUTPUT="${VIDNAME}_trimmed.mov"

# for deinterlacing use -vf bwdif=1
ffmpeg -i "$VID" -ss "$START" -to "$END" \
  # CROPPING OPTION
  #-vf "crop=" \
  # NEAR-LOSSLESS OPTION
  -c:v prores_ks -profile:v 3 -pix_fmt yuv422p10le -r 24 \
  # YOUTUBE ENCODING - change container to mp4
  #-c:v libx264 -preset veryslow -crf 18 -pix_fmt yuv420p -r 24 \
  -c:a copy "$OUTPUT"
  # STRAIGHT TO PNG FRAMES OPTION
  #-vsync 0 "${VIDNAME}_frames/%06d.png"
