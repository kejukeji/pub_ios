//
//  MSendGiftModel.h
//  Maomao
//  朋友中心发送礼物模型
//  Created by maochengfang on 13-12-25.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSendGiftModel : NSObject

@property (nonatomic, copy)     NSString    *base_path;
@property (nonatomic, assign)   NSInteger   cost;
@property (nonatomic, assign)   NSInteger   gift_id;
@property (nonatomic, copy)     NSString    *name;
@property (nonatomic, copy)     NSString    *pic_name;
@property (nonatomic, copy)     NSString    *pic_path;
@property (nonatomic, copy)     NSString    *rel_path;
@property (nonatomic, assign)   BOOL        status;
@property (nonatomic, copy)     NSString    *words;

@end
