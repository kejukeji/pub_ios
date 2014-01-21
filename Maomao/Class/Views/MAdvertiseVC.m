//
//  MAdvertiseVC.m
//  Maomao
//
//  Created by maochengfang on 14-1-21.
//  Copyright (c) 2014年 BangQu. All rights reserved.
//

#import "MAdvertiseVC.h"
#import "MBackBtn.h"
@interface MAdvertiseVC ()
{
    UIWebView       *AdWebView;
}
@end

@implementation MAdvertiseVC
@synthesize advertiseUrl;

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
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    AdWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 416+(iPhone5?88:0))];
    AdWebView.scalesPageToFit = YES;
    [AdWebView setDelegate:self];
    NSURLRequest    *request = [NSURLRequest requestWithURL:[NSURL URLWithString:advertiseUrl]];
    [self.view addSubview:AdWebView];
    [AdWebView loadRequest:request];
    
    
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
