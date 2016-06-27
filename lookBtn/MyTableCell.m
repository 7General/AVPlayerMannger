//
//  MyTableCell.m
//  lookBtn
//
//  Created by 王会洲 on 16/6/27.
//  Copyright © 2016年 王会洲. All rights reserved.
//

#import "MyTableCell.h"

@implementation MyTableCell

+(instancetype)cellWithTableView:(UITableView *)tableview {
   static NSString * ID = @"cell";
    MyTableCell * cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MyTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

-(void)initView {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 10, 350, 30);
    btn.backgroundColor = [UIColor blueColor];
    [btn setImage:[UIImage imageNamed:@"message_send_voice_play"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    self.playBtn = btn;
}

-(void)setIndexNumber:(NSInteger)indexNumber {
    _indexNumber = indexNumber;
}


-(void)setCellDate:(HZIndexPath *)dataArry {
    [self.playBtn setTitle:dataArry.urlFilePath forState:UIControlStateNormal];
}


-(void)playAction:(UIButton *)sender {
    NSLog(@"------paly");
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:button:withIndex:)]) {
        [self.delegate cell:self button:sender withIndex:self.indexNumber];
    }
}
@end
