//
//  AppDelegate.h
//  PayDemo_01
//
//  Created by 侯绪铭 on 2017/3/23.
//  Copyright © 2017年 HXM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSDictionary *userInfoPush; ///推送相关的信息
@property (readonly, assign, nonatomic) BOOL      isLogin;//是否登录

/**
 *  token
 */
- (NSString *)deviceToken;

@end

