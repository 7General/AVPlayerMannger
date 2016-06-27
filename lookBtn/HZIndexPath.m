//
//  HZIndexPath.m
//  lookBtn
//
//  Created by 王会洲 on 16/6/27.
//  Copyright © 2016年 王会洲. All rights reserved.
//

#import "HZIndexPath.h"


@implementation HZIndexPath

-(instancetype)initWithColumn:(NSInteger)row url:(NSString *)urlFilePath {
    if (self == [super init]) {
        self.urlFilePath = urlFilePath;
        self.row = row;
    }
    return self;
}
/**
 *  添加构造器
 *
 *  @param column 列
 *  @param row    行
 *
 *  @return
 */
+(instancetype)indexPathWithColumn:(NSInteger)row url:(NSString *)urlFilePath {
    return [[self alloc] initWithColumn:row url:urlFilePath];
}

@end
