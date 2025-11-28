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

CROP_ON_ORIGINAL="crop=156:112"
LARGEST_16_9_CROP='crop=w=if(gt(iw/ih,16/9)\,trunc(ih*16/9/2)*2\,iw):h=if(gt(iw/ih,16/9)\,ih\,trunc(iw*9/16/2)*2):x=(iw-if(gt(iw/ih,16/9)\,trunc(ih*16/9/2)*2\,iw))/2:y=(ih-if(gt(iw/ih,16/9)\,ih\,trunc(iw*9/16/2)*2))/2'

SCALE_FILTER="scale=1920:1080:flags=oversample" # upscaling filter
FALLBACK="crop=1920:1080"

# for deinterlacing use -vf bwdif=1
ffmpeg -i "$VID" -ss "$START" -to "$END" \
  # CROPPING OPTION
  #-vf "${CROP_ON_ORIGINAL},${LARGEST_16_9_CROP},${SCALE_FILTER},${FALLBACK}" \
  # NEAR-LOSSLESS OPTION
  #-c:v prores_ks -profile:v 3 -pix_fmt yuv422p10le -r 24 \
  # QUICK CHECK OPTION
  -c:v libx264 -preset veryfast -crf 18 -pix_fmt yuv420p -r 24 \
  # YOUTUBE ENCODING - change container to mp4 in OUTPUT variable
  #-c:v libx264 -preset veryslow -crf 18 -pix_fmt yuv420p -r 24 -movflags +faststart \
  -c:a copy "$OUTPUT"
  # STRAIGHT TO PNG FRAMES OPTION
  #-vsync 0 "${VIDNAME}_frames/%06d.png"
