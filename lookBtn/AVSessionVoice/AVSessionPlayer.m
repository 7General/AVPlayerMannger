//
//  AVSessionPlayer.m
//  playRecode
//
//  Created by 王会洲 on 16/6/16.
//  Copyright © 2016年 王会洲. All rights reserved.
//


#define RECOVERTIME 0.1

#import "AVSessionPlayer.h"
#import "VoiceJump.h"

#import "lame.h"

@interface AVSessionPlayer()
{
    //定时器
    NSTimer *timer;
    
    double lowPassResults;
    
}

@property (nonatomic, strong) VoiceJump * voiceView;
/**录音名字*/
@property (nonatomic, strong) NSString * playName;
@property (nonatomic, strong)  NSDictionary * recorderSettingsDict;
//图片组
@property (nonatomic, strong) NSMutableArray * volumImages;

@property (nonatomic, strong) NSString * mp3FilePath;

@end


@implementation AVSessionPlayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self readyImageAndIni];
        NSLog(@"===========================");
        
    }
    return self;
}

+ (instancetype)defaultManager {
    static AVSessionPlayer * s_defaultManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_defaultManager = [[AVSessionPlayer alloc] init];
    });
    return s_defaultManager;
}


/**播放语音 网络URL数据播放*/
- (void)playAudioWithURL:(NSString *)URL {
    NSError *error;
    NSString * str = URL;
    NSData * songData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:songData error:&error];
    self.audioPlayer.volume=1;
    if (error) {
        NSLog(@"error:%@",[error description]);
        return;
    }
    //准备播放
    [self.audioPlayer prepareToPlay];
    //播放
    [self.audioPlayer play];
    NSLog(@"----播放本地数据success");
}

/**播放语音 本地数据播放*/
- (void)playAudioWithContentsOfURL:(NSString *)urlName{
    NSError *playerError;
    //播放
    self.audioPlayer = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:self.playName] error:&playerError];
    self.audioPlayer.volume=10;
    if (self.audioPlayer == nil)
    {
        NSLog(@"ERror creating player: %@", [playerError description]);
        return;
    }else{
        
        //准备播放
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
        NSLog(@"----播放CAF-success");
    }
}


- (void)playAudioWithCafToMP3OfURL {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *mp3FileName = [docDir stringByAppendingString:@"/play.mp3"];
    
    
    [self deleteVoicRecord:mp3FileName];
    /**开始转换*/
    @try {
        int read, write;
        
        FILE *pcm = fopen ([self.playName cStringUsingEncoding : 1 ], "rb" );  //source 被 转换的音频文件位置
        
        if (pcm == NULL )
            
        {
            NSLog ( @"file not found" );
        }
        
        else
            
        {
            //skip file header
            fseek (pcm, 4 * 1024 , SEEK_CUR );
            FILE *mp3 = fopen ([mp3FileName cStringUsingEncoding : 1 ], "wb" );  //output 输出生成的 Mp3 文件位置
            const int PCM_SIZE = 8192 ;
            const int MP3_SIZE = 8192 ;
            short int pcm_buffer[PCM_SIZE* 2 ];
            unsigned char mp3_buffer[MP3_SIZE];
            lame_t lame = lame_init ();
            
            lame_set_num_channels (lame, 1 ); // 设置 1 为单通道，默认为 2 双通道
            
            lame_set_in_samplerate (lame, 8000.0 ); //11025.0
            //lame_set_VBR(lame, vbr_default);
            lame_set_brate (lame, 8 );
            lame_set_mode (lame, 3 );
            lame_set_quality (lame, 2 ); /* 2=high 5 = medium 7=low 音 质 */
            lame_init_params (lame);
            do {
                
                read = fread (pcm_buffer, 2 * sizeof ( short int ), PCM_SIZE, pcm);
                if (read == 0 )
                    write = lame_encode_flush (lame, mp3_buffer, MP3_SIZE);
                else
                    write = lame_encode_buffer_interleaved (lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                fwrite (mp3_buffer, write, 1 , mp3);
            } while (read != 0 );
            lame_close (lame);
            fclose (mp3);
            fclose (pcm);
        }
    }
    
    @catch (NSException *exception) {
        NSLog ( @"%@" ,[exception description ]);
    }
    
    @finally {
        NSLog(@"-----转换MP3成功！！！");
        self.mp3FilePath = mp3FileName;
        /**播放mMP3音乐*/
        [self playAudioWithContentsOfURL:self.mp3FilePath];
    }
}








/**播放状态*/
-(BOOL)playAudicState {
    return  self.audioPlayer.playing ? YES : NO;
}

/**开始播放*/
-(void)auidoPlay {
    [self.audioPlayer play];
}
/**停止播放*/
-(void)audioStop {
    [self.audioPlayer stop];
}



/**检查能够录音*/
-(BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                }
                else {
                    bCanRecord = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:nil
                                                    message:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
                                                   delegate:nil
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    }
    
    return bCanRecord;
}


/**初始化数据*/
-(void)readyImageAndIni {
    self.recodeTime = RECOVERTIME;
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        //7.0第一次运行会提示，是否允许使用麦克风
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        //AVAudioSessionCategoryPlayAndRecord用于录音和播放
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(session == nil)
            NSLog(@"Error creating session: %@", [sessionError description]);
        else
            [session setActive:YES error:nil];
    }
    
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.playName = [NSString stringWithFormat:@"%@/play.caf",docDir];
    //录音设置
    self.recorderSettingsDict =[[NSDictionary alloc] initWithObjectsAndKeys:
                                [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                                [NSNumber numberWithInt:8000.0],AVSampleRateKey,
                                [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
                                [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                           nil];
    //音量图片数组
    self.volumImages = [[NSMutableArray alloc]initWithObjects:@"RecordingSignal001",@"RecordingSignal002",@"RecordingSignal003",
                   @"RecordingSignal004", @"RecordingSignal005",@"RecordingSignal006",
                   @"RecordingSignal007",@"RecordingSignal008",   nil];

}

/**录音开始*/
-(void)recoderVoice {
    //按下录音
    if ([self canRecord]) {
        NSError *error = nil;
        //必须真机上测试,模拟器上可能会崩溃
        self.audioRecor = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:self.playName] settings:self.recorderSettingsDict error:&error];
        
        if (self.audioRecor) {
            self.voiceView = [[VoiceJump alloc] init];
            
            [AVCurrentWindow addSubview:self.voiceView];
            
            self.audioRecor.meteringEnabled = YES;
            [self.audioRecor prepareToRecord];
            [self.audioRecor record];
            
            //启动定时器
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(levelTimer:) userInfo:nil repeats:YES];
            
        } else
        {
            int errorCode = CFSwapInt32HostToBig ([error code]);
            NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
            
        }
    }
}

-(void)levelTimer:(NSTimer*)timer_
{
    
    self.recodeTime += RECOVERTIME;
    //call to refresh meter values刷新平均和峰值功率,此计数是以对数刻度计量的,-160表示完全安静，0表示最大输入值
    [self.audioRecor updateMeters];
    const double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (0.05 * [self.audioRecor peakPowerForChannel:0]));
    lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
    
    NSLog(@"Average input: %f Peak input: %f Low pass results: %f", [self.audioRecor averagePowerForChannel:0], [self.audioRecor peakPowerForChannel:0], lowPassResults);
    
    if (lowPassResults>=0.8) {
        self.voiceView.soundLodingImageView.image = [UIImage imageNamed:[self.volumImages objectAtIndex:7]];
    }else if(lowPassResults>=0.7){
        self.voiceView.soundLodingImageView.image = [UIImage imageNamed:[self.volumImages objectAtIndex:6]];
    }else if(lowPassResults>=0.6){
        self.voiceView.soundLodingImageView.image = [UIImage imageNamed:[self.volumImages objectAtIndex:5]];
    }else if(lowPassResults>=0.5){
        self.voiceView.soundLodingImageView.image = [UIImage imageNamed:[self.volumImages objectAtIndex:4]];
    }else if(lowPassResults>=0.4){
        self.voiceView.soundLodingImageView.image = [UIImage imageNamed:[self.volumImages objectAtIndex:3]];
    }else if(lowPassResults>=0.3){
        self.voiceView.soundLodingImageView.image = [UIImage imageNamed:[self.volumImages objectAtIndex:2]];
    }else if(lowPassResults>=0.2){
        self.voiceView.soundLodingImageView.image = [UIImage imageNamed:[self.volumImages objectAtIndex:1]];
    }else if(lowPassResults>=0.1){
        self.voiceView.soundLodingImageView.image = [UIImage imageNamed:[self.volumImages objectAtIndex:0]];
    }else{
        self.voiceView.soundLodingImageView.image = [UIImage imageNamed:[self.volumImages objectAtIndex:0]];
    }
}

/**录音完成*/
-(void)recoderVoiceEnd {
    //松开 结束录音
    //录音停止
    [self.audioRecor stop];
    self.audioRecor = nil;
    //结束定时器
    [timer invalidate];
    timer = nil;
    //图片重置
    self.voiceView.soundLodingImageView.image = [UIImage imageNamed:[self.volumImages objectAtIndex:0]];
    [self.voiceView removeFromSuperview];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AVSessionVoice:VoicePath:recoverTime:)]) {
        [self.delegate AVSessionVoice:self VoicePath:self.playName recoverTime:self.recodeTime];
    }
    self.recodeTime = RECOVERTIME;
}

/**删除录音文件*/
-(void)deleteVoicRecord:(NSString * )pathName {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if([fileManager removeItemAtPath:pathName error:nil])
    {
        NSLog(@"删除");
    }
}


@end
