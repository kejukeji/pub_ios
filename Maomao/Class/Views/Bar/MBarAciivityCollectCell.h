//
//  MBarAciivityCollectCell.h
//  Maomao
//
//  Created by maochengfang on 13-12-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MActivityCollectModel.h"

@interface MBarAciivityCollectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *activityImg;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityStartTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityCollectTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *activityMarkBtn;

- (IBAction)activityMark:(UIButton *)sender;

- (void)setCellInfoWithModel:(MActivityCollectModel *)model;
@end
