//
//  MSettingView.m
//  Maomao
//
//  Created by  zhao on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MSettingView.h"
#import "SDImageCache.h"
#import "GPPrompting.h"

@implementation MSettingView
{
    GPPrompting *prompting;
}
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];

        //顶部条状
        UIImageView *topBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0+(noiOS7?0:20), 320, 44)];
        [topBar setImage:[UIImage imageNamed:@"common_topBar_blue.png"]];
        [topBar setUserInteractionEnabled:YES];
        [self addSubview:topBar];
        
        //顶部左边按钮
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setFrame:CGRectMake(14, 10, 30, 24)];
        [leftBtn setImage:[UIImage imageNamed:@"common_btn_left.png"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftSlider) forControlEvents:UIControlEventTouchUpInside];
        [topBar addSubview:leftBtn];
        
        UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 180, 44)];
        [titleName setTextColor:[UIColor whiteColor]];
        [titleName setText:@"设 置"];
        [titleName setFont:[UIFont boldSystemFontOfSize:20]];
        [titleName setBackgroundColor:[UIColor clearColor]];
        [titleName setTextAlignment:NSTextAlignmentCenter];
        [topBar addSubview:titleName];
    
        //设置一个Cell 44+15+37+40
        UIImageView *oneCellImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 44+15+(noiOS7?0:20), 290, 74/2)];
        [oneCellImg setImage:[UIImage imageNamed:@"setting_bg_oneCell.png"]];
        [oneCellImg setUserInteractionEnabled:YES];
        [self addSubview:oneCellImg];
        
        UIButton *pushAndAwake = [UIButton buttonWithType:UIButtonTypeCustom];
        [pushAndAwake setFrame:CGRectMake(0, 0, 290, 37)];
        [pushAndAwake setTag:11];
        [pushAndAwake addTarget:self action:@selector(gotoNextSetting:) forControlEvents:UIControlEventTouchUpInside];
        [oneCellImg addSubview:pushAndAwake];
        
        UILabel *firstName = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, 37)];
        [firstName setText:@"新消息提醒"];
        [firstName setTextColor:[UIColor colorWithRed:0.20 green:0.40 blue:0.47 alpha:1.0]];
        [firstName setFont:[UIFont systemFontOfSize:13]];
        [firstName setBackgroundColor:[UIColor clearColor]];
        [pushAndAwake addSubview:firstName];
        
        UIImageView *firstArrow = [[UIImageView alloc] initWithFrame:CGRectMake(262, 11, 10, 14)];
        [firstArrow setImage:[UIImage imageNamed:@"setting_img_greenArrow.png"]];
        [pushAndAwake addSubview:firstArrow];
        
        
        //设置四个Cell
        UIImageView *fourCellImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 44 +15+37+42+ (noiOS7?0:20), 290, 111+37)];
        [fourCellImg setImage:[UIImage imageNamed:@"setting_bg_fourCell.png"]];
        [fourCellImg setUserInteractionEnabled:YES];
        [self addSubview:fourCellImg];
        
        
        UIButton *soundAndShock = [UIButton buttonWithType:UIButtonTypeCustom];
        [soundAndShock setFrame:CGRectMake(0, 0, 290, 37)];
        [soundAndShock setTag:12];
        [soundAndShock addTarget:self action:@selector(clearChache) forControlEvents:UIControlEventTouchUpInside];
        [fourCellImg addSubview:soundAndShock];
        
        UILabel *secondName = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, 37)];
        [secondName setText:@"清除缓存"];
        [secondName setTextColor:[UIColor colorWithRed:0.20 green:0.40 blue:0.47 alpha:1.0]];
        [secondName setFont:[UIFont systemFontOfSize:13]];
        [secondName setBackgroundColor:[UIColor clearColor]];
        [soundAndShock addSubview:secondName];
        
        UIImageView *secondArrow = [[UIImageView alloc] initWithFrame:CGRectMake(262, 11, 10, 14)];
        [secondArrow setImage:[UIImage imageNamed:@"setting_img_greenArrow.png"]];
        [soundAndShock addSubview:secondArrow];

        
        UIButton *versionUpdate = [UIButton buttonWithType:UIButtonTypeCustom];
        [versionUpdate setFrame:CGRectMake(0, 0+37, 290, 37)];
        [versionUpdate setTag:13];
        [versionUpdate addTarget:self action:@selector(gotoNextSetting:) forControlEvents:UIControlEventTouchUpInside];
        [fourCellImg addSubview:versionUpdate];
        
        UILabel *thirdName = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, 37)];
        [thirdName setText:@"版本更新"];
        [thirdName setTextColor:[UIColor colorWithRed:0.20 green:0.40 blue:0.47 alpha:1.0]];
        [thirdName setFont:[UIFont systemFontOfSize:13]];
        [thirdName setBackgroundColor:[UIColor clearColor]];
        [versionUpdate addSubview:thirdName];
        
        UIImageView *thirdArrow = [[UIImageView alloc] initWithFrame:CGRectMake(262, 11, 10, 14)];
        [thirdArrow setImage:[UIImage imageNamed:@"setting_img_greenArrow.png"]];
        [versionUpdate addSubview:thirdArrow];
        
        UIButton *feedback = [UIButton buttonWithType:UIButtonTypeCustom];
        [feedback setFrame:CGRectMake(0, 37+37, 290, 37)];
        [feedback setTag:14];
        [feedback addTarget:self action:@selector(gotoNextSetting:) forControlEvents:UIControlEventTouchUpInside];
        [fourCellImg addSubview:feedback];
        
        UILabel *fourthName = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, 37)];
        [fourthName setText:@"意见反馈"];
        [fourthName setTextColor:[UIColor colorWithRed:0.20 green:0.40 blue:0.47 alpha:1.0]];
        [fourthName setFont:[UIFont systemFontOfSize:13]];
        [fourthName setBackgroundColor:[UIColor clearColor]];
        [feedback addSubview:fourthName];
        
        UIImageView *fourthArrow = [[UIImageView alloc] initWithFrame:CGRectMake(262, 11, 10, 14)];
        [fourthArrow setImage:[UIImage imageNamed:@"setting_img_greenArrow.png"]];
        [feedback addSubview:fourthArrow];
        
        UIButton *aboutMM = [UIButton buttonWithType:UIButtonTypeCustom];
        [aboutMM setFrame:CGRectMake(0, 74+37, 290, 37)];
        [aboutMM setTag:15];
        [aboutMM addTarget:self action:@selector(gotoNextSetting:) forControlEvents:UIControlEventTouchUpInside];
        [fourCellImg addSubview:aboutMM];
        
        UILabel *fifthName = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, 37)];
        [fifthName setText:@"关于冒冒"];
        [fifthName setTextColor:[UIColor colorWithRed:0.20 green:0.40 blue:0.47 alpha:1.0]];
        [fifthName setFont:[UIFont systemFontOfSize:13]];
        [fifthName setBackgroundColor:[UIColor clearColor]];
        [aboutMM addSubview:fifthName];
        
        UIImageView *fifthArrow = [[UIImageView alloc] initWithFrame:CGRectMake(262, 11, 10, 14)];
        [fifthArrow setImage:[UIImage imageNamed:@"setting_img_greenArrow.png"]];
        [aboutMM addSubview:fifthArrow];


        //设置退出按钮
        UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [exitBtn setFrame:CGRectMake(15, 340 + 44 + (noiOS7?0:20) + (iPhone5?88:0), 290, 48)];
        [exitBtn setBackgroundImage:[UIImage imageNamed:@"setting_btn_exit.png"] forState:UIControlStateNormal];
        [exitBtn setTag:16];
        [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [exitBtn setTitle:@"退出冒冒" forState:UIControlStateNormal];
        [exitBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [exitBtn addTarget:self action:@selector(gotoNextSetting:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:exitBtn];
    }
    return self;
}

- (void)leftSlider
{
    [delegate settingLeftSlider];
}

- (void)gotoNextSetting:(UIButton *)button
{
    [delegate gotoNextSetting:button.tag];
}

- (void)clearChache
{
    [[SDImageCache sharedImageCache] clearDisk];
    float tmpSize = [[SDImageCache sharedImageCache] getSize];
    NSString *clearCacheName = tmpSize >= 1? [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize]:[NSString stringWithFormat:@"清理缓存(%.2fk)",tmpSize*1024];
    
    prompting = [[GPPrompting alloc] initWithView:self Text:clearCacheName Icon:nil];
    [self addSubview:prompting];
    [prompting show];
    NSLog(@"缓存已清理");
}

@end
