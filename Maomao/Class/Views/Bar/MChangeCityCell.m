//
//  MChangeCityCell.m
//  Maomao
//
//  Created by maochengfang on 14-1-7.
//  Copyright (c) 2014年 BangQu. All rights reserved.
//

#import "MChangeCityCell.h"

@implementation MChangeCityCell

@synthesize cityName;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setCellInfoWithModel:(MCityModel *)model
{
    cityName.text = model.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
