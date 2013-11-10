//
//  MBarSearch.m
//  Maomao
//
//  Created by maochengfang on 13-10-28.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MBarSearchVC.h"
#import "MBackBtn.h"
#import "Utils.h"
#import "JSON.h"

@interface MBarSearchVC ()
{
    MBProgressHUD   *hud;
    GPPrompting     *prompting;
    BOOL             isNetWork;
}

@end

@implementation MBarSearchVC

@synthesize searchContentTF;
@synthesize sendRequest;
@synthesize sendSearchRequest;

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
    [self.view setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    hud = [[MBProgressHUD alloc] init];
    [hud setLabelText:@"加载中，请稍等！"];
    [hud show:YES];
    [self.view addSubview:hud];
    
    NSString *url = [NSString stringWithFormat:@"%@/restful/pub/search/view",MM_URL];
    [self initWithRequestByUrl:url];
}

- (void)back
{
    [self.sendRequest clearDelegatesAndCancel];
    [self.sendSearchRequest clearDelegatesAndCancel];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchHotBar:(UIButton *)sender
{
    
    [self back];
}

#pragma mark -
#pragma mark  Send Request Method

- (void)initWithRequestByUrl:(NSString *)urlString;
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

- (void)sendSearchResultRequestByUrl:(NSString *)urlString;
{
    [hud setLabelText:@"搜索中，请稍等！"];
    [hud show:YES];

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
    
    if (self.sendSearchRequest != nil) {
        [self.sendSearchRequest clearDelegatesAndCancel];
        self.sendSearchRequest = nil;
    }
    
    NSURL * url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.sendSearchRequest = [ASIHTTPRequest requestWithURL:url];
    [self.sendSearchRequest setTimeOutSeconds:kRequestTime];
    [self.sendSearchRequest setDelegate:self];
    [self.sendSearchRequest startAsynchronous];
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
    
    if (request == sendRequest) {
        NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
        
        if (status == 0) {
            
        }
        
        [hud hide:YES];
    }
    
    if (request == sendSearchRequest) {
        NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
        
        if (status == 0) {
            
        }
        
        [hud hide:YES];
    }
    
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

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [searchContentTF resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [searchContentTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
