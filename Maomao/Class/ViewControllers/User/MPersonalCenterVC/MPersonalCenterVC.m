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

    signalLabel.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:kSignature]];
    
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
                      stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
    [Icon setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"common_userHeadImg.png"]];
    
    nameLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:NICKNAME];
   
    hud = [[MBProgressHUD alloc] init];
    [hud setLabelText:@"加载中，请稍等！"];
    [hud show:YES];
    [self.view addSubview:hud];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    NSString *url = [NSString stringWithFormat:@"%@/restful/personal/center?user_id=%@",MM_URL,userId];
    [self initWithRequestByUrl:url];
    
    /*********积分、经验值、等级、等级表述****NSInteger -> NSString**/
    /*注释掉的代码是因为credit = [[[NSUserDefaults standardUserDefaults] objectForKey:@"credit"] integerValue];无法获取这些数据 ，所以在本页面中我使用JSON来解析个人中心的数据加载*/
    /*
    NSInteger credit = 0;
    NSInteger reputation =0;
    NSInteger level = 0;
    NSString  *level_description = @"";
    NSString  *dd = @"";
    NSInteger aa = 1;
    credit = [[[NSUserDefaults standardUserDefaults] objectForKey:@"credit"] integerValue];
    creditLabel.text = [NSString stringWithFormat:@"%d",credit];
    NSLog(@"credit == %d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"credit"] integerValue]);
    
    reputation = [[[NSUserDefaults standardUserDefaults] stringForKey:@"reputation"] integerValue];
    reputationLable.text = [NSString stringWithFormat:@"%d",reputation];
    
    level =  [[[NSUserDefaults standardUserDefaults] stringForKey:@"level"] integerValue];
    levelLabel.text = [NSString stringWithFormat:@"%d",level];
    
    level_description = [[NSUserDefaults standardUserDefaults] stringForKey:@"level_description"];
    
    NSLog(@" level_description %@", level_description);
    
    aa =[level_description isEqualToString: dd];
    if (aa == 0) {
        level_descriptionLabel.text = @"还没等级";
        NSLog(@"level_description %@",level_descriptionLabel.text);
    }
    
    
    /********************邀约，礼物，传情，私信,我的收藏，我的活动count**************/
    /*
    NSInteger invitation = 0;
    NSInteger gift = 0;
    NSInteger greeting_count = 0;
    NSInteger collect_pub_count = 0;
    NSInteger collect_activity_count = 0;
    NSInteger private_count = 0;
    
    
    invitation = [[[NSUserDefaults standardUserDefaults] stringForKey:@"invitation"] integerValue];
    
    invitationLabel.text = [NSString stringWithFormat:@"%d",invitation];
    //personal_msg_notice.png
    if (invitation > 0) {
        [inviteNotice setImage:[UIImage imageNamed:@"personal_msg_notice.png"]];
    }
   
    
    gift = [[[NSUserDefaults standardUserDefaults] stringForKey:@"gift"] integerValue];
    giftLable.text = [NSString stringWithFormat:@"%d",gift];
    if (gift > 0) {
        [giftNotice setImage:[UIImage imageNamed:@"personal_msg_notice.png"]];
    }
    
    greeting_count = [[[NSUserDefaults standardUserDefaults] stringForKey: @"greeting_count"] integerValue];
    greeting_countLabel.text = [NSString stringWithFormat:@"%d",greeting_count];
    if (greeting_count > 0) {
        [teaserNotice setImage:[UIImage imageNamed:@"personal_msg_notice.png"]];
    }
    
    collect_pub_count = [[[NSUserDefaults standardUserDefaults] stringForKey:@"collect_pub_count"] integerValue];
    collect_pub_countLabel.text = [NSString stringWithFormat:@"%d", collect_pub_count];
 
    collect_activity_count = [[[NSUserDefaults standardUserDefaults] stringForKey:@"collect_activity_count"] integerValue];
    
    collect_activity_countLable.text = [NSString stringWithFormat:@"%d",collect_activity_count];
    
    private_count = [[[NSUserDefaults standardUserDefaults] stringForKey:@"private_letter_count"] integerValue];
    private_letter_countLable.text = [NSString stringWithFormat:@"%d",private_count];
    if (private_count > 0) {
        [privateMsgNotice setImage:[UIImage imageNamed:@"personal_msg_notice.png"]];
    }
    */
    
    if (!noiOS7) {
        for (UIView *view in self.view.subviews) {
            if (![view isEqual: topBar]) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
            }
            
        }
    }
}

#pragma mark -
#pragma mark  Send Request Method

- (void)initWithRequestByUrl:(NSString *)urlString;
{
    NSLog(@"urlString  ***** == %@",urlString);
    isNetWork = [Utils checkCurrentNetWork];
    
    if (!isNetWork) {
        if (prompting != nil) {
            [prompting removeFromSuperview];
            prompting = nil;
        }
        prompting = [[GPPrompting alloc] initWithView:self.view Text:@"网络链接中断" Icon:nil];
        [self.view addSubview:prompting];
        [prompting show];
        return;
    }
    
    if (self.sendRequest != nil) {
        [self.sendRequest clearDelegatesAndCancel];
        self.sendRequest = nil;
    }
    
    NSURL * url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.sendRequest = [ASIHTTPRequest requestWithURL:url];
    [self.sendRequest setTimeOutSeconds:kRequestTime];
    [self.sendRequest setDelegate:self];
    [self.sendRequest startAsynchronous];
}

#pragma mark - 
#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    if (response == nil || [response JSONValue] == nil) {
        return;
    }
    
    NSDictionary    *responseDict = [response JSONValue];
    NSDictionary *user = [responseDict objectForKey:@"user"];
    NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
    
    if (status == 0) {
        /*********积分、经验值、等级、等级表述****NSInteger -> NSString**/
        
         NSInteger credit = 0;
         NSInteger reputation =0;
            NSString  *level;
         NSString  *level_description = @"";
        
         credit = [[user objectForKey:@"credit"] integerValue];
         creditLabel.text = [NSString stringWithFormat:@"%d",credit];
         NSLog(@"credit == %d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"credit"] integerValue]);
         
         reputation = [[user objectForKey:@"reputation"] integerValue];
         reputationLable.text = [NSString stringWithFormat:@"%d",reputation];
         
        level =  [user objectForKey:@"level"];
         levelLabel.text = level;
         
         level_description = [user objectForKey:@"level_description"];
         
         NSLog(@" level_description %@", level_description);
         level_descriptionLabel.text = level_description;
                  
         
         /********************邀约，礼物，传情，私信,我的收藏，我的活动count**************/
        
         NSInteger invitation = 0;
         NSInteger gift = 0;
         NSInteger greeting_count = 0;
         NSInteger collect_pub_count = 0;
         NSInteger collect_activity_count = 0;
         NSInteger private_count = 0;
         
         
         invitation = [[user objectForKey:@"invitation"] integerValue];
         
         invitationLabel.text = [NSString stringWithFormat:@"%d",invitation];
         //personal_msg_notice.png
         if (invitation > 0) {
         [inviteNotice setImage:[UIImage imageNamed:@"personal_msg_notice.png"]];
         }
         
         
         gift = [[user objectForKey:@"gift"] integerValue];
         giftLable.text = [NSString stringWithFormat:@"%d",gift];
         if (gift > 0) {
         [giftNotice setImage:[UIImage imageNamed:@"personal_msg_notice.png"]];
         }
         
         greeting_count = [[user objectForKey: @"greeting_count"] integerValue];
         greeting_countLabel.text = [NSString stringWithFormat:@"%d",greeting_count];
         if (greeting_count > 0) {
         [teaserNotice setImage:[UIImage imageNamed:@"personal_msg_notice.png"]];
         }
         
         collect_pub_count = [[user objectForKey:@"collect_pub_count"] integerValue];
         collect_pub_countLabel.text = [NSString stringWithFormat:@"%d", collect_pub_count];
         
         collect_activity_count = [[user objectForKey:@"collect_activity_count"] integerValue] - 1;
         
         collect_activity_countLable.text = [NSString stringWithFormat:@"%d",collect_activity_count];
         
         private_count = [[user objectForKey:@"private_letter_count"] integerValue];
         private_letter_countLable.text = [NSString stringWithFormat:@"%d",private_count];
         if (private_count > 0) {
         [privateMsgNotice setImage:[UIImage imageNamed:@"personal_msg_notice.png"]];
         }
        

    }
     [hud hide:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [hud hide:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                       message:@"网络无法连接,请检查网络连接!"
                                                      delegate:self
                                             cancelButtonTitle:@"知道了"
                                             otherButtonTitles:nil];
    [alertView show];
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


@end
