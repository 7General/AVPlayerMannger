//
//  MainViewController.m
//  lookBtn
//
//  Created by 王会洲 on 16/6/27.
//  Copyright © 2016年 王会洲. All rights reserved.
//

#define  SCREENWDITH [UIScreen mainScreen].bounds.size.width
#define  SCREENHEIGHT [UIScreen mainScreen].bounds.size.height


#import "MainViewController.h"
#import "MyTableCell.h"
#import "AVSessionPlayer.h"
#import "HZIndexPath.h"



@interface MainViewController ()<UITableViewCellDelegate,AVSessionPlayerDelegate>
@property (nonatomic, strong) UITableView * myTableView;
@property (nonatomic, strong) NSMutableArray * myTableData;

@property (nonatomic, assign) NSInteger  lastCurrentIndex;

@property (nonatomic, weak) UIButton * selectBtn;
@end

@implementation MainViewController

-(NSMutableArray *)myTableData {
    if (!_myTableData) {
        _myTableData = [NSMutableArray new];
        HZIndexPath * path1 = [HZIndexPath indexPathWithColumn:0 url:@"http://192.168.1.89:8080/Itaxer/1.mp3"];
        HZIndexPath * path2 = [HZIndexPath indexPathWithColumn:0 url:@"http://192.168.1.89:8080/Itaxer/2.mp3"];
        [_myTableData addObject:path1];
        [_myTableData addObject:path2];
        [_myTableView reloadData];
    }
    return _myTableData;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    /**设置播放器代理*/
    [AVSessionPlayer defaultManager].delegate = self;
    
    UIButton * recoridData = [UIButton buttonWithType:UIButtonTypeCustom];
    recoridData.frame = CGRectMake(0, SCREENHEIGHT - 50, SCREENWDITH, 50);
    [recoridData setTitle:@"长按录音" forState:UIControlStateNormal];
    [recoridData setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [recoridData setBackgroundColor:[UIColor lightTextColor]];
    [recoridData addTarget:self action:@selector(downVoice) forControlEvents:UIControlEventTouchDown];
    [recoridData addTarget:self action:@selector(endVoice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recoridData];
    
}
/**录音*/
-(void)downVoice {
    [[AVSessionPlayer defaultManager] recoderVoice];
}
/**录音结束*/
-(void)endVoice {
    [[AVSessionPlayer defaultManager] recoderVoiceEnd];
}

#pragma mark - 初始化视图
-(void)initView {
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    [self.view addSubview:self.myTableView];
}

#pragma mark -TABLEVIEW DELEGATE
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myTableData.count;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MyTableCell * cell = [MyTableCell cellWithTableView:tableView];
    cell.indexNumber = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellDate:self.myTableData[indexPath.row]];
    cell.delegate = self;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}





-(void)cell:(MyTableCell *)cell button:(UIButton *)btn withIndex:(NSInteger )indexNumber {
    
    BOOL playerStare = [AVSessionPlayer defaultManager].playAudicState;
    if (playerStare) {
        [[AVSessionPlayer defaultManager] audioStop];
        [self playVoice:btn withIndex:indexNumber];
    }else {
        [self playVoice:btn withIndex:indexNumber];
    }
    
    if (self.lastCurrentIndex != indexNumber) {
        [self.selectBtn setImage:[UIImage imageNamed:@"message_send_voice_play"] forState:UIControlStateNormal];
    }
    self.selectBtn = btn;
    self.lastCurrentIndex = indexNumber;
    
}

-(void)playVoice:(UIButton *)btn withIndex:(NSInteger)index {
    [btn setImage:[UIImage imageNamed:@"message_send_voice_stop"] forState:UIControlStateNormal];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        HZIndexPath * indexPath = self.myTableData[index];
        if (indexPath.row == 0) {
            /**播放网络音乐*/
           [[AVSessionPlayer defaultManager] playAudioWithURL:btn.titleLabel.text];
        }
        if (indexPath.row == 9) {
            /**MP3格式*/
            [[AVSessionPlayer defaultManager] playAudioWithCafToMP3OfURL];
        }
        if (indexPath.row == 10) {
            NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *cafFileName = [docDir stringByAppendingString:@"/play.caf"];
            [[AVSessionPlayer defaultManager] playAudioWithContentsOfURL:cafFileName];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [btn setImage:[UIImage imageNamed:@"message_send_voice_play"] forState:UIControlStateNormal];
                sleep(0.3);
            });
        });
    });
}

/**实现录音结束后的代理*/
-(void)AVSessionVoice:(AVSessionPlayer *)AVPlayer VoicePath:(NSString *)voicePath recoverTime:(float)recoTime {
    NSLog(@"录音时长%f",recoTime);
    //  9：代表MP3格式
    // 10：代表CAF格式
    //  0：代表网络音乐
    HZIndexPath * filePath = [HZIndexPath indexPathWithColumn:10 url:voicePath];
    [self.myTableData addObject:filePath];
    [self.myTableView reloadData];
}


@end
