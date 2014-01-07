//
//  MChangeCountyCell.h
//  Maomao
//
//  Created by maochengfang on 14-1-6.
//  Copyright (c) 2014年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCountyModel.h"

@interface MChangeCountyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)setCellInfoWithModel:(MCountyModel *)model;

@end
