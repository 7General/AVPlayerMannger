//
//  HZIndexPath.h
//  lookBtn
//
//  Created by 王会洲 on 16/6/27.
//  Copyright © 2016年 王会洲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZIndexPath : NSObject


@property (nonatomic, assign) NSInteger  row; // 行
@property (nonatomic, strong) NSString  * urlFilePath;

+(instancetype)indexPathWithColumn:(NSInteger)row url:(NSString *)urlFilePath;

@end




