//
//  MMBarSoundAndShockVC.h
//  Maomao
//
//  Created by maochengfang on 13-10-29.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSoundAndShockVC : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *firstHook;
@property (weak, nonatomic) IBOutlet UIImageView *secondHook;
@property (weak, nonatomic) IBOutlet UIImageView *thirdHook;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;

@property (weak, nonatomic) IBOutlet UIButton *fourthBtn;


- (IBAction)silentNotice:(id)sender;

- (IBAction)acceptMsg:(UIButton *)sender;

- (IBAction)noticeShock:(UIButton *)sender;

- (IBAction)pushRingBtn:(id)sender;

@end
