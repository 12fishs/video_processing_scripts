#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Trims video and reencodes with youtube in mind, copying the audio stream. Outputs to a *_trimmed.mp4."
    echo "Usage: $0 <video> <start> <end>."
    echo "Time format: [HH:]MM:SS[.m...]"
    exit 1
fi

VID="$1"
START="$2"
END="$3"

VIDNAME="${VID%.*}"
OUTPUT="${VIDNAME}_trimmed.mp4"
#
# for deinterlacing use -vf bwdif=1
ffmpeg -i "$VID" -ss "$START" -to "$END" -c:v libx264 -preset veryslow -crf 18 -pix_fmt yuv420p \
  -c:a copy "$OUTPUT"
