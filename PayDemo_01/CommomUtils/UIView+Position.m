//
//  UIView+Position.m
//  YueBeautify
//
//  Created by majinyu on 16/7/15.
//  Copyright © 2016年 com.bm.hb. All rights reserved.
//

#import "UIView+Position.h"

@implementation UIView (Position)

#pragma mark - 坐标信息

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)newOrigin {
    self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)rx {
    return self.frame.origin.x;
}

- (void)setRx:(CGFloat)newX {
    self.frame = CGRectMake(newX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)ry {
    return self.frame.origin.y;
}

- (void)setRy:(CGFloat)newY {
    self.frame = CGRectMake(self.frame.origin.x, newY, self.frame.size.width, self.frame.size.height);
}

#pragma mark - 宽高信息

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)newSize {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newSize.width, newSize.height);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newWidth {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newWidth, self.frame.size.height);
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)newHeight {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newHeight);
}



#pragma mark - 上下左右

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)newTop {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.size.height - newTop, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)newBottom {
    self.frame = CGRectMake(self.frame.origin.x, newBottom - self.frame.size.height, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)newLeft {
    self.frame = CGRectMake(newLeft, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)newRight {
    self.frame = CGRectMake(newRight - self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}



#pragma mark - 公共方法

- (void)addCenteredSubview:(UIView *)subview {
    subview.rx = (int)((self.bounds.size.width - subview.frame.size.width) / 2);
    subview.ry = (int)((self.bounds.size.height - subview.frame.size.height) / 2);
    [self addSubview:subview];
}

- (void)moveToCenterOfSuperview {
    if (!self.superview)
        NSLog(@"Trying to move view inside superview before attaching. Expect weird stuff.");
    
    self.rx = (int)((self.superview.bounds.size.width - self.frame.size.width) / 2);
    self.ry = (int)((self.superview.bounds.size.height - self.frame.size.height) / 2);
}

- (void)centerVerticallyInSuperview
{
    if (!self.superview)
        NSLog(@"Trying to move view inside superview before attaching. Expect weird stuff.");
    
    self.ry = (int)((self.superview.bounds.size.height - self.frame.size.height) / 2);
}

- (void)centerHorizontallyInSuperview
{
    if (!self.superview)
        NSLog(@"Trying to move view inside superview before attaching. Expect weird stuff.");
    
    self.rx = (int)((self.superview.bounds.size.width - self.frame.size.width) / 2);
}



@end


@implementation UIView (Utils)

+ (instancetype)loadNib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

@end
