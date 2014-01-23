//
//  MBarActivityVC.m
//  Maomao
//
//  Created by maochengfang on 13-12-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MBarActivityVC.h"
#import "MBackBtn.h"
#import "MActivityDetailModel.h"
#import "Utils.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"
#import "MRightBtn.h"

@interface MBarActivityVC ()
{
    NSString        *activityId;//酒吧活动id
    MRightBtn       *rightBtn;
    UIScrollView    *barActivityScrollView;
    
}
@end

@implementation MBarActivityVC

@synthesize activityImg;
@synthesize activityTitleLable;
@synthesize addressLable;
@synthesize jionNumLabel;
@synthesize activityDetailLable;
@synthesize activityTimeLabel;
@synthesize sendRequest;
@synthesize sendCollectRequest;
@synthesize sendCancelCollectRequest;

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
    [self.view setBackgroundColor:[UIColor  colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc ] initWithCustomView:backBtn];
    
    rightBtn = [MRightBtn buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    barActivityScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44+(noiOS7?0:20), 320, 416+(iPhone5?88:0))];
    [barActivityScrollView setBackgroundColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.89 alpha:1.0]];
    
    hud = [[MBProgressHUD alloc] init];
    [hud setLabelText:@"加载中,请稍后!"];
    [hud show:YES];
    [barActivityScrollView addSubview:hud];
    
    if (!noiOS7) {
        
        for(UIView  *view in self.view.subviews)
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y - 64, view.frame.size.width, view.frame.size.height)];
            [barActivityScrollView addSubview:view];
        }
    }
    else
    {
        barActivityScrollView.frame = CGRectMake(barActivityScrollView.frame.origin.x, barActivityScrollView.frame.origin.y - 44 , barActivityScrollView.frame.size.width, barActivityScrollView.frame.size.height);
        for(UIView  *view in self.view.subviews)
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
            [barActivityScrollView addSubview:view];
        }
    }
    
    
    
    [barActivityScrollView setContentSize:CGSizeMake(320, 550)];
    [self.view addSubview:barActivityScrollView];
}

- (void)back
{
    [self.sendRequest clearDelegatesAndCancel];
    [self.sendCollectRequest clearDelegatesAndCancel];
    [self.sendCancelCollectRequest clearDelegatesAndCancel];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)collect:(UIButton *)button
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    if ([button.titleLabel.text isEqualToString:@"收藏"]) {
       // http://42.121.108.142:6001/restful/cancel/collect/activity?user_id=1&activity_id=6
        //url 得看接口
        NSString *url = [NSString stringWithFormat:@"%@/restful/cancel/collect/activity?user_id=%@&activity_id=%@",MM_URL,user_id,activityId];
        NSLog(@"activity collect url  == %@",url);
        [self sendCollectRequest:url];
        
    }else if ([button.titleLabel.text isEqualToString:@"取消收藏"])
    {
        
        //url 得看接口
        NSString *url = [NSString stringWithFormat:@"%@/restful/cancel/collect/activity?user_id=%@&activity_id=%@",MM_URL,user_id,activityId];
        NSLog(@"activity cancelcollect url  == %@",url);
        [self sendCancelCollectRequest:url];
    }
    
}

#pragma mark 
#pragma mark - send Request Method

-(void)initWithRequestByUrl:(NSString *)urlString
{
    NSLog(@"urlString ==%@",urlString);
    isNetWork = [Utils checkCurrentNetWork];
    
    if (!isNetWork) {
        if (prompting != nil) {
            [prompting removeFromSuperview];
            prompting = nil;
        }
        
        prompting = [[GPPrompting alloc] initWithView:self.view Text:@"网络连接中断" Icon:nil];
        [self.view addSubview:prompting];
        [prompting show];
        return;
    }
    
    if (self.sendRequest != nil) {
        [self.sendRequest clearDelegatesAndCancel];
        self.sendRequest = nil;
    }
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    self.sendRequest = [ASIHTTPRequest requestWithURL:url];
    [self.sendRequest setTimeOutSeconds:kRequestTime];
    [self.sendRequest setDelegate:self];
    [self.sendRequest startAsynchronous];
    
}

- (void)sendCollectRequest:(NSString *)urlString
{
    [hud setLabelText:@"正在收藏，请稍后！"];
    [hud show:YES];
    isNetWork = [Utils checkCurrentNetWork];
    
    if (!isNetWork) {
        if (prompting != nil) {
            [prompting removeFromSuperview];
            prompting = nil;
        }
        prompting = [[GPPrompting alloc] initWithView:self.view Text:@"网络连接中断" Icon:nil];
        [prompting show];
        return;
    }
    
    if (self.sendCollectRequest != nil) {
        [self.sendCollectRequest clearDelegatesAndCancel];
        self.sendCollectRequest = nil;
    }
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    self.sendCollectRequest = [ASIHTTPRequest requestWithURL:url];
    [self.sendCollectRequest setTimeOutSeconds:kRequestTime];
    [self.sendCollectRequest setDelegate:self];
    [self.sendCollectRequest startAsynchronous];
}

- (void)sendCancelCollectRequest:(NSString *)urlString
{
    [hud setLabelText:@"正在取消收藏，请稍后！"];
    [hud show:YES];
    isNetWork = [Utils checkCurrentNetWork];
    
    if (!isNetWork) {
        if (prompting != nil) {
            [prompting removeFromSuperview];
            prompting = nil;
        }
        prompting = [[GPPrompting alloc] initWithView:self.view Text:@"网络连接中断" Icon:nil];
        [prompting show];
        return;
    }
    
    if (self.sendCancelCollectRequest != nil) {
        [self.sendCancelCollectRequest clearDelegatesAndCancel];
        self.sendCancelCollectRequest = nil;
    }
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    self.sendCancelCollectRequest = [ASIHTTPRequest requestWithURL:url];
    [self.sendCancelCollectRequest setTimeOutSeconds:kRequestTime];
    [self.sendCancelCollectRequest setDelegate:self];
    [self.sendCancelCollectRequest startAsynchronous];

}

#pragma mark
#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    
    NSLog(@"response == %@",response);
    if (response ==nil || [response JSONValue] == nil) {
        return;
    }
    
    NSDictionary *responseDict = [response JSONValue];
    
    if (request == sendRequest) {
        NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
        NSDictionary *activity = [responseDict objectForKey:@"activity"];
        
        if (status ==0) {
            
                MActivityDetailModel *activityModel = [[MActivityDetailModel alloc] init];
                //酒吧活动信息
                activityModel.activity_info = [activity objectForKey:@"activity_info"];
                activityModel.base_path = [activity objectForKey:@"base_path"];
                activityModel.address = [activity objectForKey:@"address"];
                activityModel.end_date = [activity objectForKey:@"end_date"];
                activityModel.hot = [[activity objectForKey:@"hot"] boolValue];
               // activityModel.activity_id = [[activityDict objectForKey:@"id"] integerValue];
                activityModel.activity_id = [activity objectForKey:@"id"];
                activityModel.is_collect = [[activity objectForKey:@"is_collect"] boolValue];
                activityModel.pic_name = [activity objectForKey:@"pic_name"];
                activityModel.pic_path = [activity objectForKey:@"pic_path"];
                activityModel.rel_path = [activity objectForKey:@"rel_path"];
                activityModel.start_date = [activity objectForKey:@"start_date"];
                activityModel.title = [activity objectForKey:@"title"];
                activityModel.join_people_number = [[activity objectForKey:@"join_people_number"] integerValue];
                
                //获取活动id
                activityId = activityModel.activity_id;
                [self setDetailConten:activityModel];
            
        }
        [hud hide:YES];
    }
    
    if (request == sendCollectRequest)
    {
        [hud hide:YES];
        NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
        if (status ==0) {
            [rightBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
            if (prompting != nil) {
                [prompting removeFromSuperview];
                prompting = nil;
            }
            prompting = [[GPPrompting alloc] initWithView:self.view Text:@"收藏酒吧活动成功" Icon:nil];
            [self.view addSubview:prompting];
            [prompting show];
        }
        else if (status ==1)
        {
            [rightBtn setTitle:@"收藏" forState:UIControlStateNormal];

            if (prompting !=nil) {
                [prompting removeFromSuperview];
                prompting = nil;
            }
            prompting = [[GPPrompting alloc] initWithView:self.view Text:@"收藏失败" Icon:nil];
            [self.view addSubview:prompting];
            [prompting show];
        }
    }
    
    if(request == sendCancelCollectRequest)
    {
        [hud hide:YES];
        NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
        if (status == 0) {
            [rightBtn setTitle:@"收藏" forState:UIControlStateNormal];
            if (prompting != nil) {
                [prompting removeFromSuperview];
                prompting = nil;
            }
            prompting = [[GPPrompting alloc] initWithView:self.view Text:@"取消收藏成功" Icon:nil];
            [self.view addSubview:prompting];
            [prompting show];
            return;
        } else if (status == 1) {
            if (prompting != nil) {
                [prompting removeFromSuperview];
                prompting = nil;
            }
            prompting = [[GPPrompting alloc] initWithView:self.view Text:@"取消收藏失败" Icon:nil];
            [self.view addSubview:prompting];
            [prompting show];
            return;
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [hud hide:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络无法连接，请检查网络连接!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alertView show];
}

- (void)setDetailConten:(MActivityDetailModel *)model
{
    if (model.is_collect) {
        [rightBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
    }
    else
    {
        [rightBtn setTitle:@"收藏" forState:UIControlStateNormal];
    }
    NSString    *start1 = [model.start_date stringByReplacingOccurrencesOfString:@"-" withString:@"月"]; //将第一个”-“替换成月
    NSString    *start2 = [start1 stringByReplacingOccurrencesOfString:@" " withString:@"日"];//将第二个”-“替换成日
    
    NSString    *year = [start2 substringWithRange:NSMakeRange(0, 4)]; //获取年份
    NSString    *month_Date = [start2 substringWithRange:NSMakeRange(5, 11)];//获取月日
    NSString    *Time1 = [NSString stringWithFormat:@"%@年%@",year,month_Date];//组合时间
    
    NSString    *Time_Y_M_D = [Time1 substringWithRange:NSMakeRange(0, 11)];//分离日期
    NSString    *Time_T = [Time1 substringWithRange:NSMakeRange(11, 5)];  //分离时间
    NSLog(@"Time_Y_M_D = %@",Time_Y_M_D);
    NSLog(@"Time_T = %@", Time_T);
    
    
    NSString    *end1 = [model.end_date stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
    NSString    *end2 = [end1 stringByReplacingOccurrencesOfString:@" " withString:@"日"];
    NSString    *end3 = [end2 substringWithRange:NSMakeRange(11, 5)];
    NSLog(@"end3 = %@",end3);
    
    NSString *picPath = [NSString stringWithFormat:@"%@%@/%@",MM_URL,model.rel_path,model.pic_name];
    [activityImg setImageWithURL:[NSURL URLWithString:picPath] placeholderImage:[UIImage imageNamed:@"common_img_default.png"]];
    
    [activityTitleLable setText:model.title];
    [addressLable setText:model.address];
    [jionNumLabel setText:[NSString stringWithFormat:@"已有%d人参加",model.join_people_number]];
    [activityDetailLable setText:model.activity_info];
    activityTimeLabel.text = [NSString stringWithFormat:@"时间: %@ %@-%@",Time_Y_M_D,Time_T,end3];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
