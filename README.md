# AVPlayerSessionMannger
AVPlayer-录音，播放，录制的CAF格式转换成MP3格式播放，网络音乐播放，本地音乐播放，共3种情况


github下载地址:https://github.com/7General/AVPlayerMannger
最近在做聊天程序。单位没有采用已经封装好的第三方通讯。而是自己采用，自己写。发送文字、语音、图片这三个情况。


于是乎在搞语音播放的时候相当费劲了。搞了又搞之后，封装了一个播放语音的单利类。

我们在录音的时候都是UIButton按下的时候开始录音，松开就是表示录音完成可以进行下一步操作、可以发送到服务器、也可以保存到本地等待做处理


###1：常用函数功能

 ######当按钮【按下】的时候开始录音
```objc
/**录音开始*/
-(void)recoderVoice;
```
######当按钮【松开】的时候录音完成
```objc
/**录音完成*/
-(void)recoderVoiceEnd;
```

######录音结束之后，要执行代理函数进行做后续处理
```objc
/**
 *  录音完成todo...
 *
 *  @param AVPlayer  播放对象
 *  @param voicePath 录音文件路劲
 *  @param recoTime  录音文件计时
 */
-(void)AVSessionVoice:(AVSessionPlayer *)AVPlayer VoicePath:(NSString *)voicePath recoverTime:(float)recoTime;
```

###2：播放不同的url地址

######网络URL数据播放
```objc
/**播放语音 网络URL数据播放*/
- (void)playAudioWithURL:(NSString *)URL;
```
######本地数据播放
```objc
/**播放语音 网络URL数据播放*/
- (void)playAudioWithURL:(NSString *)URL;
```
######把本地录制的CAF格式数据转换成MP3格式播放
```objc
/**播放本地录音-把CAF格式转换成MP3格式*/
- (void)playAudioWithCafToMP3OfURL;
```

######3：检测播放状态
```objc
/**播放状态*/
-(BOOL)playAudicState;
```

######4：控制播放和暂停
```objc
/**开始播放*/
-(void)auidoPlay;
/**停止播放*/
-(void)audioStop;
```


## 更多消息
 更多信iOS开发信息 请以关注洲洲哥 的微信公众号，不定期有干货推送：
 
 ![这里写图片描述](http://upload-images.jianshu.io/upload_images/1416781-0f0cc08cfd424a54?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
