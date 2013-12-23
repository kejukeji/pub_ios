//
//  MInviteCell.h
//  Maomao
//
//  Created by maochengfang on 13-12-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MInvitationModel.h"

@interface MInviteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *senderIcon;
@property (weak, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderTimeLabel;
- (void)setCellInfoWithModel:(MInvitationModel *)model;

@end
