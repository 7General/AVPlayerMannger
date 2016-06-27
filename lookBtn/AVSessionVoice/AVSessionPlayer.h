//
//  AVSessionPlayer.h
//  playRecode
//
//  Created by 王会洲 on 16/6/16.
//  Copyright © 2016年 王会洲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class AVSessionPlayer;

@protocol AVSessionPlayerDelegate <NSObject>

@optional
/**
 *  录音完成
 *
 *  @param AVPlayer  播放对象
 *  @param voicePath 录音文件路劲
 *  @param recoTime  录音文件计时
 */
-(void)AVSessionVoice:(AVSessionPlayer *)AVPlayer VoicePath:(NSString *)voicePath recoverTime:(float)recoTime;

@end


@interface AVSessionPlayer : NSObject

@property (nonatomic) float  recodeTime;

/**++录音器*/
@property (nonatomic, strong) AVAudioRecorder * audioRecor;
/**--播放器*/
@property (nonatomic, strong) AVAudioPlayer * audioPlayer;

+ (instancetype)defaultManager;
/**播放语音 网络URL数据播放*/
- (void)playAudioWithURL:(NSString *)URL;

/**播放语音 本地数据播放*/
- (void)playAudioWithContentsOfURL:(NSString *)urlName;

/**播放本地录音-把CAF格式转换成MP3格式*/
- (void)playAudioWithCafToMP3OfURL;




/**播放状态*/
-(BOOL)playAudicState;
/**检查能够录音*/
-(BOOL)canRecord;

/**录音开始*/
-(void)recoderVoice;
/**录音完成*/
-(void)recoderVoiceEnd;
/**删除录音文件*/
-(void)deleteVoicRecord:(NSString * )pathName;




/**开始播放*/
-(void)auidoPlay;
/**停止播放*/
-(void)audioStop;


@property (nonatomic, weak) id<AVSessionPlayerDelegate> delegate;
@end
