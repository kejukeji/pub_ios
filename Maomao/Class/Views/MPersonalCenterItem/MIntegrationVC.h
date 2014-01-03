//
//  MIntegrationVC.h
//  Maomao
//
//  Created by maochengfang on 13-12-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTitleView.h"
#import "MBackBtn.h"

@interface MIntegrationVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
@property (weak, nonatomic) IBOutlet UILabel *reputationLabel;

@property (nonatomic, copy) NSString   *credit;
@property (nonatomic, copy) NSString
    *reputation;
@end
