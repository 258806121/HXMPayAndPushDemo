//
//  UIViewController+KeyboardDissmiss.m
//  KeyboardDemo
//
//  Created by majinyu on 16/7/11.
//  Copyright © 2016年 com.bm.hb. All rights reserved.
//

#import "UIViewController+KeyboardDissmiss.h"

@implementation UIViewController (KeyboardDissmiss)

- (void)registerDismissKeyBoard
{
    __weak UIViewController *weakSelf = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboardTap:)];
    /**
     *  当键盘将要弹出的时候添加一个手势
     */
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      [weakSelf.view addGestureRecognizer:tap];
                                                  }];
    /**
     *  当键盘将要消失的时候移除之前添加的手势
     */
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      [weakSelf.view removeGestureRecognizer:tap];
                                                  }];
}

/**
 *  点击隐藏键盘
 *
 *  @param gesture 手势
 */
- (void)dismissKeyboardTap:(UITapGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
}


@end
