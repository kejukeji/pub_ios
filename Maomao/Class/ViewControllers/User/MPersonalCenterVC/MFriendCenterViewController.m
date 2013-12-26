//
//  MFriendCenterViewController.m
//  Maomao
//
//  Created by maochengfang on 13-12-5.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MFriendCenterViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "JSON.h"
#import "Utils.h"
#import "MMyCollectVC.h"
#import "MChatListVC.h"
#import "GPPrompting.h"
//二期页面
#import "MHaveDrinkView.h"
#import "MSendGiftViewController.h"

@interface MFriendCenterViewController ()
{
    MBProgressHUD *hud;
    DropDownControllView *mDropDownView;
    int count;//点击更多按钮 计数
    NSInteger      receiver_id;
}
@property (nonatomic, copy) NSString *friendName;
@end

@implementation MFriendCenterViewController

@synthesize delegate;
@synthesize friendAgeLabel;
@synthesize friendLocationLabel;
@synthesize creditLabel; //积分
@synthesize friendAreaLabel;
@synthesize genderLabel;
@synthesize numofGift;
@synthesize friendScrollView;
@synthesize reputationLabel;//经验值
@synthesize friendNameLabel;
@synthesize friendSignLabel;
@synthesize friendId;
@synthesize formDataReuqest;
@synthesize friendIcon;
@synthesize sendGreetingRequest;
@synthesize friendName;

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
//    UIImageView *topBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0+(noiOS7?0:20), 320, 44)];
//    [topBar setImage:[UIImage imageNamed:@"common_barBg_top.png"]];
//    [topBar setUserInteractionEnabled:YES];
//    [self.view addSubview:topBar];

    count = 0; //计数为零
    UIButton   *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(14, 10, 30, 24)];
    [leftBtn setImage:[UIImage imageNamed:@"personal_choice_btn.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setFrame:CGRectMake(287, 0, 20, 30)];
    
    [moreBtn setImage:[UIImage imageNamed:@"  friendCenter_right_btn.png"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    
    
    
    if (!noiOS7) {
        for (UIView *view in self.view.subviews) {
            //if (![view isEqual: topBar]) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
            //}
            
        }
    }
    
    hud = [[MBProgressHUD alloc] init];
    [hud setLabelText:@"加载中请稍后!"];
    [hud show:YES];
    [self.view addSubview:hud];
    
    

}

- (void)back
{
    [self.formDataReuqest clearDelegatesAndCancel];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self friendInfo];
    
}

- (void)friendInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/restful/user/user_info/%@",MM_URL,friendId];
    NSLog(@"urlString == %@",urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    formDataReuqest = [ASIFormDataRequest requestWithURL:url];
    [formDataReuqest setDelegate:self];
    [formDataReuqest setTimeOutSeconds:kRequestTime];
    [formDataReuqest setDidFailSelector:@selector(requestDidFailed:)];
    [formDataReuqest setDidFinishSelector:@selector(requestDidSuccess:)];
    [formDataReuqest setRequestMethod:@"POST"];

    [formDataReuqest startSynchronous];
    
}

- (void)requestDidFailed:(ASIFormDataRequest *)request
{
    [hud hide:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络无法连接，请检查网络" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alertView show];
}

- (void)requestDidSuccess:(ASIFormDataRequest *)request
{
    
    [hud hide:YES];
    
    NSLog(@"code:%d",[request responseStatusCode]);
    NSString *responseString = [request responseString];
    if (responseString == nil || [responseString JSONValue] == nil) {
        return;
    }
    NSDictionary *responseDict = [responseString JSONValue];
    NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
    NSLog(@"status ==%d",status);
    if (status ==0) {
        NSDictionary *userDict = [responseDict objectForKey:@"user"];
        
        receiver_id = [[userDict objectForKey:@"id"] integerValue];
        NSLog(@"receiver_id == %d",receiver_id);
        
        NSString *nickName = [userDict objectForKey:@"nick_name"];
        NSString *loginName = [userDict objectForKey:LOGINNAME];
        NSString *loginType = [userDict objectForKey:LOGIN_TYPE];
        
        NSDictionary *userInfo = [responseDict objectForKey:@"user_info"];
        NSString *tel = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"tel"]];
        NSString *city_id = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"city_id"]];
        NSString *sex = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"sex"]];
        NSString *county = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"county"]];
        NSString *street = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"street"]];
        NSString *county_id = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"county_id"]];
        NSString *ethnicity_id = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"ethnicity_id"]];
        NSString *upload_name = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"upload_name"]];
        NSString *email = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"email"]];
        NSString *company = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"company"]];
        NSString *base_path = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"base_path"]];
        NSString *job = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"job"]];
        NSString *birthday = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"birthday"]];
        NSString *rel_path = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"rel_path"]];
        NSString *province_id = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"province_id"]];
        NSString *pic_path = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"pic_path"]];
        NSString *birthday_type = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"birthday_type"]];
        NSString *mobile = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"mobile"]];
        NSString *real_name = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"real_name"]];
        NSString *intro = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"intro"]];
        NSString *signature = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"signature"]];
        NSString *pic_name = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"pic_name"]];
        /*****************二期增加的内容*********************************/
        NSInteger credit = [[userInfo objectForKey:@"credit"] integerValue];
        NSInteger reputation =[[userInfo objectForKey:@"reputation"] integerValue];
        /**************************************************************/
        
        creditLabel.text = [NSString stringWithFormat:@"%d",credit];
        reputationLabel.text = [NSString stringWithFormat:@"%d",reputation];
        /****************设置年龄******************/
        
        NSDate *current = [NSDate date];  //当前时间
        //格式化后台获取时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat : @"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *birthdayDate = [formatter dateFromString:birthday];
        
        //计算年龄
        NSCalendar *systeCalendar = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDateComponents *dateComparisonComponents = [systeCalendar components:unitFlags fromDate:birthdayDate toDate:current options:NSWrapCalendarComponents];
        friendAgeLabel.text = [NSString stringWithFormat:@"%d",dateComparisonComponents.year];
        friendAreaLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:kCounty];
        NSString *path = [NSString stringWithFormat:@"%@%@",MM_URL,pic_path];
        [friendIcon setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"common_userHeadImg.png"]];
        friendName = nickName;
        friendNameLabel.text = friendName;
        NSLog(@"friendNameLabel.text==%@",friendNameLabel.text);
        friendSignLabel.text = signature;
        
        //计算距离
        
        
        
    }
    else if (status == 1) {
        NSString *message = [responseDict objectForKey:@"message"];
        UIAlertView *OK = [[UIAlertView alloc] initWithTitle:@"重要提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [OK show];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftSlider
{
    [delegate friendCenterLeftSlider];
}

- (void)moreList
{
   
    //下拉菜单
    mDropDownView = [[DropDownControllView alloc] initWithFrame:CGRectMake(240, 60, 100, 30)];
    [mDropDownView setBackgroundColor:[UIColor clearColor]];
    mDropDownView.delegate = self;
    //下拉选项
    NSMutableArray      *titles = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray      *options = [NSMutableArray arrayWithCapacity:0];
    
    for (int i =0; i <3 ; i++) {
        [options addObject:[NSNumber numberWithInt: i]];
    }
    mDropDownView.title = @"";
    [titles addObject:@"屏蔽该好友"];
    [titles addObject:@"举报检举"];
    [titles addObject:@"取消"];
    [mDropDownView setSelectionOptions:options withTitles:titles];
    count ++;
    [self.view addSubview:mDropDownView];
    NSLog(@"屏蔽该好友，举报检举，取消");
}

#pragma mark - Drop Drown Selector Delegate
- (void)dropDownControlView:(DropDownControllView *)view didFinishWithSelection:(id)selection
{
    NSString *selectId = [NSString stringWithFormat:@"%@",selection];
    if ([selectId isEqualToString:@"0"]) {
        NSLog(@"屏蔽该好友");
    }
    else if([selectId isEqualToString:@"1"])
    {
        NSLog(@"举报检举");
    }
    else
    {
        NSLog(@"取消");
    }
}

- (IBAction)gotoClink:(UIButton *)sender//喝一杯
{
    NSLog(@"goto Clink.");
    MHaveDrinkView  *haveDrinkView = [[MHaveDrinkView alloc] init];
    
    //传递接口中receiver_id;
    haveDrinkView.receiver_id = receiver_id;
    
    [self.navigationController pushViewController:haveDrinkView animated:YES];
    
}

- (IBAction)haveTeaser:(UIButton *)sender //眉眼传情
{
    
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    //http://42.121.108.142:6001/restful/sender/gift?sender_id=1&receiver_id=3
    NSString *url = [NSString stringWithFormat:@"%@/restful/sender/invite?sender_id=%@&receiver_id=%d",MM_URL,userid,receiver_id];
    [self sendGreetingRequest:url];
    
    NSLog(@" have Teaser.");
    
    
}

-  (void)sendGreetingRequest:(NSString *)urlString
{
    NSLog(@"urlString  ****** == %@",urlString);
    isNetWork  = [Utils checkCurrentNetWork];
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
    
    if (self.sendGreetingRequest != nil) {
        [self.sendGreetingRequest clearDelegatesAndCancel];
        self.sendGreetingRequest = nil;
    }
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    sendGreetingRequest = [ASIHTTPRequest requestWithURL:url];
    [sendGreetingRequest setTimeOutSeconds:kRequestTime];
    [sendGreetingRequest setDelegate:self];
    [sendGreetingRequest startAsynchronous];
    
}

- (IBAction)sendGift:(UIButton *)sender
{
    //待实现
    NSLog(@"send gift");
    MSendGiftViewController *sendGiftVC = [[MSendGiftViewController  alloc] init];
    
    sendGiftVC.receiverID = [NSString stringWithFormat:@"%d",receiver_id];
    
    NSString *url = @"http://42.121.108.142:6001/restful/sender/gift/view";
    
    [sendGiftVC initWithRequestByUrl:url];
    
    [self.navigationController pushViewController:sendGiftVC animated:YES];
    
    
}

#pragma mak - 
#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    
    if (response == nil  || [response JSONValue] == nil) {
        return;
    }
    NSDictionary *responseDict = [response JSONValue];
    NSString *msg = [responseDict objectForKey:@"message"];
    NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
    if (status == 0) {
        prompting = [[GPPrompting alloc] initWithView:self.view Text:@"您已经向对方抛了个媚眼" Icon:nil];
        [self.view addSubview:prompting];
        [prompting show];
    }
    else
    {
        prompting = [[GPPrompting alloc] initWithView:self.view Text:msg Icon:nil];
        [self.view addSubview:prompting];
        [prompting show];
    }
}

- (IBAction)sendMsg:(UIButton *)sender
{
    MChatListVC *chatListVC = [[MChatListVC alloc] init];
    chatListVC.senderId = friendId;
    chatListVC.nameString = friendName;
    [self.navigationController pushViewController:chatListVC animated:YES];

}

- (IBAction)showGift:(UIButton *)sender
{
    //判断有没有礼物，如果有礼物， 将礼物图片显示在礼物按钮下方每一行五张图片，并且那么酒吧收藏按钮往下平移到离最后一行图片底部14像素
}

- (IBAction)barCollection:(UIButton *)sender
{
    MMyCollectVC *friendCollectVC = [[MMyCollectVC alloc] init];
    friendCollectVC.isMyCollect = NO;
    friendCollectVC.collectId = friendId;
    friendCollectVC.titleNameString = friendName;
    [self.navigationController pushViewController:friendCollectVC animated:YES];
}
@end
