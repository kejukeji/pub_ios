//
//  MConfig.h
//  Maomao
//
//  Created by  zhao on 13-10-17.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#ifndef Maomao_MConfig_h
#define Maomao_MConfig_h

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define noiOS7 ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)?YES:NO)

#endif

