#! /bin/bash

# adb forward tcp:1234 tcp:1234

# create mirrored directory structure
find ./in -type d -exec mkdir -p out/{} \;

# convert files
find ./in -type f -exec bash -c '
ffmpeg -i "$0" -n -vn -ar 44100 -ac 2 -b:a 192k "./out/${0%.*}.m4a"

' {} \;
