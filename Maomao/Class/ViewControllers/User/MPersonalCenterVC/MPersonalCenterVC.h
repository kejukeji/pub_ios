//
//  MPersonalCenterVC.h
//  Maomao
//
//  Created by maochengfang on 13-12-3.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

@protocol MPersonalCenterDelegate <NSObject>

- (void)personalCenterLeftSlider;
- (void)mPersonalCenterGotoNext:(NSInteger)number;
- (void)gotoCredictVC:(NSString *)credit getValue2:(NSString *) reputation;

@end

#import <UIKit/UIKit.h>
#import "MMyCollectVC.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"   
#import "GPPrompting.h"

@interface MPersonalCenterVC : UIViewController<MMyCollectDelegate,ASIHTTPRequestDelegate>
{
    MBProgressHUD       *hud;
    GPPrompting         *prompting;
    BOOL                isNetWork;
    UIScrollView        *personalCenterScrollView;
    
}
@property(nonatomic,assign) id <MPersonalCenterDelegate> delegate;

@property (nonatomic, strong) ASIHTTPRequest    *sendRequest;

@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel1;

@property (weak, nonatomic) IBOutlet UIImageView *Icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *signalLabel;

@property (weak, nonatomic) IBOutlet UIImageView *genderIcon;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

/*********积分、等级、等级表述、经验值******/

@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
@property (weak, nonatomic) IBOutlet UILabel *level_descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *reputationLable;
@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;

/********************邀约，礼物，传情，私信,我的收藏，我的活动count**************/

@property (weak, nonatomic) IBOutlet UILabel *invitationLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftLable;
@property (weak, nonatomic) IBOutlet UILabel *greeting_countLabel;
@property (weak, nonatomic) IBOutlet UILabel *private_letter_countLable;
@property (weak, nonatomic) IBOutlet UILabel *collect_activity_countLable;
@property (weak, nonatomic) IBOutlet UILabel *collect_pub_countLabel;

@property (weak, nonatomic) IBOutlet UIImageView *inviteNotice;

@property (weak, nonatomic) IBOutlet UIImageView *giftNotice;


@property (weak, nonatomic) IBOutlet UIImageView *teaserNotice;

@property (weak, nonatomic) IBOutlet UIImageView *privateMsgNotice;


//Button Action

- (IBAction)gotoNextVC:(UIButton *)sender;

- (IBAction)gotoCreditVC:(UIButton *)sender;

/***************************************************/

@end
