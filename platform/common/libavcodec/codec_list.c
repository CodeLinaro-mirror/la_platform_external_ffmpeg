static const FFCodec * const codec_list[] = {
    &ff_gif_encoder,
    &ff_opus_encoder,
    &ff_libvpx_vp9_encoder,
    &ff_gif_decoder,
    &ff_h264_decoder,
    &ff_hevc_decoder,
#if CONFIG_MPEG4_DECODER
    &ff_mpeg4_decoder,
#endif
    &ff_opus_decoder,
    &ff_libvpx_vp9_decoder,
    NULL };
