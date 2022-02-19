#! /bin/bash

INDIR="/home/harpo/Music/Swinsian/"
OUTDIR="/home/harpo/Music/m4a/"

# create mirrored directory structure
cd "$INDIR"
find . -type d -exec mkdir -p "$OUTDIR/{}" {} \;

# remove all empty files from OUTDIR. Previous failed runs of ffmpeg might have
# left these here, and the below ffmpeg command will then skip trying to
# transcode them again
find "$OUTDIR" -size 0b -exec rm {} \;

# convert files to m4a, including ID3 tags
# (currently doesn't convert album art)
find . -type f -print0 | \
# sort files alphabetically (not necessary, but makes it easier to track progress
sort -zn | \
# execute the following bash script for each file
xargs -0 -I '{}' \
bash -c '
ffmpeg -i "$1$0" -map 0:a:0 -n -v error -stats -ar 44100 -ac 2 -b:a 192k "$2${0%.*}".m4a && echo "Processed ${0%.*}"
' \
"{}" "$INDIR" "$OUTDIR"

# Bind localhost:4242 to port 8022 on Android (termux sshd default)
# (https://glow.li/posts/access-termux-via-usb/)
adb forward tcp:4242 tcp:8022

# Sync music
rsync -ravzhmp --delete-before --progress "$OUTDIR" mandroid_usb:/sdcard/Music/synced/
