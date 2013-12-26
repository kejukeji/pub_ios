//
//  MBarAciivityCollectCell.m
//  Maomao
//
//  Created by maochengfang on 13-12-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MBarAciivityCollectCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@implementation MBarAciivityCollectCell
@synthesize activityImg;
@synthesize activityTitleLabel;
@synthesize activityStartTimeLabel;
@synthesize activityCollectTimeLabel;
@synthesize activityMarkBtn;

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

- (void)setCellInfoWithModel:(MActivityCollectModel *)model
{
    [activityImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MM_URL,model.pic_path]] placeholderImage:[UIImage imageNamed:@"common_img_default.png"]];
    
    [activityTitleLabel setText:[NSString stringWithFormat:@"活动标题:%@",model.title]];
    [activityStartTimeLabel setText:model.start_date];
    [activityCollectTimeLabel setText:model.collect_time];
    [activityMarkBtn setImage:[UIImage imageNamed:@"activity_collect_btn_hook.png"] forState:UIControlStateNormal];
   
    
}
- (IBAction)activityMark:(UIButton *)sender {
    [sender setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
}
@end
