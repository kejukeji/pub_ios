//
//  MMFriendGiftVC.h
//  Maomao
//
//  Created by maochengfang on 14-1-18.
//  Copyright (c) 2014年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface MMFriendGiftVC : UIViewController<ASIHTTPRequestDelegate>
{
    BOOL    isNetWork;
    NSMutableArray  *giftItemSource;
    UIScrollView    *scrollow;
}

@property (nonatomic, strong) ASIHTTPRequest    *sendGiftRequest1;

- (void)initWithRequestByUrl:(NSString *)urlString;
@end
