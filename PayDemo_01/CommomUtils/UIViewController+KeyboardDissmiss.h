//
//  UIViewController+KeyboardDissmiss.h
//  KeyboardDemo
//
//  Created by majinyu on 16/7/11.
//  Copyright © 2016年 com.bm.hb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (KeyboardDissmiss)

/**
 *  注册键盘的单击隐藏处理
 *  使用方式:
 *  1.声明该分类
 *  2.调用 registerDismissKeyBoard方法,注册键盘处理事件
 *  当点击背景视图就会隐藏keyboard
 */
- (void)registerDismissKeyBoard;

@end
