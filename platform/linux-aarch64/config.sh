MY_FLAGS="--extra-ldflags=\"-ldl\" \
  --disable-xlib \
  --enable-pic"

# Be very careful with changing the prebuilts:
#
# - Only enable muxers you need.
# - Only enable de-muxets you need
# - Only enable protocols that you need
# - Only enable coders you need
# - Only enable decoders you need
#
# Ffmpeg is basically a self contained enormous static library with all
# the filters, codec, protocols and (de)muxers you would ever need.
# Due to this you get *EVERYTHING* if you link against it, if you
# never use speex, or rtmp.
#
#  - webm: used by recording, we need to be able to read/write
#  - gif: animated gifs, used by recording
#  - matroska: used by recording, we need this for opening files we
#  created
#  - mov/mp4: used by offworld (automated testing)
#  wrote.
# - vorbis: audio codec for recording
# - gif: video codec used for recording
# - vp9: video coded used for recording
# - h264: encoder used by newer system images.
FLAGS="$MY_FLAGS \
  --enable-libx264 \
  --extra-cflags=-ffast-math \
  --enable-static \
  --disable-doc \
  --disable-programs \
  --enable-gpl \
  --disable-avdevice \
  --disable-filters \
  --enable-libvpx \
  --disable-muxers \
  --enable-muxer=gif \
  --enable-muxer=webm \
  --enable-muxer=webm_chunk_muxer \
  --enable-muxer=webm_dash_manifest_muxer \
  --disable-demuxers \
  --enable-demuxer=webm \
  --enable-demuxer=matroska \
  --enable-demuxer=webm_chunk_muxer \
  --enable-demuxer=mov \
  --enable-demuxer=webm_dash_manifest_muxer \
  --disable-protocols \
  --enable-protocol=file \
  --disable-encoders \
  --enable-encoder=gif \
  --enable-encoder=libvpx_vp9 \
  --enable-encoder=opus \
  --disable-decoders \
  --enable-decoder=gif \
  --enable-decoder=libvpx_vp9 \
  --enable-decoder=opus \
  --enable-decoder=hevc \
  --enable-decoder=h264
"

../ffmpeg/configure $FLAGS
