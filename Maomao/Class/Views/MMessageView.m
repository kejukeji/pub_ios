//
//  MMessageView.m
//  Maomao
//
//  Created by  zhao on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MMessageView.h"
#import "JSON.h"
#import "Utils.h"   
#import "GPPrompting.h"

@implementation MMessageView
{
    BOOL     isNetWork;
    GPPrompting *prompting;
    UIButton *systemMessageBtn;
    UIButton *privateMessageBtn;
    
}
@synthesize delegate;
@synthesize sendRequest;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];

        UIImageView *topBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0+(noiOS7?0:20), 320, 44)];
        [topBar setImage:[UIImage imageNamed:@"common_topBar_blue.png"]];
        [topBar setUserInteractionEnabled:YES];
        [self addSubview:topBar];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setFrame:CGRectMake(14, 10, 30, 24)];
        [leftBtn setImage:[UIImage imageNamed:@"common_btn_left.png"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftSlider) forControlEvents:UIControlEventTouchUpInside];
        [topBar addSubview:leftBtn];
        
        UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 180, 44)];
        [titleName setTextColor:[UIColor whiteColor]];
        [titleName setText:@"消 息"];
        [titleName setFont:[UIFont boldSystemFontOfSize:20]];
        [titleName setBackgroundColor:[UIColor clearColor]];
        [titleName setTextAlignment:NSTextAlignmentCenter];
        [topBar addSubview:titleName];
        
        systemMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [systemMessageBtn setFrame:CGRectMake(0, 44+(noiOS7?0:20), 320, 42)];
        [systemMessageBtn addTarget:self action:@selector(gotoMessage:) forControlEvents:UIControlEventTouchUpInside];
        [systemMessageBtn setTag:111];
        [self addSubview:systemMessageBtn];
        
        UILabel *systemLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 120, 42)];
        [systemLable setBackgroundColor:[UIColor clearColor]];
        [systemLable setText:@"系统消息"];
        [systemLable setTextColor:[UIColor colorWithRed:0.20 green:0.40 blue:0.47 alpha:1.0]];
        [systemLable setFont:[UIFont systemFontOfSize:13]];
        [systemMessageBtn addSubview:systemLable];
        
        UIImageView *firstArrow = [[UIImageView alloc] initWithFrame:CGRectMake(300, 14, 10, 14)];
        [firstArrow setImage:[UIImage imageNamed:@"setting_img_greenArrow.png"]];
        [systemMessageBtn addSubview:firstArrow];
        
        UIImageView *firstLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 41, 320, 1)];
        [firstLine setImage:[UIImage imageNamed:@"common_img_longLine.png"]];
        [systemMessageBtn addSubview:firstLine];
        
       privateMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [privateMessageBtn setFrame:CGRectMake(0, 44 + (noiOS7?0:20) + 42, 320, 42)];
        [privateMessageBtn addTarget:self action:@selector(gotoMessage:) forControlEvents:UIControlEventTouchUpInside];
        [privateMessageBtn setTag:222];
        [self addSubview:privateMessageBtn];
        
        UILabel *privateLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 120, 42)];
        [privateLable setBackgroundColor:[UIColor clearColor]];
        [privateLable setText:@"私信消息"];
        [privateLable setTextColor:[UIColor colorWithRed:0.20 green:0.40 blue:0.47 alpha:1.0]];
        [privateLable setFont:[UIFont systemFontOfSize:13]];
        [privateMessageBtn addSubview:privateLable];
        
        UIImageView *secondArrow = [[UIImageView alloc] initWithFrame:CGRectMake(300, 14, 10, 14)];
        [secondArrow setImage:[UIImage imageNamed:@"setting_img_greenArrow.png"]];
        [privateMessageBtn addSubview:secondArrow];
        
        UIImageView *secondLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 41, 320, 1)];
        [secondLine setImage:[UIImage imageNamed:@"common_img_longLine.png"]];
        [privateMessageBtn addSubview:secondLine];
        /****************请求消息数*******************/
        NSString *user_Id = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
        NSString *url = [NSString stringWithFormat:@"%@/restful/user/message?user_id=%@",MM_URL,user_Id];
        NSLog(@"url == %@",url);
        [self initWithRequesrByUrl:url];
        /******************************************/
    }
    return self;
}

#pragma mark -
#pragma mark  Send Request Method

-  (void)initWithRequesrByUrl:(NSString *)urlString
{
    isNetWork = [Utils checkCurrentNetWork];
    if (!isNetWork) {
        if (prompting != nil) {
            [prompting removeFromSuperview];
            prompting = nil;
        }
        prompting = [[GPPrompting alloc] initWithView:self Text:@"网络连接中断" Icon:nil];
        [prompting show];
        return;
    }
    
    if (sendRequest != nil) {
        [sendRequest clearDelegatesAndCancel];
        sendRequest = nil;
    }
    
    NSURL   *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    sendRequest = [ASIHTTPRequest requestWithURL:url];
    [sendRequest setTimeOutSeconds:kRequestTime];
    [sendRequest setDelegate:self];
    [sendRequest startAsynchronous];
    
}


#pragma mark -
#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    
    if (response == nil || [response JSONValue] == nil) {
        return;
    }
    NSDictionary *responseDict = [response JSONValue];
    
    NSInteger   status = [[responseDict objectForKey:@""] integerValue];
    NSString *message = [responseDict objectForKey:@"message"];
    if (status == 0) {
        UILabel *direct_count = [[UILabel alloc] initWithFrame:CGRectMake(280, 14, 20, 14)];
        [direct_count setText:[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"direct_count"]]];
        [direct_count setTextColor:[UIColor colorWithRed:0.20 green:0.40 blue:0.47 alpha:1.0]];
        [direct_count setTextAlignment:NSTextAlignmentRight];
        [direct_count setFont:[UIFont systemFontOfSize:13]];
        [privateMessageBtn addSubview:direct_count];
        
        UILabel *system_count = [[UILabel alloc] initWithFrame:CGRectMake(280, 14, 20, 14)];
        [system_count setText:[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"system_count"]]];
        [system_count setTextColor:[UIColor colorWithRed:0.20 green:0.40 blue:0.47 alpha:1.0]];

        [system_count setTextAlignment:NSTextAlignmentRight];
        [system_count setFont:[UIFont systemFontOfSize:13]];
        [systemMessageBtn addSubview:system_count];
        
        
        NSLog(@"direct_count = %@ system_count = %@",direct_count.text,system_count.text);
    }
    else
    {
        prompting = [[GPPrompting alloc] initWithView:self Text:message Icon:nil];
        [prompting show];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"重要提示" message:@"网络连接中断" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alertView show];
}
- (void)leftSlider
{
    [delegate messageLeftSlider];
}

- (void)gotoMessage:(UIButton *)button
{
    [delegate gotoMessageDetails:button.tag];
}

@end
