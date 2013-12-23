//
//  MTeaserCell.m
//  Maomao
//
//  Created by maochengfang on 13-12-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MTeaserCell.h"
#import "UIImageView+WebCache.h"

@implementation MTeaserCell
@synthesize senderIcon;
@synthesize senderNameLabel;
@synthesize sendtimeLabel;

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

- (void)setCellInfo:(MGreetingModel *)model
{
    sendtimeLabel.text = model.time;
    senderNameLabel.text = model.nick_name;
    
    [senderIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MM_URL,model.pic_path]] placeholderImage:[UIImage imageNamed:@"invite_img.png"]];
}
@end
