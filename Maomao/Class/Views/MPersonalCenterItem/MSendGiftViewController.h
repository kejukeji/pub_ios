//
//  MSendGiftViewController.h
//  Maomao
//
//  Created by maochengfang on 13-12-26.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTitleView.h"
#import "MBackBtn.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "GPPrompting.h"

@interface MSendGiftViewController : UIViewController<ASIHTTPRequestDelegate>
{
    MBProgressHUD       *hud;
    GPPrompting         *prompting;
    NSMutableArray      *giftItemSource;
    BOOL                isNetWork;
}

//请求获取礼物item
@property (nonatomic, copy) ASIHTTPRequest      *sendGiftItemRequest;
//请求发送礼物
@property (nonatomic, copy) ASIHTTPRequest      *sendGiftRequest;

@property (nonatomic, strong) NSString         *receiverID;
- (void)initWithRequestByUrl:(NSString *)urlString;

@end
