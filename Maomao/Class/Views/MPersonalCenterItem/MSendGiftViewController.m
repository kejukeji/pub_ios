//
//  MSendGiftViewController.m
//  Maomao
//
//  Created by maochengfang on 13-12-26.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MSendGiftViewController.h"
#import "MBackBtn.h"
#import "Utils.h"
#import "JSON.h"
#import "MSendGiftModel.h"
#import "UIButton+WebCache.h"
#import "MTitleView.h"

@interface MSendGiftViewController ()

@end

@implementation MSendGiftViewController

@synthesize receiverID;

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
	// Do any additional setup after loading the view.
    // Do any additional setup after loading the view from its nib.
    
    MTitleView *sendGiftTitleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    sendGiftTitleView.titleName.text = @"送小礼物";
    self.navigationItem.titleView = sendGiftTitleView;
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    // [self.mainScrollView setFrame:CGRectMake(0, 0, 320,411+(noiOS7?0:20)+(iPhone5?88:0))];
    
    giftItemSource = [NSMutableArray arrayWithCapacity:0];
    
    hud = [[MBProgressHUD alloc]  init];
    [hud setLabelText:@"加载中，请稍等"];
    [hud show:YES];
}

- (void)back
{
    [self.sendGiftItemRequest clearDelegatesAndCancel];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - Send Gift Item Method

- (void)initWithRequestByUrl:(NSString *)urlString
{
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
    
    if (self.sendGiftItemRequest != nil) {
        [self.sendGiftItemRequest clearDelegatesAndCancel];
        self.sendGiftItemRequest = nil;
    }
    
    NSURL * url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.sendGiftItemRequest = [ASIHTTPRequest requestWithURL:url];
    [self.sendGiftItemRequest setTimeOutSeconds:kRequestTime];
    [self.sendGiftItemRequest setDelegate:self];
    [self.sendGiftItemRequest startAsynchronous];
}

- (void)sendGiftRequestByUrl:(NSString *)urlString
{
    isNetWork = [Utils checkCurrentNetWork];
    
    if (!isNetWork)
    {
        if (prompting != nil)
        {
            [prompting removeFromSuperview];
            prompting = nil;
        }
        prompting = [[GPPrompting alloc] initWithView:self.view Text:@"网络链接中断" Icon:nil];
        [self.view addSubview:prompting];
        [prompting show];
        return;
    }
    
    if (self.sendGiftRequest != nil)
    {
        [self.sendGiftRequest clearDelegatesAndCancel];
        self.sendGiftRequest = nil;
    }
    
    NSURL * url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.sendGiftRequest = [ASIHTTPRequest requestWithURL:url];
    [self.sendGiftRequest setTimeOutSeconds:kRequestTime];
    [self.sendGiftRequest setDelegate:self];
    [self.sendGiftRequest startAsynchronous];
}


#pragma mark -
#pragma mark - ASIHTTPRequestDelgate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //发送礼物请求操作
    if (request == self.sendGiftRequest) {
        
        NSString *sendGiftResponse = [request responseString];
        if (sendGiftResponse == nil || [sendGiftResponse JSONValue] ==  nil) {
            return;
        }
        
        NSDictionary    *sendGiftResponseDict = [sendGiftResponse JSONValue];
        NSInteger   status = [[sendGiftResponseDict objectForKey:@"status"] integerValue];
        
        if (status == 0) {
            prompting = [[GPPrompting alloc] initWithView:self.view Text:@"礼物发送成功" Icon:nil];
            [self.view addSubview:prompting];
            [prompting show];
        }
        else
        {
            prompting = [[GPPrompting alloc] initWithView:self.view Text:@"礼物发送失败" Icon:nil];
            [self.view addSubview:prompting];
            [prompting show];
        }
    }
    
    //加载礼物item操作
    if (request == self.sendGiftItemRequest) {
        NSString *response = [request responseString];
        
        if (response == nil || [response JSONValue] == nil)
        {
            return;
        }
        NSDictionary *responseDict =  [response JSONValue];
        
        NSInteger   status = [[responseDict objectForKey:@"status"] integerValue];
        NSArray     *giftList = [responseDict objectForKey:@"gift"];
        
        if (status == 0)
        {
            for(NSDictionary *giftItem in giftList)
            {
                MSendGiftModel  *model = [[MSendGiftModel alloc] init];
                model.base_path = [giftItem objectForKey:@"base_path"];
                model.cost = [[giftItem objectForKey:@"cost"] integerValue];
                model.gift_id = [[giftItem objectForKey:@"id"] integerValue];
                model.name = [giftItem objectForKey:@"name"];
                model.pic_name = [giftItem objectForKey:@"pic_name"];
                model.pic_path = [giftItem objectForKey:@"pic_path"];
                model.rel_path = [giftItem objectForKey:@"rel_path"];
                model.status   = [[giftItem objectForKey:@"status"] boolValue];
                model.words = [giftItem objectForKey:@"words"];
                
                [giftItemSource addObject:model];
            }
        }
        
        [self setGiftItems];
        [hud hide:YES];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [hud hide:YES];
    UIAlertView     *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络无法连接，请检查网络链接!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    
    [alertView show];
}

- (void)setGiftItems
{
    NSLog(@" gift count == %d",[giftItemSource count]);
    NSInteger   count =  [giftItemSource count];
    NSInteger   row = 0;
    float       xPoint;
    
    UIScrollView    *scrollow = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 416+ (iPhone5?88:0)) ];
    [scrollow setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:scrollow];
    
    for (int i = 0; i < count; i++) {
        
        MSendGiftModel  *model = [giftItemSource objectAtIndex:i];
        switch (i % 4) {
            case 0:
                xPoint = 10.0f;
                (i == 0) ? (row = 0):(row++);
                break;
            case 1:
                xPoint = 10.0f + 70.0f;
                break;
            case 2:
                xPoint = 10.0f + 2 * 70.0f;
                break;
            case 3:
                xPoint = 10.0f + 3 * 70.0f;
                break;
            default:
                break;
        }
        //设置礼物按钮
        NSString    *imgUrl = [NSString stringWithFormat:@"%@%@",MM_URL,model.pic_path];
        UIButton  *giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [giftBtn setImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal];
        [giftBtn setTag:model.gift_id];//获取gift_id；
        
        [giftBtn addTarget:self action:@selector(sendGift:) forControlEvents:UIControlEventTouchUpInside];
        [giftBtn setFrame:CGRectMake(xPoint, 15 + (row * 90), 60, 60)];
        
        //设置礼物名称
        UILabel     *giftName = [[UILabel alloc] init];
        [giftName setFrame:CGRectMake(giftBtn.frame.origin.x, giftBtn.frame.origin.y  + giftBtn.frame.size.height, 60, 15)];
        [giftName setText:model.name];
        [giftName setFont:[UIFont systemFontOfSize:12]];
        [giftName setTextAlignment:NSTextAlignmentCenter];
        [giftName setTextColor:[UIColor blackColor]];
        
        //设置礼物积分
        UILabel     *giftCost = [[UILabel alloc] init];
        [giftCost setFrame:CGRectMake(giftName.frame.origin.x, giftName.frame.origin.y + giftName.frame.size.height, 70, 15)];
        [giftCost setText:[ NSString stringWithFormat:@"%d 积分",model.cost]];
        [giftCost setFont:[UIFont systemFontOfSize:12]];
        [giftCost setTextAlignment:NSTextAlignmentCenter];
        
        //放置礼物item
        if ((!iPhone5 && row > 5) || (iPhone5 && row > 6))
        {
            [scrollow addSubview:giftBtn];
            [scrollow addSubview:giftName];
            [scrollow addSubview:giftCost];
        }
        else
        {
            [scrollow addSubview:giftBtn];
            [scrollow addSubview:giftName];
            [scrollow addSubview:giftCost];
        }
    }
    
    if ((!iPhone5 && row > 5) || (iPhone5 && row > 6))
    {
        [scrollow setContentSize:CGSizeMake(320, 15 + (row * 50))];
    }
    
    if (!noiOS7) {
        for (UIView *view in self.view.subviews) {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
        }
    }
    
}

- (void)sendGift:(UIButton *)sender
{
    NSString *sender_id = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    NSLog(@"receiver_id == %@",receiverID);
    //    NSString *giftId = [NSString stringWithFormat:@"%d",sender.tag];
    
    NSString *url = [NSString stringWithFormat:@"%@/restful/sender/gift?sender_id=%@&receiver_id=%@&gift_id=%d",MM_URL,sender_id,receiverID,sender.tag];
    
    NSLog(@" send gift url == %@",url);
    
    [self sendGiftRequestByUrl:url];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
