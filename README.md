一，下载并在终端中运行脚本编译ffmpeg

脚本参考git上的：https://github.com/kewlbear/FFmpeg-iOS-build-script；

终端进入刚刚下载后的脚本文件夹下，运行sh：build－ffmpeg.sh 自动编译，有缺少yasm的按照提示操作，安装yasm

按照脚本编译完后的静态库目录如下：
![image](https://github.com/jiqiaochun/ffmpegTest/blob/master/image/lujing.jpeg)

其中的.a文件为静态库文件，include文件夹内的是头文件

二，将编译好的ffmpeg文件拖人工程，并设置相应的路径

新建工程，将编译好后包含include和lib文件夹拖进工程
![image](https://github.com/jiqiaochun/ffmpegTest/blob/master/image/ffmpeg-ios.jpeg)

到这里要修改工程的Header Search Paths ，要不然会报 

include“libavformat/avformat.h” file not found  错误

根据Library Search Paths 中的lib的路径：修改Header Search Paths 中，再将lib改为include
改好如下：
![image](https://github.com/jiqiaochun/ffmpegTest/blob/master/image/headersearch.jpeg)


三，导入其他库文件

其中libz.tbd libbz2.tbd libiconv.tbd 貌似是必须要导入的，其他的按照需求配置

个人配置好后的如下供参考：
![image](https://github.com/jiqiaochun/ffmpegTest/blob/master/image/link.jpeg)


四，将第三方代码导入工程

根据工程的定制化需求，这里选择了iFrameExtractor，git代码参考：https://github.com/lajos/iFrameExtractor 或者 RTSPPlayer    https://github.com/SutanKasturi/RTSPPlayer

我这里用的后者的demo里面的代码，直接将（AudioStreamer  RTSPPlayer  Utilities）六个文件拖入工程使用
![image](https://github.com/jiqiaochun/ffmpegTest/blob/master/image/FFMpegDecoder.png)


五，实现播放，实现方法可以参考demo中的代码

其中的self.playUrl为视频流的地址本工程用的是RTSP 数据流  示例：

self.playUrl = @"rtsp://xxx.xxx.xxx.xxx/xxx.sdp";

最后若遇到如下错误：
/Users/xxxx/Library/Developer/Xcode/DerivedData/ffmpeg Test-bmhrdaguuhstmweukzljerwnqabt/Build/Products/Debug-iphoneos/ffmpegTest.app/ffmpegTest normal arm64 (in target: ffmpegTest)
解决办法：
导入VideoToolbox.framework
错误2：
ignoring file /Users/qiaochunji/Downloads/ffmpegTest-master/FFmpeg-iOS/lib/libavdevice.a, file was built for unsupported file format ( 0x76 0x65 0x72 0x73 0x69 0x6F 0x6E 0x20 0x68 0x74 0x74 0x70 0x73 0x3A 0x2F 0x2F ) which is not the architecture being linked (arm64): /Users/qiaochunji/Downloads/ffmpegTest-master/FFmpeg-iOS/lib/libavdevice.a
解决办法：
编译脚本https://github.com/kewlbear/FFmpeg-iOS-build-script；生成的FFmpeg-iOS文件夹 替换工程中的FFmpeg-iOS文件夹。此原因是因为文件中libavdevice.a大于100M,上传github中设置忽略引起
![image](https://github.com/jiqiaochun/ffmpegTest/blob/master/image/headersearch.jpeg)的
![image](https://github.com/jiqiaochun/ffmpegTest/blob/master/image/headersearch.jpeg)
