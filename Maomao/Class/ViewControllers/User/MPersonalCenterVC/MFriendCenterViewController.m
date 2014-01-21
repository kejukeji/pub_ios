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
#import "MMFriendGiftVC.h"

@interface MFriendCenterViewController ()
{
    MBProgressHUD *hud;
    DropDownControllView *mDropDownView;
    int count;//点击礼物按钮计数，偶数收藏button视图以及剪头ImageView视图下滑
    UIView          *giftView;//朋友中心礼物视图
    NSInteger       receiver_id;
    UIImageView     *imgView;
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

@synthesize reputationLabel;//经验值
@synthesize friendNameLabel;
@synthesize friendSignLabel;
@synthesize friendId;
@synthesize formDataReuqest;
@synthesize friendIcon;
@synthesize sendGreetingRequest;
@synthesize friendName;
@synthesize provinceLabel;

/*******下滑控件*******/
@synthesize moveFrame1;
@synthesize moveFrame2;
@synthesize xView;
/*************/

@synthesize sendFriendDataRequest;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.89 alpha:1.0]];
    if (iPhone5)
    {
        [self.view setFrame:CGRectMake(0,0, 320, 416+(iPhone5?88:0)+64)];
    }
    imgView = [[UIImageView alloc] init];

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
    count = 1;
    
    friendCenterScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44+(noiOS7?0:20), 320, 416+(iPhone5?88:0)) ];
    
    hud = [[MBProgressHUD alloc] init];
    [hud setLabelText:@"加载中请稍后!"];
    [hud show:YES];
    [friendCenterScrollView addSubview:hud];
  
    for (UIView *view in self.view.subviews)
    {
            
    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-64, view.frame.size.width, view.frame.size.height)];
        [friendCenterScrollView addSubview:view];
      
    }
    
    if (iPhone5) {
        [friendCenterScrollView setContentSize:CGSizeMake(320, 0)];
    }
    else
    {
       [friendCenterScrollView setContentSize:CGSizeMake(320, 400)];
    }
    
    [self.view addSubview:friendCenterScrollView];
   

}

- (void)back
{
    [self.formDataReuqest clearDelegatesAndCancel];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self friendInfo];
    [self moreInfo];
    
}


- (void)moreInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/restful/personal/center?user_id=%@",MM_URL, friendId];
    NSLog(@"urlString in moreInfo== %@",urlString);
    NSURL * url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    sendFriendDataRequest = [ASIHTTPRequest requestWithURL:url];
    [sendFriendDataRequest setTimeOutSeconds:kRequestTime];
    [sendFriendDataRequest setDelegate:self];
    [sendFriendDataRequest startAsynchronous];
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
        
        /****************处理地址格式：省市分离*********************/
        NSRange     city;
        NSString *getArea = [[NSUserDefaults standardUserDefaults] stringForKey:kCounty];
        
        NSLog(@"getArea == %@",getArea);
        
        NSString    *Province = [getArea  substringWithRange:NSMakeRange(0, 2)];
        
        NSLog(@"Province == %@",Province);
        provinceLabel.text = [NSString stringWithFormat:@"%@",Province];
        
        city = [getArea rangeOfString:@"$"];//获取标记位的范围
        
        NSLog(@"city length == %d",city.location);
        
        if ([Province isEqualToString:@"上海"]) {
            NSString    *city1 = [getArea substringWithRange:NSMakeRange(city.location+5, 3)];//获取市
            NSLog(@"city = %@",city1);
           friendAreaLabel.text = [NSString stringWithFormat:@"%@",city1];
        }
        else
        {
            NSString    *city1 = [getArea substringWithRange:NSMakeRange(city.location+1, 3)];//获取市
            NSLog(@"city = %@",city1);
            friendAreaLabel.text= [NSString stringWithFormat:@"%@",city1];
        }

        
       // friendAreaLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:kCounty];
        
        NSLog(@"friendAreaLabel == %@",friendAreaLabel.text);
        
        NSString *path = [NSString stringWithFormat:@"%@%@",MM_URL,pic_path];
        [friendIcon setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"common_userHeadImg.png"]];
        friendName = nickName;
        friendNameLabel.text = friendName;
        NSLog(@"friendNameLabel.text==%@",friendNameLabel.text);
        
        if ([sex isEqualToString:@"1"]) {
            genderLabel.text = @"帅哥";
        }
        else if ([sex isEqualToString:@"0"])
        {
            genderLabel.text = @"美女";
        }
        else
        {
            genderLabel.text = @" ";
        }
        
        if ([signature isEqualToString:@"<null>"]) {
            friendSignLabel.text = @"暂无签名";
        }
        else{
            
             friendSignLabel.text = signature;
        }
       
        
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
        [view removeFromSuperview];
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
    
    NSString *url = [NSString stringWithFormat:@"%@/restful/sender/greeting?sender_id=%@&receiver_id=%d",MM_URL,userid,receiver_id];
    [self sendGreetingRequest:url];
    NSLog(@"Teaser url == %@",url);
    
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
  
    NSLog(@"send gift");
    MSendGiftViewController *sendGiftVC = [[MSendGiftViewController  alloc] init];
    
    sendGiftVC.receiverID = [NSString stringWithFormat:@"%d",receiver_id];
    
    NSString *url = [NSString stringWithFormat:@"%@/restful/sender/gift/view",MM_URL];
    
    [sendGiftVC initWithRequestByUrl:url];
    
    [self.navigationController pushViewController:sendGiftVC animated:YES];
    
    
}

#pragma mak - 
#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request == sendGreetingRequest) {
        NSString *response = [request responseString];
        if (response == nil  || [response JSONValue] == nil) {
            return;
        }
        NSDictionary *responseDict = [response JSONValue];
        NSString *msg = [responseDict objectForKey:@"message"];
        NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
        if (status == 0)
        {

            
            [self showEye];
        }
        else
        {
            prompting = [[GPPrompting alloc] initWithView:self.view Text:msg Icon:nil];
            [self.view addSubview:prompting];
            [prompting show];
        }

    }
    
    if (request == sendFriendDataRequest)
    {
        NSString *response = [request responseString];
        if (response == nil || [response JSONValue] == nil ) {
            return;
        }
        
        NSDictionary *responseDict = [response JSONValue];
        NSInteger    status = [[responseDict objectForKey:@"status"] integerValue];
        NSDictionary *user = [responseDict objectForKey:@"user"];
        if (status == 0) {
            /*****************二期增加的内容*********************************/
            NSInteger credit = [[user objectForKey:@"credit"] integerValue];
            NSInteger gift =  [[user objectForKey:@"gift"] integerValue];
            
            creditLabel.text = [NSString stringWithFormat:@"%d",credit];
            reputationLabel.text = [user objectForKey:@"level_description"];
            NSLog(@"gift == %d", gift);
            numofGift.text = [NSString stringWithFormat:@"%d", gift];
          
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [hud hide:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络无法连接，请检查网络" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alertView show];
}

- (void)showEye
{
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(89,100, 100, 50)];
    [img setImage:[UIImage imageNamed:@"personalCenter__img_eye.png"]];
    [friendCenterScrollView addSubview:img];
    imgView = img;
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(dispearEye) userInfo:nil repeats:NO];
}
- (void)dispearEye
{
    [imgView removeFromSuperview];
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
    MMFriendGiftVC *friendGiftView = [[MMFriendGiftVC alloc] init];
    NSString    *url = [NSString stringWithFormat:@"%@/restful/gift/receiver?user_id=%@&page=1&gift_type=friend",MM_URL,friendId];
    NSLog(@"Friend gift Url == %@",url);
    [friendGiftView initWithRequestByUrl:url];
    
   [self.navigationController pushViewController:friendGiftView animated:YES];
  
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
