//
//  MFreindGiftView.m
//  Maomao
//
//  Created by maochengfang on 14-1-2.
//  Copyright (c) 2014年 BangQu. All rights reserved.
//


#import "Utils.h"
#import "JSON.h"
#import "MGiftModel.h"
#import "UIImageView+WebCache.h"
#import "MFriendGiftView.h"

@implementation MFriendGiftView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        giftItemSource = [NSMutableArray arrayWithCapacity:0];
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
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
    
    UIScrollView    *scrollow = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 416 + (iPhone5?88:0))];
    [scrollow setShowsHorizontalScrollIndicator:NO];
    [self addSubview:scrollow];
    
    for (int i = 0; i < count; i++) {
        MGiftModel *model = [giftItemSource objectAtIndex:i];
        NSLog(@"model items = %@",model.pic_path);
        switch (i % 7) {
            case 0:
                xPoint = 20.0f;
                (i == 0)?(row = 0):(row++);
                break;
            case 1:
                xPoint = 20.0f + 40.0f;
                break;
            case 2:
                xPoint = 20.0f + 2 * 40.0f;
                break;
            case 3:
                xPoint = 20.0f + 3 * 40.0f;
                break;
            case 4:
                xPoint = 20.0f + 4 * 40.0f;
                break;
            case 5:
                xPoint = 20.0f + 5 * 40.0f;
                break;
            case 6:
                xPoint = 20.0f + 6 * 40.0f;
            default:
                break;
        }
        
        if (row >= 1) {
            NSString *imgUrl = [NSString stringWithFormat:@"%@%@", MM_URL,model.gift_pic_path];
            UIImageView *giftImg = [[UIImageView alloc] init];
            [giftImg setImageWithURL:[NSURL URLWithString: imgUrl] placeholderImage:[UIImage imageNamed:@""]];
            [giftImg setFrame:CGRectMake(xPoint, (row*35)+20, 30, 30)];
            
            UILabel *giftName = [[UILabel alloc] init];
            [giftName setFrame:CGRectMake(giftImg.frame.origin.x, giftImg.frame.origin.y + giftImg.frame.size.height, 40, 15)];
            [giftName setText:model.gift_name];
            [giftName setFont:[UIFont systemFontOfSize:12]];
            [giftName setTextAlignment:NSTextAlignmentCenter];
            [giftName setTextColor:[UIColor blackColor]];
            
            [self addSubview:giftImg];
            [self addSubview:giftName];
            
            if ([giftItemSource count] > 14)
            {
                [scrollow addSubview:giftImg];
                [scrollow addSubview:giftName];
            }
           
        }
        else
        {
            NSString *imgUrl = [NSString stringWithFormat:@"%@%@", MM_URL,model.gift_pic_path];
            UIImageView *giftImg = [[UIImageView alloc] init];
            [giftImg setImageWithURL:[NSURL URLWithString: imgUrl] placeholderImage:[UIImage imageNamed:@""]];
            [giftImg setFrame:CGRectMake(xPoint, (row*35), 30, 30)];
            
            UILabel *giftName = [[UILabel alloc] init];
            [giftName setFrame:CGRectMake(giftImg.frame.origin.x, giftImg.frame.origin.y + giftImg.frame.size.height, 30, 15)];
            [giftName setText:model.gift_name];
            [giftName setFont:[UIFont systemFontOfSize:12]];
            [giftName setTextAlignment:NSTextAlignmentCenter];
            [giftName setTextColor:[UIColor blackColor]];
            [self addSubview:giftImg];
            [self addSubview:giftName];
        }
        
    }
    
//    if ((!iPhone5 && row > 5) || (iPhone5 && row > 6))
//    {
//        [scrollow setContentSize:CGSizeMake(320, 15 + (row * 50))];
//    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
