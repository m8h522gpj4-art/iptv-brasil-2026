# Minimal Dockerfile for FFmpeg HLS packaging

FROM alpine:3.18

RUN apk add --no-cache ffmpeg bash curl

WORKDIR /work

COPY convert_to_hls.sh /work/convert_to_hls.sh
RUN chmod +x /work/convert_to_hls.sh

ENTRYPOINT ["/work/convert_to_hls.sh"]
