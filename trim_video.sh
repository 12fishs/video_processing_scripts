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

CROP_ON_ORIGINAL="crop=iw-156:ih-112:156:112"

LARGEST_16_9_CROP='crop=w=if(gt(iw/ih\,16/9)\,ih*16/9\,iw):h=if(gt(iw/ih\,16/9)\,ih\,iw*9/16):x=(iw-out_w)/2:y=(ih-out_h)/2'
SCALE_FILTER='scale=1920:1080:flags=lanczos' # upscaling filter



# for deinterlacing use -vf bwdif=1
ffmpeg -i "$VID" -ss "$START" -to "$END" \
  -vf "${CROP_ON_ORIGINAL},${LARGEST_16_9_CROP},${SCALE_FILTER}" \
  -c:v libx264 -preset veryfast -crf 18 -pix_fmt yuv420p -r 24 \
  -c:a copy "$OUTPUT"
  # NEAR-LOSSLESS OPTION
  #-c:v prores_ks -profile:v 3 -pix_fmt yuv422p10le -r 24 \
  # STRAIGHT TO PNG FRAMES OPTION
  #-vsync 0 "${VIDNAME}_frames/%06d.png"
  # YOUTUBE ENCODING - change container to mp4 in OUTPUT variable
  #-c:v libx264 -preset veryslow -crf 18 -pix_fmt yuv420p -r 24 -movflags +faststart \
  # FAST TESTING OPTION
  #-c:v libx264 -preset veryfast -crf 18 -pix_fmt yuv420p -r 24 \
