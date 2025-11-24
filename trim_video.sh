#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: $0 <video> <start> <end>. Time format: [HH:]MM:SS[.m...]."
    exit 1
fi

VID="$1"
START="$2"
END="$3"

# for deinterlacing use -vf bwdif=1
ffmpeg -i "$VID" # -vf bwdif=1 deinterlacing apprently important??
