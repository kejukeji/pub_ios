//
//  MMFriendGiftVC.m
//  Maomao
//
//  Created by maochengfang on 14-1-18.
//  Copyright (c) 2014年 BangQu. All rights reserved.
//

#import "Utils.h"
#import "JSON.h"
#import "MBackBtn.h"
#import "MTitleView.h"
#import "MGiftModel.h"
#import "UIImageView+WebCache.h"
#import "MMFriendGiftVC.h"

@interface MMFriendGiftVC ()

@end

@implementation MMFriendGiftVC
@synthesize sendGiftRequest1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        giftItemSource =  [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}
- (void)viewDidLoad
{
    MTitleView *titleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleView.titleName.text = @"收到的礼物";
    self.navigationItem.titleView = titleView;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
   
    
    if (!noiOS7) {
        for (UIView *view in self.view.subviews) {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
        }
    }

}


- (void) back
{
    [sendGiftRequest1 clearDelegatesAndCancel];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark - Get Gift Items Method

- (void)initWithRequestByUrl:(NSString *)urlString
{
    //    isNetWork = [Utils checkCurrentNetWork];
    if (self.sendGiftRequest1 != nil) {
        [self.sendGiftRequest1 clearDelegatesAndCancel];
        self.sendGiftRequest1 = nil;
    }
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.sendGiftRequest1 = [ASIHTTPRequest requestWithURL:url];
    [self.sendGiftRequest1 setTimeOutSeconds:kRequestTime];
    [self.sendGiftRequest1 setDelegate:self];
    [self.sendGiftRequest1 startSynchronous];
    
}

#pragma  mark -
#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSString *response = [request responseString];
    
    if (response == nil || [response JSONValue] == nil) {
        return;
    }
    
    NSDictionary *responseDict = [response JSONValue];
    
    NSInteger    status = [[responseDict objectForKey:@"status"] integerValue];
    NSArray     *giftList = [responseDict objectForKey:@"gift"];
    
    if (status == 0) {
        for (NSDictionary *dict in giftList)
        {
            {
                MGiftModel *model = [[MGiftModel alloc] init];
                
                model.gift_id =  [[dict objectForKey:@"gift_id"] integerValue];
                model.gift_id_id = [[dict objectForKey:@"id"] integerValue];
                model.nick_name = [dict objectForKey:@"nick_name"];
                model.pic_path  = [dict objectForKey:@"pic_path"];
                model.gift_name = [dict objectForKey:@"gift_name"];
                model.gift_pic_path = [dict  objectForKey:@"gift_pic_path"];
                model.receiver_id = [[dict objectForKey:@"receiver_id"] integerValue];
                model.sender_id = [[dict objectForKey:@"sender_id"] integerValue];
                model.time = [dict objectForKey:@"time"];
                model.words  = [dict objectForKey:@"words"];
                NSLog(@"gift_name == %@",model.gift_name);
                [giftItemSource addObject:model];
              
                
            }
        }
        [self setGift];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                       message:@"网络无法连接,请检查网络连接!"
                                                      delegate:self
                                             cancelButtonTitle:@"知道了"
                                             otherButtonTitles:nil];
    [alertView show];
}

- (void)setGift
{
    NSLog(@" gift count == %d", [giftItemSource count]);
    
    NSInteger   count = [giftItemSource count];
    
    NSInteger   row = 0;
    float      xPoint;
    
    scrollow = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 416 + (iPhone5?88:0))];
    [scrollow setShowsHorizontalScrollIndicator:NO];
    
    
    for (int i = 0; i < count; i++) {
        MGiftModel *model = [giftItemSource objectAtIndex:i];
        NSLog(@"model items = %@",model.pic_path);
        switch (i % 4) {
            case 0:
                xPoint = 20.0f;
                (i == 0)?(row = 0):(row++);
                break;
            case 1:
                xPoint = 20.0f + 70.0f;
                break;
            case 2:
                xPoint = 20.0f + 2 * 70.0f;
                break;
            case 3:
                xPoint = 20.0f + 3 * 70.0f;
                break;
            default:
                break;
        }
        
        NSString *imgUrl = [NSString stringWithFormat:@"%@%@", MM_URL,model.gift_pic_path];
        UIImageView *giftImg = [[UIImageView alloc] init];
        [giftImg setImageWithURL:[NSURL URLWithString: imgUrl] placeholderImage:[UIImage imageNamed:@""]];
        
        [giftImg setFrame:CGRectMake(xPoint, (row*70) + 20 *row, 70, 70)];//+20
        
        
        UILabel *giftName = [[UILabel alloc] init];
        [giftName setFrame:CGRectMake(giftImg.frame.origin.x, giftImg.frame.origin.y + giftImg.frame.size.height, 70,15)];
        [giftName setText:model.gift_name];
        [giftName setFont:[UIFont systemFontOfSize:12]];
        [giftName setTextAlignment:NSTextAlignmentCenter];
        [giftName setTextColor:[UIColor blackColor]];
        
        [scrollow setContentSize:CGSizeMake(320, 30*(count))];
        
        [scrollow addSubview:giftImg];
        [scrollow addSubview:giftName];
        
        [self.view addSubview:scrollow];
        
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
