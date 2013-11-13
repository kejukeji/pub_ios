//
//  MMyHomeView.h
//  Maomao
//
//  Created by  zhao on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

@protocol MMyHomeViewDelegate <NSObject>

- (void)myHomeLeftSlider;

@end

#import <UIKit/UIKit.h>

@interface MMyHomeView : UIView

@property (nonatomic, assign) id<MMyHomeViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (IBAction)gotoSettingUserInfo:(UIButton *)sender;
- (IBAction)gotoMyCollect:(UIButton *)sender;
- (IBAction)gotoMyMessage:(UIButton *)sender;


@end
