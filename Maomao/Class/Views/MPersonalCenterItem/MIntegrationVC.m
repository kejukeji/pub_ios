//
//  MIntegrationVC.m
//  Maomao
//
//  Created by maochengfang on 13-12-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MIntegrationVC.h"
#import "JSON.h"

@interface MIntegrationVC ()
{
    BOOL    isNetWork;
    GPPrompting *prompting;
    NSMutableArray  *integrationSource;
    
    //积分数据
    NSString *credit ;
    NSString *reputation;
    NSString *reputation_difference;
    
    NSInteger reputation1;
    NSInteger reputation_difference1;
    
}
@end

@implementation MIntegrationVC

@synthesize creditLabel;
@synthesize reputationLabel;
@synthesize reputation_DiffeLabel;
@synthesize levelImg;
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
    
    MTitleView *integrationTitleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    integrationTitleView.titleName.text = @"积分规则";
    
    self.navigationItem.titleView = integrationTitleView;
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn   ];
    
    //设置滑动视图来适配3.5英寸的屏幕
    integrationScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44+(noiOS7?:20), 320, 416+(iPhone5?88:0))];
    
    
        for(UIView *view in self.view.subviews)
        {
            [integrationScrollView addSubview:view];
           
        }
    
    [integrationScrollView setContentSize:CGSizeMake(320,530)];

    
//    if (iPhone5) {
//        [integrationScrollView setContentSize:CGSizeMake(320,530)];
//    }
//    else
//    {
//        [integrationScrollView setContentSize:CGSizeMake(320,480)];
//    }
    
    [self.view addSubview:integrationScrollView];
    
}


- (void)back
{
    [sendRequest clearDelegatesAndCancel];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark - Send Request Method

- (void)initRequestWithUrl:(NSString *)urlString
{
    isNetWork = [Utils checkCurrentNetWork];
    
    if (!isNetWork)
    {
        if (prompting != nil)
        {
            [prompting removeFromSuperview];
            prompting = nil;
            
        }
         prompting = [[GPPrompting alloc] initWithView:self.view Text:@"网络连接中断" Icon:nil];
        [self.view addSubview:prompting];
        [prompting show];
        return;
    }
    
    if (self.sendRequest != nil) {
        [sendRequest clearDelegatesAndCancel];
        self.sendRequest = nil;
    }
    
    NSURL * url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    sendRequest = [ASIHTTPRequest requestWithURL:url];
    [sendRequest setTimeOutSeconds:kRequestTime];
    [sendRequest setDelegate:self];
    [sendRequest startAsynchronous];
    
}

#pragma mark - 
#pragma mark - ASIHTTPRequest Delegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
   
    
    NSString *response = [request responseString];
    
    if (response == nil || [response JSONValue] == nil) {
        return;
    }
    
    NSDictionary *responseDict = [response JSONValue];
    NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
    NSString *message = [responseDict objectForKey:@"message"];
    
    if (status == 0) //因为数据比较少因此请求成功就直接在页面上现实数据
    {
       
        
        credit = [responseDict objectForKey:@"credit"];
        
        NSLog(@"credit = %@",credit);
       
        reputation = [responseDict objectForKey:@"reputation"];
        //获取整形数据来显示级别进度
        reputation1 = [[responseDict objectForKey:@"reputation"] integerValue];
        reputation_difference1 = [[responseDict objectForKey:@"reputation_difference"] integerValue];
        NSLog(@"reputation1 = %d reputation_difference1 = %d",reputation1,reputation_difference1);
        /************************************/
        
        //reputationLabel.text = reputation;
        reputation_difference = [responseDict objectForKey:@"reputation_difference"];
        
        //reputation_DiffeLabel.text = reputation_difference;
     
        [self setReputationLevel];//设置等级标识
    }
    else
    {
        prompting = [[GPPrompting alloc] initWithView:self.view Text:message Icon:nil];
        [self.view addSubview:prompting];
        [prompting show];
    }
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView  *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    
    [alertView show];
}
- (void)setReputationLevel //设置等级
{
    
    [creditLabel setText:[NSString stringWithFormat:@"%@",credit]];
    [reputationLabel setText:[NSString stringWithFormat:@"经验值: %@",reputation]];
    [reputation_DiffeLabel setText:[NSString stringWithFormat:@"%@",reputation_difference]];
    
    float rate = ((float)reputation1 /(reputation1+ reputation_difference1));
    
    NSLog(@"rate = %f",rate);
    
    UIImageView  *img = [[UIImageView alloc] init];
    
    img.frame = CGRectMake(37, 164, levelImg.frame.size.width -254*rate, levelImg.frame.size.height);
    
    [img setImage:[UIImage imageNamed:@"integration_value_blue.png"]];
    
    [integrationScrollView addSubview:img];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
