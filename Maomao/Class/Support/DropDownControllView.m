//
//  DropDownControllView.m
//  DropDownMenu
//
//  Created by maochengfang on 13-12-2.
//  Copyright (c) 2013年 maochengfang. All rights reserved.
//

#import "DropDownControllView.h"
#import <QuartzCore/QuartzCore.h>

#define kOptionHeight 20
#define kOptionSpacing 1
#define kAnimationDuration 0.2

@implementation DropDownControllView
{
    CGRect mBaseFrame;
    
    //配置
    NSArray *mSelectionOptions, *mSelectionTitles;
    
    //子视图
    UILabel *mTitleLabel;
    UIImage *mBgImage;
    NSMutableArray  *mSelectionCells;
    
    //配置状态
    BOOL        mControlIsActive;
    NSInteger   mSelectionIndex;
    NSInteger   mPreviousSelectionIndex;
    
}

#pragma mark - Object Life Cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        mBaseFrame = frame;
        
        //背景
        mBgImage = [[UIImage imageNamed:@"dropdown_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        UIImageView *backGroundView = [[UIImageView alloc] initWithImage:mBgImage];
        backGroundView.frame = self.bounds;
        [self addSubview:backGroundView];
        
        //标题
        mTitleLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 5, 0)];
        mTitleLabel.textAlignment = NSTextAlignmentCenter;
        mTitleLabel.textColor = [UIColor whiteColor];
        mTitleLabel.backgroundColor = [UIColor clearColor];
        mTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:mTitleLabel];
    }
    return self;
}

#pragma mark - Accessors

- (void)setTitle:(NSString *)title
{
    _title = title;
    mTitleLabel.text = title;
}

#pragma mark - Configuration

- (void)setSelectionOptions:(NSArray *)selectionOptions withTitles :(NSArray *)selectionOptionTitles {
    if ([selectionOptions count] != [selectionOptionTitles count]) {
        [NSException raise:NSInternalInconsistencyException format:@"selectionOptions and selectionOptionTitles must contain the same number of objects"];
    }
    mSelectionOptions = selectionOptions;
    mSelectionTitles  = selectionOptionTitles;
    NSLog(@" mSelectionOptions ==%@",mSelectionOptions);
    mSelectionCells   = nil;
}

//重写上述方法
- (void)setSelectionTitles:(NSArray *) selectionOptionTitles
{
    mSelectionTitles  = selectionOptionTitles;
    mSelectionCells   = nil;
}

#pragma mark - Touch Handling 

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] != 1) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    if (CGRectContainsPoint(self.bounds, [touch locationInView:self])) {
        [self activateControl];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] != 1) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    //计算选择引用
    CGPoint location = [touch locationInView:self];
    if ((CGRectContainsPoint(self.bounds, location))&&(location.y > mBaseFrame.size.height)) {
        mSelectionIndex = (location.y - mBaseFrame.size.height - kOptionSpacing)/(kOptionHeight + kOptionSpacing);
    }
    else
    {
        mSelectionIndex = NSNotFound;
    }
    
    if (mSelectionIndex == mPreviousSelectionIndex) {
        return;
    }
    
    //选择动画
    if (mSelectionIndex != NSNotFound) {
        UIView *cell = [mSelectionCells  objectAtIndex:mSelectionIndex];
        [UIView animateWithDuration:kAnimationDuration animations:^{
            cell.frame = CGRectInset(cell.frame, -6, 0);
        }];
    }
    
    if (mPreviousSelectionIndex != NSNotFound) {
        UIView *cell = [mSelectionCells objectAtIndex:mPreviousSelectionIndex];
        [UIView animateWithDuration:kAnimationDuration animations:^{
            cell.frame = CGRectInset(cell.frame, 6, 0);
        }];
    }
    mPreviousSelectionIndex = mSelectionIndex;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (mControlIsActive)
    {
        [self inactivateControl];
    
    if (mSelectionIndex < [mSelectionOptions count]) {//[mSelectionOptions count]下拉列表长度
        [self.delegate dropDownControlView:self didFinishWithSelection:[mSelectionOptions   objectAtIndex:mSelectionIndex]];
        NSLog(@"mSelectionOptions = %@",[mSelectionOptions   objectAtIndex:mSelectionIndex]);
        
    }
    else{
        [self.delegate dropDownControlView:self didFinishWithSelection:nil];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (mControlIsActive) {
        [self inactivateControl];
    }
}

#pragma mark - View Transformation

- (CATransform3D)contractedTrasorm
{
    CATransform3D t = CATransform3DIdentity;
    t = CATransform3DRotate(t, M_PI / 2, 1, 0, 0);
    t.m34 = -1.0/5.0;
    return t;
}
#pragma mark - Control Activation / Deactivation

- (void)activateControl
{
    mControlIsActive = YES;
    
    mSelectionIndex = NSNotFound;
    mPreviousSelectionIndex = NSNotFound;
    
    if ([self.delegate respondsToSelector:@selector(dropDownControlViewWillBecomeActive:)]) {
        [self.delegate dropDownControlViewWillBecomeActive:self];
    }
    //预备选择的cell
    if (mSelectionCells == nil) {
        mSelectionCells = [NSMutableArray arrayWithCapacity:0];
        for (int i =0; i < [mSelectionTitles count]; i++) {
            UIImageView *newCell = [[UIImageView alloc] initWithImage:mBgImage];
            
            newCell.frame = CGRectMake(0, mBaseFrame.size.height + (i * kOptionHeight + kOptionSpacing) + kOptionSpacing, mBaseFrame.size.width,kOptionHeight);
            
            newCell.layer.anchorPoint = CGPointMake(0.5, 0.0);
            newCell.layer.transform = [self contractedTrasorm];
            
            // newcell.alph = 0;
            UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectInset(newCell.bounds, 10, 0)];
            newLabel.font = [UIFont systemFontOfSize:14];
            newLabel.backgroundColor = [UIColor clearColor];
            newLabel.textColor = [UIColor whiteColor];
            newLabel.text = [mSelectionTitles objectAtIndex:i];
            NSLog(@"newLabel.text== %@",newLabel.text);
            [newCell addSubview:newLabel];
            [self addSubview:newCell];
            [mSelectionCells addObject:newCell];
        }
    }
    //拓展框架
    CGRect newFrame = mBaseFrame;
    newFrame.size.height += [mSelectionOptions count]*(kOptionHeight + kOptionSpacing);
    self.frame = newFrame;
    
    //显示选择cell动画
    
    int count = [mSelectionCells count];
    for (int i = 0; i < count; i++) {
        UIView *cell = [mSelectionCells objectAtIndex:i];
        cell.alpha = 1.0;
        
        [UIView animateWithDuration:kAnimationDuration delay:(i*kAnimationDuration / count) options:0 animations:^{
            CGRect destinationFrame = CGRectMake(0, mBaseFrame.size.height + i * (kOptionHeight + kOptionSpacing) + kOptionSpacing, mBaseFrame.size.width, kOptionHeight);
            cell.frame = destinationFrame;
            cell.layer.transform = CATransform3DIdentity;

        }completion:nil];
    }
    
}

- (void)inactivateControl
{
    mControlIsActive = NO;
    
    [self.delegate dropDownControlView:self didFinishWithSelection:nil];
    
    int count = [mSelectionCells count];
    
    for (int i = count -1; i >=0; i--) {
        UIView * cell = [mSelectionCells objectAtIndex:i];
        [UIView animateWithDuration:kAnimationDuration delay:((count - 1 -i)*kAnimationDuration / count) options:0 animations:^{
            cell.frame = CGRectMake(0, mBaseFrame.size.height+
            (i *kOptionHeight + kOptionSpacing)+kOptionSpacing, mBaseFrame.size.width, mBaseFrame.size.height);
        } completion:^(BOOL completed){
            cell.alpha = 0;
            if (i ==0) {
                self.frame = mBaseFrame;
            }
        }];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
