//
//  MInviteCell.m
//  Maomao
//
//  Created by maochengfang on 13-12-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MInviteCell.h"
#import "UIImageView+WebCache.h"

@implementation MInviteCell
@synthesize senderIcon;
@synthesize senderNameLabel;
@synthesize senderTimeLabel;

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

- (void)setCellInfoWithModel:(MInvitationModel *)model
{
    senderNameLabel.text = model.time;
    senderNameLabel.text = model.nick_name;
    [senderIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MM_URL,model.pic_path]] placeholderImage:[UIImage imageNamed:@"invite_img.png"]];
    

    
}

@end
