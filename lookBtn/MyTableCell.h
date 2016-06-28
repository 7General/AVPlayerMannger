//
//  MyTableCell.h
//  lookBtn
//
//  Created by 王会洲 on 16/6/27.
//  Copyright © 2016年 王会洲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZIndexPath.h"


@class MyTableCell;

@protocol UITableViewCellDelegate <NSObject>

@optional
/**
 *  点击播放语音
 *
 *  @param cell        cell
 *  @param btn         点击的按钮
 *  @param indexNumber 索引行号
 */
-(void)cell:(MyTableCell *)cell button:(UIButton *)btn withIndex:(NSInteger )indexNumber;

@end


@interface MyTableCell : UITableViewCell
/**缩影行号*/
@property (nonatomic, assign) NSInteger  indexNumber;


@property (nonatomic, weak) UIButton * playBtn;


+(instancetype)cellWithTableView:(UITableView *)tableview;

-(void)setCellDate:(HZIndexPath *)dataArry;


@property (nonatomic, weak) id<UITableViewCellDelegate> delegate;
@end
