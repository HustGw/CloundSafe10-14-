#ifndef _GET_PACKET_H_
#define _GET_PACKET_H_

//#ifdef __cplusplus

//#endif	

#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavfilter/avfiltergraph.h>
#include <libavfilter/buffersink.h>
#include <libavfilter/buffersrc.h>
#include <libavutil/opt.h>
#include <libavutil/error.h>

//#ifdef __cplusplus

//#endif

int Init_ffmpegInterface(const char *);
int get_One_PacketInfo(AVPacket *packet);

#endif

