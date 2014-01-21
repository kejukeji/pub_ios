//
//  MBarCollectCell.m
//  Maomao
//
//  Created by maochengfang on 13-10-18.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MBarCollectCell.h"
#import "UIImageView+WebCache.h"
#import <MapKit/MapKit.h>

@implementation MBarCollectCell

@synthesize barIconImg;
@synthesize barNameLabel;
@synthesize distanceLabel;
@synthesize collectTimeLabel;
@synthesize selectFrame;
@synthesize deleteBtn;

@synthesize isSelect;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //setting_img_selectFrame.png setting_img_blueHook.png
       
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
//    selectFrame.hidden = YES;
//    deleteBtn.hidden = YES;
        // Configure the view for the selected state
}

- (IBAction)deleteCellBtn:(UIButton *)sender
{
    [sender setImage:[UIImage imageNamed:@"setting_img_blueHook.png"] forState:UIControlStateNormal];
}


- (void)setCellInfoWithModel:(MBarCollectModel *)model
{
    
    [barIconImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MM_URL, model.pic_path]] placeholderImage:[UIImage imageNamed:@"common_img_default.png"]];
    [barNameLabel setText:model.name];
    
    //计算距离
    double locationLongitude = [[[NSUserDefaults standardUserDefaults] stringForKey:LONGITUDE] doubleValue];
    double locationLatitude = [[[NSUserDefaults standardUserDefaults] stringForKey:LATITUDE] doubleValue];
    
    double longitude = [model.longitude doubleValue];
    double latitude = [model.latitude doubleValue];
    
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:locationLatitude longitude:locationLongitude];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    distanceLabel.text = [NSString stringWithFormat:@"%0.1f km",[newLocation distanceFromLocation :currentLocation]/1000];
    
    collectTimeLabel.text = [NSString stringWithFormat:@"收藏时间: %@",model.difference];
    
    
}

@end
