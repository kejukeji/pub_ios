//
//  MMainVC.h
//  Maomao
//
//  Created by  zhao on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTouchSuperView.h"
#import "MMyHomeView.h"
#import "MHomeView.h"
#import "MCollectView.h"
#import "MMessageView.h"
#import "MSettingView.h"
#import "MLeftMenuView.h"

@interface MMainVC : UIViewController <MLetMenuViewDelegate, MHomeViewDelegate>
{
    IBOutlet MLeftMenuView *leftMenuNib;
}

@property (nonatomic, strong) MTouchSuperView   *touchView;
@property (nonatomic, strong) MMyHomeView       *myHomeView;
@property (nonatomic, strong) MHomeView         *homeView;
@property (nonatomic, strong) MCollectView      *collectView;
@property (nonatomic, strong) MMessageView      *messageView;
@property (nonatomic, strong) MSettingView      *settingView;
@property (nonatomic, strong) MLeftMenuView     *leftMenuView;

@end
