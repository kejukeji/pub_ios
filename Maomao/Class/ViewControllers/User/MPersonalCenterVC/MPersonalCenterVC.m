//
//  MPersonalCenterVC.m
//  Maomao
//
//  Created by maochengfang on 13-12-3.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MPersonalCenterVC.h"
#import "UIImageView+WebCache.h"
#import "MUserSettingVC.h"
#import "MIntegrationVC.h"
#import "Utils.h"
#import "JSON.h"

@implementation MPersonalCenterVC

@synthesize delegate;
@synthesize areaLabel;
@synthesize Icon;
@synthesize nameLabel;
@synthesize signalLabel;

@synthesize genderIcon;
@synthesize ageLabel;
/*********积分、经验值、等级、等级表述******/

@synthesize creditLabel;
@synthesize level_descriptionLabel;
@synthesize levelLabel;
@synthesize reputationLable;

/***********邀约，礼物，传情，私信,我的收藏，我的活动**********************/
@synthesize invitationLabel;
@synthesize giftLable;
@synthesize greeting_countLabel;
@synthesize private_letter_countLable;
@synthesize collect_activity_countLable;
@synthesize collect_pub_countLabel;

@synthesize inviteNotice;
@synthesize giftNotice;
@synthesize teaserNotice;
@synthesize privateMsgNotice;
/****************************************************/
@synthesize sendRequest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.89 alpha:1.0]];
    UIImageView *topBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0+(noiOS7?0:20), 320, 44)];
    [topBar setImage:[UIImage imageNamed:@"common_topBar_blue.png"]];
    [topBar setUserInteractionEnabled:YES];
    [self.view addSubview:topBar];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(14, 10, 30, 24)];
    [leftBtn setImage:[UIImage imageNamed:@"personal_choice_btn.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftSlider) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:leftBtn];
    
    UIButton *settingBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    [settingBtn setFrame:CGRectMake(287, 15, 20, 20)];
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"personal_setting_btn.png"] forState:UIControlStateNormal];
    [settingBtn setTag:20];
    [settingBtn addTarget:self action:@selector(gotoSettingUserInfo1:) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:settingBtn];
    
    ///////////////////////////////////////////////
    
    NSString *headImgPath = [[NSUserDefaults standardUserDefaults] stringForKey:kPic_path];
    NSString *path = [NSString stringWithFormat:@"%@%@",MM_URL, headImgPath];

    signalLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:kSignature];
    
    NSLog(@"signature = %@",signalLabel.text);
    
    /****************设置年龄******************/
    
    NSDate *current = [NSDate date];  //当前时间
    
    //格式化后台获取时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyy-MM-dd HH:mm:ss"];
    
    NSString *stringTime = [[NSUserDefaults standardUserDefaults] stringForKey:kBirthday];
    NSDate *birthday = [formatter dateFromString:stringTime];
    
    //计算年龄
    NSCalendar *systeCalendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComparisonComponents = [systeCalendar components:unitFlags fromDate:birthday toDate:current options:NSWrapCalendarComponents];
    
    ageLabel.text = [NSString stringWithFormat:@"%ld",(long)dateComparisonComponents.year];
    
    areaLabel.text = [[[NSUserDefaults standardUserDefaults] stringForKey:kCounty]
                      stringByReplacingOccurrencesOfString:@"$$" withString:@""];
    
    [Icon setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"common_userHeadImg.png"]];
    
    nameLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:NICKNAME];
   
    /*********积分、经验值、等级、等级表述************************/
    creditLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:kCredit];
    reputationLable.text = [[NSUserDefaults standardUserDefaults] stringForKey:kReputation];
    levelLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:kLevel];
    level_descriptionLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:kLevel_description];
    
    /*********邀约，礼物，传情，私信，收藏活动，收藏酒吧*************/
    
    NSInteger inviation, gift,greeting, collect_activity,collect_pub,private_letter;
    inviation = [[[NSUserDefaults standardUserDefaults] stringForKey:kInvitation ] integerValue];
    if (inviation > 0) {
        [inviteNotice setImage:[UIImage imageNamed:@"personal_msg_notice.png"]];
    }
    invitationLabel.text = [NSString stringWithFormat:@" %d",inviation];
    
    greeting = [[[NSUserDefaults standardUserDefaults] stringForKey:kGreeting_count] integerValue];
    if (greeting > 0) {
        [teaserNotice setImage:[UIImage imageNamed:@"personal_msg_notice.png"]];
    }
    
    greeting_countLabel.text = [NSString stringWithFormat:@"%d",greeting];
    
    private_letter = [[[NSUserDefaults standardUserDefaults] stringForKey:kPrivate_letter_count] integerValue];
    
    if (private_letter > 0) {
        [privateMsgNotice setImage:[UIImage imageNamed:@"personal_msg_notice.png"]];
    }
    private_letter_countLable.text = [NSString stringWithFormat:@"%d",private_letter];
    
    gift = [[[NSUserDefaults standardUserDefaults] stringForKey:kGift] integerValue];
    if (gift > 0) {
        [giftNotice setImage:[UIImage imageNamed:@"personal_msg_notice.png"]];
    }
    giftLable.text = [NSString stringWithFormat:@"%d",gift];
    
    collect_activity = [[[NSUserDefaults standardUserDefaults] stringForKey:kCollect_activity_count] integerValue];
    collect_activity_countLable.text = [NSString stringWithFormat:@"%d",collect_activity];
    
    collect_pub = [[[NSUserDefaults standardUserDefaults] stringForKey:kCollect_pub_count] integerValue];
    
    collect_pub_countLabel.text = [NSString stringWithFormat:@"%d",collect_pub];
    
   
    
    hud = [[MBProgressHUD alloc] init];
    [hud setLabelText:@"加载中，请稍等！"];
    [hud show:YES];
    //[self.view addSubview:hud];
    if (!noiOS7) {
        for (UIView *view in self.view.subviews) {
            if (![view isEqual: topBar]) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
            }
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)leftSlider
{
    [self.sendRequest clearDelegatesAndCancel];
    [delegate personalCenterLeftSlider];
}

- (void)gotoSettingUserInfo1:(UIButton *)sender
{
    [delegate mPersonalCenterGotoNext:sender.tag];
}


//该函数得满足：用户点击按钮的tag值来判断按钮上方的提示图标消失

- (IBAction)gotoNextVC:(UIButton *)sender
{
    if (sender.tag == 22) {
        [inviteNotice setImage:[UIImage imageNamed:@""]];
    }
    
    if (sender.tag == 23) {
        [giftNotice setImage:[UIImage imageNamed:@""]];
    }
    
    if (sender.tag == 24) {
        [teaserNotice setImage:[UIImage imageNamed:@""]];
    }
    
    if (sender.tag == 25) {
        [privateMsgNotice setImage:[UIImage imageNamed:@""]];
    }
    
    [delegate mPersonalCenterGotoNext:sender.tag];
    
    
}

- (IBAction)gotoCreditVC:(UIButton *)sender
{

    [delegate gotoCredictVC:creditLabel.text getValue2:reputationLable.text];
}


@end
