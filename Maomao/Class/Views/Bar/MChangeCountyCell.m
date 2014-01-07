//
//  MChangeCountyCell.m
//  Maomao
//
//  Created by maochengfang on 14-1-6.
//  Copyright (c) 2014年 BangQu. All rights reserved.
//

#import "MChangeCountyCell.h"

@implementation MChangeCountyCell
@synthesize nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellInfoWithModel:(MCountyModel *)model
{
    nameLabel.text = model.name;
}

@end
