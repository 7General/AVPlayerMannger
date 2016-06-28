//
//  VoiceJump.m
//  playRecode
//
//  Created by 王会洲 on 16/6/16.
//  Copyright © 2016年 王会洲. All rights reserved.
//

#import "VoiceJump.h"

@implementation VoiceJump

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView {
    
    self.center = AVCurrentWindow.center;
    //CGPointMake(AVWidth * 0.5, AVHeight * 0.5);
    self.bounds = CGRectMake(0, 0, 160, 160);
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    self.soundLodingImageView = [[UIImageView alloc] init];
//    self.soundLodingImageView.backgroundColor = [UIColor redColor];
    self.soundLodingImageView.frame = CGRectMake(80 - 9, 80 - 30, 18, 60);
    [self addSubview:self.soundLodingImageView];
    
    
}
@end
