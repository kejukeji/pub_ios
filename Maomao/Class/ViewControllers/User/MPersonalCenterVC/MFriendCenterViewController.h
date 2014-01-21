//
//  MFriendCenterViewController.h
//  Maomao
//
//  Created by maochengfang on 13-12-5.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

@protocol MFriendCenterViewControlDelegate <NSObject>

- (void)friendCenterLeftSlider;
- (void)mFriendCenterVCGotoNext:(NSInteger)number;

@end

#import <UIKit/UIKit.h>
#import "GPPrompting.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "DropDownControllView.h"

@interface MFriendCenterViewController : UIViewController<DropDownControlViewDelegate,ASIHTTPRequestDelegate>
{
    GPPrompting     *prompting;
    BOOL    isNetWork;
    UIScrollView    *friendCenterScrollView;
    
}
@property (nonatomic, assign) id<MFriendCenterViewControlDelegate>delegate;
@property (nonatomic, copy) NSString *friendId;
@property (nonatomic, strong) ASIFormDataRequest *formDataReuqest;
@property (nonatomic, strong) ASIHTTPRequest    *sendGreetingRequest;
@property (nonatomic, strong) ASIHTTPRequest    *
    sendFriendDataRequest;

@property (weak, nonatomic) IBOutlet UILabel *friendAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;

@property (weak, nonatomic) IBOutlet UILabel *reputationLabel;

@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *friendIcon;

@property (weak, nonatomic) IBOutlet UILabel *friendSignLabel;
@property (weak, nonatomic) IBOutlet UILabel *numofGift;
@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;


/*点击礼物按钮酒吧收藏按钮要下滑*/
@property (weak, nonatomic) IBOutlet UIButton *moveFrame1;//按钮
@property (weak, nonatomic) IBOutlet UIImageView *moveFrame2;//箭头
/*****************************/
@property (weak, nonatomic) IBOutlet UIButton *xView;


//Button Action
- (IBAction)gotoClink:(UIButton *)sender;
- (IBAction)haveTeaser:(UIButton *)sender;
- (IBAction)sendGift:(UIButton *)sender;
- (IBAction)sendMsg:(UIButton *)sender;
- (IBAction)showGift:(UIButton *)sender;

- (IBAction)barCollection:(UIButton *)sender;



@end
