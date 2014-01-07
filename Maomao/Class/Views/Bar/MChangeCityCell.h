//
//  MChangeCityCell.h
//  Maomao
//
//  Created by maochengfang on 14-1-7.
//  Copyright (c) 2014年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCityModel.h"

@interface MChangeCityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cityName;

-  (void)setCellInfoWithModel:(MCityModel *)model;

@end
