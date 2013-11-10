//
//  MBarDetailsVC.h
//  Maomao
//
//  Created by  zhao on 13-10-17.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "GPPrompting.h"

@interface MBarDetailsVC : UIViewController
{
    MBProgressHUD      *hud;
    GPPrompting        *prompting;
    NSMutableArray     *signaSources;
    BOOL                isNetWork;
}

@property (weak, nonatomic) IBOutlet UIButton       *barIconBtn;
@property (weak, nonatomic) IBOutlet UILabel        *barNameLabel;
@property (weak, nonatomic) IBOutlet UILabel        *signaNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel        *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel        *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel        *barTypeLabel;
@property (weak, nonatomic) IBOutlet UITextView     *barIntroTextView;
@property (weak, nonatomic) IBOutlet UIScrollView   *signerShowScrollView;

@property (nonatomic, strong) ASIHTTPRequest        *sendRequest;

- (void)initWithRequestByUrl:(NSString *)urlString;
- (IBAction)slideSignerShowView:(UIButton *)sender;

@end
