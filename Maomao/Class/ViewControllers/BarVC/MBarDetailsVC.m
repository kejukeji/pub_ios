//
//  MBarDetailsVC.m
//  Maomao
//
//  Created by  zhao on 13-10-17.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MBarDetailsVC.h"
#import "MBackBtn.h"
#import "MBarDetailModel.h"
#import "MBarDetailSignaModel.h"
#import "Utils.h"
#import "JSON.h"
#import "UIButton+WebCache.h"
#import "MBarEnvironmentVC.h"
#import <MapKit/MapKit.h>

@interface MBarDetailsVC () <UIScrollViewDelegate>
{
    float currentXpoint;
}

@end

@implementation MBarDetailsVC

@synthesize barIconBtn;
@synthesize barNameLabel;
@synthesize signaNumberLabel;
@synthesize distanceLabel;
@synthesize addressLabel;
@synthesize barTypeLabel;
@synthesize barIntroTextView;
@synthesize signerShowScrollView;

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
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    signaSources = [NSMutableArray arrayWithCapacity:0];
    currentXpoint = 0;
    
    hud = [[MBProgressHUD alloc] init];
    [hud setLabelText:@"加载中，请稍等！"];
    [hud show:YES];
    [self.view addSubview:hud];
    
    if (!noiOS7) {
        for (UIView *view in self.view.subviews) {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
        }
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark -
#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    
    if (response == nil || [response JSONValue] == nil) {
        return;
    }
    
    NSDictionary *responseDict = [response JSONValue];
    
    NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
    NSArray *picList = [responseDict objectForKey:@"picture_list"];
    NSArray *pubList = [responseDict objectForKey:@"pub_list"];
    
    if (status == 0) {
        for (NSDictionary *picDict in picList) {
            MBarDetailSignaModel *signaModel = [[MBarDetailSignaModel alloc] init];
            
            //签到人员信息列表
            signaModel.base_path = [picDict objectForKey:@"base_path"];
            signaModel.birthday = [picDict objectForKey:@"birthday"];
            signaModel.birthday_type = [picDict objectForKey:@"birthday_type"];
            signaModel.city_id = [picDict objectForKey:@"city_id"];
            signaModel.company = [picDict objectForKey:@"company"];
            signaModel.county_id = [picDict objectForKey:@"county_id"];
            signaModel.email = [picDict objectForKey:@"email"];
            signaModel.ethnicity_id = [picDict objectForKey:@"ethnicity_id"];
            signaModel.signaId = [picDict objectForKey:@"id"];
            signaModel.intro = [picDict objectForKey:@"intro"];
            
            signaModel.job = [picDict objectForKey:@"job"];
            signaModel.mobile = [picDict objectForKey:@"mobile"];
            signaModel.pic_name = [picDict objectForKey:@"pic_name"];
            signaModel.pic_path = [picDict objectForKey:@"pic_path"];
            signaModel.province_id = [picDict objectForKey:@"province_id"];
            signaModel.real_name = [picDict objectForKey:@"real_name"];
            signaModel.rel_path = [picDict objectForKey:@"rel_path"];
            signaModel.sex = [picDict objectForKey:@"sex"];
            signaModel.signature = [picDict objectForKey:@"signature"];
            signaModel.street = [picDict objectForKey:@"street"];
            
            signaModel.tel = [picDict objectForKey:@"tel"];
            signaModel.upload_name = [picDict objectForKey:@"upload_name"];
            signaModel.user_id = [picDict objectForKey:@"user_id"];
            
            [signaSources addObject:signaModel];
        }
        
        [self setSignaPicConten];
        
        for (NSDictionary *pubDict in pubList) {
            MBarDetailModel *detailModel = [[MBarDetailModel alloc] init];
            
            //总体信息
            detailModel.county = [pubDict objectForKey:@"user_id"];
            detailModel.is_collect = [pubDict objectForKey:@"user_id"];
            detailModel.message = [pubDict objectForKey:@"user_id"];
            
            //酒吧详情数据
            detailModel.city_id = [[pubDict objectForKey:@"city_id"] integerValue];
            detailModel.county_id = [[pubDict objectForKey:@"county_id"] integerValue];
            detailModel.email = [pubDict objectForKey:@"email"];
            detailModel.fax = [pubDict objectForKey:@"fax"];
            detailModel.barDetailId = [pubDict objectForKey:@"id"];
            detailModel.intro = [pubDict objectForKey:@"intro"];
            detailModel.latitude = [pubDict objectForKey:@"latitude"];
            detailModel.longitude = [pubDict objectForKey:@"longitude"];
            detailModel.mobile_list = [pubDict objectForKey:@"mobile_list"];
            detailModel.name = [pubDict objectForKey:@"name"];
            
            detailModel.pic_path = [pubDict objectForKey:@"pic_path"];
            detailModel.province_id = [[pubDict objectForKey:@"province_id"] integerValue];
            detailModel.recommend = [[pubDict objectForKey:@"recommend"] boolValue];
            detailModel.street = [pubDict objectForKey:@"street"];
            detailModel.tel_list = [pubDict objectForKey:@"tel_list"];
            detailModel.type_name = [pubDict objectForKey:@"type_name"];
            detailModel.view_number = [pubDict objectForKey:@"view_number"];
            detailModel.web_url = [pubDict objectForKey:@"web_url"];
            
            [self setDetailConten:detailModel];
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

- (void)setSignaPicConten
{
    for (int i = 0; i < [signaSources count]; i++) {
        MBarDetailSignaModel *model = [signaSources objectAtIndex:i];
        
        UIButton *picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [picBtn addTarget:self action:@selector(gotoFriend:) forControlEvents:UIControlEventTouchUpInside];
        [picBtn setTag:[model.signaId integerValue]];
        [picBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        NSString *picPath = [NSString stringWithFormat:@"%@%@",MM_URL, model.pic_path];
        [picBtn setImageWithURL:[NSURL URLWithString:picPath] forState:UIControlStateNormal];
        [picBtn setFrame:CGRectMake(i*65, 0, 60, 60)];
        [signerShowScrollView addSubview:picBtn];
    }
    
    [signerShowScrollView setContentSize:CGSizeMake([signaSources count] * 65, 60)];
}

- (void)setDetailConten:(MBarDetailModel *)model
{
    NSString *picPath = [NSString stringWithFormat:@"%@%@",MM_URL, model.pic_path];
    [barIconBtn setImageWithURL:[NSURL URLWithString:picPath] forState:UIControlStateNormal];
    [barIconBtn addTarget:self action:@selector(gotoBarEnvironment:) forControlEvents:UIControlEventTouchUpInside];
    [barIconBtn setTag:[model.barDetailId integerValue]];
    
    [barNameLabel setText:[NSString stringWithFormat:@"%@",model.name]];
    [signaNumberLabel setText:[NSString stringWithFormat:@"%@",model.view_number]];
    [addressLabel setText:[NSString stringWithFormat:@"%@",model.street]];
    [barTypeLabel setText:[NSString stringWithFormat:@"%@",model.type_name]];
    [barIntroTextView setText:[NSString stringWithFormat:@"%@",model.intro]];
    
    //计算距离
    double locationLongitude = [[[NSUserDefaults standardUserDefaults] stringForKey:LONGITUDE] doubleValue];
    double locationLatitude = [[[NSUserDefaults standardUserDefaults] stringForKey:LATITUDE] doubleValue];
    
    double longitude = [model.longitude doubleValue];
    double latitude = [model.latitude doubleValue];
    
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:locationLatitude longitude:locationLongitude];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    distanceLabel.text = [NSString stringWithFormat:@"%0.1f km",[newLocation distanceFromLocation :currentLocation]/1000];
}

- (IBAction)slideSignerShowView:(UIButton *)sender
{
    float slideXpoin;
    
    if ((currentXpoint + 294) >= (signerShowScrollView.contentSize.width)) {
        slideXpoin = signerShowScrollView.contentSize.width - 294;
    } else {
        slideXpoin = currentXpoint + 294;
    }
    
    [UIView beginAnimations:@"loops" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3f];
    [signerShowScrollView setContentOffset:CGPointMake(slideXpoin, 0)];
    currentXpoint = signerShowScrollView.contentOffset.x;
    [UIView commitAnimations];
}

- (void)gotoFriend:(UIButton *)button
{
    
}

- (void)gotoBarEnvironment:(UIButton *)button
{
    MBarEnvironmentVC *barEnvironmentVC = [[MBarEnvironmentVC alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/restful/pub/picture?pub_id=%d",MM_URL, button.tag];
    [barEnvironmentVC initWithRequestByUrl:url];
    
    [self.navigationController pushViewController:barEnvironmentVC animated:YES];
}

#pragma mark - 
#pragma mark  UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
