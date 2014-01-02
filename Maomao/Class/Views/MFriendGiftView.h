//
//  MFreindGiftView.h
//  Maomao
//
//  Created by maochengfang on 14-1-2.
//  Copyright (c) 2014年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
@interface MFriendGiftView : UIView<ASIHTTPRequestDelegate>
{
    BOOL    isNetWork;
    NSMutableArray  *giftItemSource;
}

@property (nonatomic, strong) ASIHTTPRequest    *sendGiftRequest1;

- (void)initWithRequestByUrl:(NSString *)urlString;
@end
