//
//  MHomeView.h
//  Maomao
//
//  Created by  zhao on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

@protocol MHomeViewDelegate <NSObject>

- (void)leftSlider;
- (void)gotoBarListVC;

@end
#import <UIKit/UIKit.h>

@interface MHomeView : UIView

@property (nonatomic, assign) id<MHomeViewDelegate> delegate;

@end
