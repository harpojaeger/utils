#! /bin/bash

INDIR="/home/harpo/Music/Swinsian/"
OUTDIR="/home/harpo/Music/m4a/"

# create mirrored directory structure
cd "$INDIR"
find . -type d -exec mkdir -p "$OUTDIR/{}" {} \;

# convert files to m4a, including ID3 tags
# (currently doesn't convert album art)
find . -type f -print0 | \
# sort files alphabetically (not necessary, but makes it easier to track progress
sort -zn | \
# execute the following bash script for each file
xargs -0 -I '{}' \
bash -c '
ffmpeg -i "$1$0" -n -vn -ar 44100 -ac 2 -b:a 192k "$2${0%.*}".m4a' \
"{}" "$INDIR" "$OUTDIR"

# Bind localhost:4242 to port 8022 on Android (termux sshd default)
# (https://glow.li/posts/access-termux-via-usb/)
adb forward tcp:4242 tcp:8022

# Sync music
#rsync -ravzhmp --delete-before --progress "$OUTDIR" mandroid_usb:/sdcard/Music/synced/
