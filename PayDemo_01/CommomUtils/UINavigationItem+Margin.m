//
//  UINavigationItem+Margin.m
//  PeopleSquare
//
//  Created by hb on 16/8/25.
//  Copyright © 2016年 com.majinyu. All rights reserved.
//

#define K_UINavigationItem_Margin -15  //此处修改到边界的距离，请自行测试

#import "UINavigationItem+Margin.h"

@implementation UINavigationItem (Margin)

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1

- (void)setLeftBarButtonItem:(UIBarButtonItem *)_leftBarButtonItem
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                           target:nil
                                                                                           action:nil];
        negativeSeperator.width = K_UINavigationItem_Margin;
        if (_leftBarButtonItem) {
            [self setLeftBarButtonItems:@[negativeSeperator, _leftBarButtonItem]];
        } else {
            [self setLeftBarButtonItems:@[negativeSeperator]];
        }
    } else {
        [self setLeftBarButtonItem:_leftBarButtonItem animated:NO];
    }
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)_rightBarButtonItem
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                           target:nil
                                                                                           action:nil];
        negativeSeperator.width = K_UINavigationItem_Margin;
        if (_rightBarButtonItem) {
            [self setRightBarButtonItems:@[negativeSeperator, _rightBarButtonItem]];
        } else {
            [self setRightBarButtonItems:@[negativeSeperator]];
        }
    } else {
        [self setRightBarButtonItem:_rightBarButtonItem animated:NO];
    }
}

#endif

@end
