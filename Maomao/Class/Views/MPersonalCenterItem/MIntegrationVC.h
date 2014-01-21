//
//  MIntegrationVC.h
//  Maomao
//
//  Created by maochengfang on 13-12-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTitleView.h"
#import "MBackBtn.h"
#import "ASIHTTPRequest.h"
#import "GPPrompting.h"
#import "Utils.h"


@interface MIntegrationVC : UIViewController <ASIHTTPRequestDelegate>
{
    UIScrollView    *integrationScrollView;
    
}
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
@property (weak, nonatomic) IBOutlet UILabel *reputationLabel;

@property (weak, nonatomic) IBOutlet UIImageView *levelImg;
@property (weak, nonatomic) IBOutlet UILabel *reputation_DiffeLabel;


@property (nonatomic, strong) ASIHTTPRequest    *sendRequest;

- (void)initRequestWithUrl:(NSString *)urlString;

@end
