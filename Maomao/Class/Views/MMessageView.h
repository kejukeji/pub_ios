//
//  MMessageView.h
//  Maomao
//
//  Created by  zhao on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//
@protocol MMessageViewDelegate <NSObject>

- (void)messageLeftSlider;
- (void)gotoMessageDetails:(NSInteger)number;

@end

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface MMessageView : UIView <ASIHTTPRequestDelegate>

@property (nonatomic, strong) ASIHTTPRequest    *sendRequest;
@property (nonatomic, assign) id<MMessageViewDelegate> delegate;

@end
