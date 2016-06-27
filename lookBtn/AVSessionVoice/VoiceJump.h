//
//  VoiceJump.h
//  playRecode
//
//  Created by 王会洲 on 16/6/16.
//  Copyright © 2016年 王会洲. All rights reserved.
//
#define AVWidth [UIScreen mainScreen].bounds.size.width
#define AVHeight [UIScreen mainScreen].bounds.size.height
#define AVCurrentWindow ((UIView*)[UIApplication sharedApplication].keyWindow)
#import <UIKit/UIKit.h>

@interface VoiceJump : UIView
@property (nonatomic, strong)  UIImageView * soundLodingImageView;

@end
