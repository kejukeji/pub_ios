//
//  MGiftCell.m
//  Maomao
//
//  Created by maochengfang on 13-12-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MGiftCell.h"

#import "UIImageView+WebCache.h"

@implementation MGiftCell

@synthesize uerIcon;
@synthesize userName;
@synthesize timeLabel;
@synthesize giftImg;
@synthesize giftName;

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

- (void)setCellInfoWithModel:(MGiftModel *)model
{
    [giftImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MM_URL,model.gift_pic_path]] placeholderImage:[UIImage imageNamed:@"common_img_default.png"]];
    [uerIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MM_URL,model.pic_path]] placeholderImage:[UIImage imageNamed:@"common_img_default.png"]];
     
    userName.text = model.nick_name;
    timeLabel.text = model.time;
    giftName.text = model.gift_name;
    
}
@end
