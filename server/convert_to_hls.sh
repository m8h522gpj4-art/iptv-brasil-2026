#!/bin/sh

# Usage: docker run --rm -v $(pwd)/out:/out myimage "INPUT_URL"
INPUT="$1"
OUT_DIR="/out"

if [ -z "$INPUT" ]; then
  echo "Usage: $0 <input-url-or-file>"
  exit 1
fi

mkdir -p "$OUT_DIR"

# Simple FFmpeg command to create HLS (adjust codecs if needed)
ffmpeg -y -i "$INPUT" -c:v copy -c:a aac -hls_time 6 -hls_list_size 0 -hls_segment_filename "$OUT_DIR/segment_%03d.ts" "$OUT_DIR/playlist.m3u8"

echo "HLS output written to $OUT_DIR/playlist.m3u8"
