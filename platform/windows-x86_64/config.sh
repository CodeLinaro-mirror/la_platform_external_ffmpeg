# FFmpeg configuration for Windows x86_64 (Clang-CL)
# This is a guestimate of sane defaults for the project.

FLAGS="--extra-ldflags="-ldl" 
  --disable-xlib 
  --enable-pic 
  --enable-libx264 
  --extra-cflags=-ffast-math 
  --enable-static 
  --disable-doc 
  --disable-programs 
  --enable-gpl 
  --disable-avdevice 
  --disable-filters 
  --enable-libvpx 
  --disable-muxers 
  --enable-muxer=gif 
  --enable-muxer=webm 
  --enable-muxer=webm_chunk_muxer 
  --enable-muxer=webm_dash_manifest_muxer 
  --disable-demuxers 
  --enable-demuxer=webm 
  --enable-demuxer=matroska 
  --enable-demuxer=webm_chunk_muxer 
  --enable-demuxer=mov 
  --enable-demuxer=webm_dash_manifest_muxer 
  --disable-protocols 
  --enable-protocol=file 
  --disable-encoders 
  --enable-encoder=gif 
  --enable-encoder=libvpx_vp9 
  --enable-encoder=opus 
  --disable-decoders 
  --enable-decoder=gif 
  --enable-decoder=libvpx_vp9 
  --enable-decoder=opus 
  --enable-decoder=hevc 
  --enable-decoder=h264 
  --toolchain=msvc 
  --arch=x86_64 
  --target-os=win64
"

# In a real build, we'd run:
# ./configure $FLAGS
