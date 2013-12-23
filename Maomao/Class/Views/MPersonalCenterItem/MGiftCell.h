//
//  MGiftCell.h
//  Maomao
//
//  Created by maochengfang on 13-12-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGiftModel.h"

@interface MGiftCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *uerIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *giftImg;
@property (weak, nonatomic) IBOutlet UILabel *giftName;

- (void)setCellInfo:(MGiftModel *)model;
@end
