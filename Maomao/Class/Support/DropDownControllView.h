//
//  DropDownControllView.h
//  DropDownMenu
//
//  Created by maochengfang on 13-12-2.
//  Copyright (c) 2013年 maochengfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropDownControllView;

@protocol DropDownControlViewDelegate <NSObject>

//选择器包含用户所选的选项 ，如果没选任何东西那就为空
- (void)dropDownControlView:(DropDownControllView *)view
     didFinishWithSelection:(id)selection;
@optional

- (void)dropDownControlViewWillBecomeActive:
(DropDownControllView *)view;

@end


@interface DropDownControllView : UIView

@property (nonatomic) NSString *title;
@property (nonatomic, weak) id<DropDownControlViewDelegate> delegate;

- (void)setSelectionOptions:(NSArray *)selectionOptions withTitles:(NSArray *)selectionOptionTitles;
- (void)setSelectionTitles:(NSArray *) selectionOptionTitles;

@end
