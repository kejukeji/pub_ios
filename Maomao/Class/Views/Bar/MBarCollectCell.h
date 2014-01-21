//
//  MBarCollectCell.h
//  Maomao
//
//  Created by maochengfang on 13-10-18.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBarCollectModel.h"

@interface MBarCollectCell : UITableViewCell
{
    //BOOL    isSelect;
}

@property (weak, nonatomic) IBOutlet UIImageView *barIconImg;
@property (weak, nonatomic) IBOutlet UILabel *barNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectTimeLabel;

@property (nonatomic, assign)   BOOL    isSelect;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *selectFrame;

- (IBAction)deleteCellBtn:(UIButton *)sender;

- (void)setSelectFrameImg;
- (void)setCellInfoWithModel:(MBarCollectModel *)model;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
