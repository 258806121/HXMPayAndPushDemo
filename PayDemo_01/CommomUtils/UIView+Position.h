//
//  UIView+Position.h
//  YueBeautify
//
//  Created by majinyu on 16/7/15.
//  Copyright © 2016年 com.bm.hb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Position)

// 起始坐标点 x and y
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat rx;
@property (nonatomic) CGFloat ry;

// 宽高
@property (nonatomic) CGSize  size;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

// 上下左右的数值
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;

// Methods for centering.
- (void)addCenteredSubview:(UIView *)subview;
- (void)moveToCenterOfSuperview;
- (void)centerVerticallyInSuperview;
- (void)centerHorizontallyInSuperview;

@end


@interface UIView (Utils)

+ (instancetype)loadNib;

@end
