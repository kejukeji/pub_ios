//
//  MLoginVC.h
//  Maomao
//
//  Created by  zhao on 13-10-17.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"


@interface MLoginVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField     *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField     *passwdTF;

@property (nonatomic,strong) ASIFormDataRequest      *formDataRequest;
@property (nonatomic, strong) UINavigationController *navigat;

- (IBAction)loginAccount:(UIButton *)sender;


@end
