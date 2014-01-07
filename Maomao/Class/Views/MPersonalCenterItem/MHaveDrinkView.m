//
//  MHaveDrinkView.m
//  Maomao
//
//  Created by maochengfang on 13-12-10.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MHaveDrinkView.h"
#import "MTitleView.h"
#import "MBackBtn.h"
#import "Utils.h"
#import "JSON.h"

@interface MHaveDrinkView ()

@end

@implementation MHaveDrinkView

@synthesize receiver_id;
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
    MTitleView *drinkTitleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    drinkTitleView.titleName.text =@"喝一杯";
    
    self.navigationItem.titleView = drinkTitleView;
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    if (!noiOS7) {
        for(UIView *view in self.view.subviews)
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
        }
    }
    
    
}

- (void) back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendInviteBtn:(UIButton *)sender
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    //http://42.121.108.142:6001/restful/sender/invite?sender_id=1&receiver_id=3
    NSString *url = [NSString stringWithFormat:@"%@/restful/sender/invite?sender_id=%@&receiver_id=%d",MM_URL,userid,receiver_id];
        [self sendInviteRequest:url];
    

}

- (void)sendInviteRequest:(NSString *)urlString
{
    NSLog(@"urlString == %@",urlString);
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
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
    
    NSInteger   status = [[responseDict objectForKey:@"status"] integerValue];
    NSString *msg = [responseDict objectForKey:@"message"];
    if (status ==0) {
        prompting = [[GPPrompting alloc] initWithView:self.view Text:@"邀请已发送" Icon:nil];
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

- (void)requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *alertView = [[UIAlertView alloc]
initWithTitle:@"温馨提示" message:@"网络无法连接，请检查网络连接" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alertView show];

}
@end
