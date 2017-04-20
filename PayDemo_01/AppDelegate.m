//
//  AppDelegate.m
//  PayDemo_01
//
//  Created by 侯绪铭 on 2017/3/23.
//  Copyright © 2017年 HXM. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import "CommonUtils.h"

// pay
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

// push
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>

// share
#import <UMSocialCore/UMSocialCore.h>

@interface AppDelegate ()<
WXApiDelegate,
UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // 设置
    [self initPropertys];
    
    // 注册 -> 微信
    [WXApi registerApp:@"wxb09e37497626c040" withDescription:@"demo 2.0"];
    
    // 友盟推送
    [self setupUMessageWith:launchOptions];
    
    // 友盟分享
    [self setupUMSharePlatforms];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - method
- (NSString *)deviceToken
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:k_UD_deviceToken];
    if (token) {
        return token;
    } else {
        return @"";
    }
}

- (BOOL)isLogin
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:k_UD_isLogin];
}

#pragma mark - Set Property
- (void)initPropertys
{
    //    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //    self.window.backgroundColor = [UIColor whiteColor];
    //    [self.window makeKeyAndVisible];
    //
    //    ViewController *vc = [[ViewController alloc] init];
    //    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
    //    self.window.rootViewController = vc;
    
}

#pragma mark - 友盟分享设置
- (void)setupUMSharePlatforms
{
    /**
     *  是否清除缓存在获得用户资料的时候
     *  默认设置为YES,代表请求用户的时候需要请求缓存
     *  NO,代表不清楚缓存，用缓存的数据请求用户数据
     */
    [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = NO;
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:k_UShare_AppKey];
    
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                          appKey:k_WX_AppID
                                       appSecret:k_WX_AppSecret
                                     redirectURL:k_WX_ShareURL1];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ
                                          appKey:k_QQ_AppID
                                       appSecret:nil
                                     redirectURL:k_WX_ShareURL1];
    
}

#pragma mark - 友盟推送设置
- (void)setupUMessageWith:(NSDictionary *)launchOptions
{
    // 友盟推送
    [UMessage startWithAppkey:@"58d48df0b27b0a5e9600105c" launchOptions:launchOptions httpsEnable:YES];
    
    /** 注册RemoteNotification的类型
     @brief 分别针对iOS8以前版本及iOS8及以后开启推送消息推送。
     默认的时候是sound，badge ,alert三个功能全部打开, 没有开启交互式推送行为分类。
     */
    [UMessage registerForRemoteNotifications];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNAuthorizationOptions types10 = UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (granted) {
                                  //点击允许
                                  //这里可以添加一些自己的逻辑
                              } else {
                                  //点击不允许
                                  //这里可以添加一些自己的逻辑
                              }
                          }];
    
#endif
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    [UMessage registerDeviceToken:deviceToken];
    
    NSString *token = [NSString stringWithFormat:@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                                         stringByReplacingOccurrencesOfString: @">" withString: @""]
                                                        stringByReplacingOccurrencesOfString: @" " withString: @""]];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:k_UD_deviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    /// 自己处理推送的逻辑
    [self handleRemoteNotification:userInfo];
    
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
}

//iOS10以前接收的方法
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    //这个方法用来做action点击的统计
    [UMessage sendClickReportForRemoteNotification:userInfo];
    
    /// 自己处理推送的逻辑
    [self handleRemoteNotification:userInfo];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//iOS10新增：处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        //应用处于前台时的远程推送接受
        
        /// 自己处理推送的逻辑
        [self handleRemoteNotification:userInfo];
        
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    } else {
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        /// 自己处理推送的逻辑
        [self handleRemoteNotification:userInfo];
        
        if([response.actionIdentifier isEqualToString:@"*****你定义的action id****"]) {
            
        } else {
            
        }
        //这个方法用来做action点击的统计
        [UMessage sendClickReportForRemoteNotification:userInfo];
        
    } else {
        //应用处于后台时的本地推送接受
    }
}
#endif


#pragma mark - 微信/支付宝支付
// 9.0之前
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([WXApi handleOpenURL:url delegate:self]) {
            return YES;
        }
    }
    return result;
    //    return [WXApi handleOpenURL:url delegate:self];
}

// 9.0之前
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        if ([WXApi handleOpenURL:url delegate:self]) {
            return YES;
        } else {
            if ([url.host isEqualToString:@"safepay"]) {
                /**
                 *  处理钱包或者独立快捷app支付跳回商户app携带的支付结果Url
                 *
                 *  @param resultUrl        支付结果url
                 *  @param completionBlock  支付结果回调
                 */
                [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                    NSLog(@"result = %@",resultDic);
                    //9000	订单支付成功
                    //8000	正在处理中
                    //4000	订单支付失败
                    //6001	用户中途取消
                    //6002	网络连接出错
                    NSInteger status = [resultDic[@"resultStatus"] intValue];
                    if (status == 9000) {
                        // 支付成功
                        [self showMessage:k_PayStatus_Success withCompletionBlock:^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:k_noti_AliPayCallBackSuccess object:nil];
                        }];
                    } else if (status == 6001) {
                        // 取消
                        [self showMessage:k_PayStatus_Cancel withCompletionBlock:^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:k_noti_AliPayCallBackCancel object:nil];
                        }];
                    } else {
                        // 失败
                        [self showMessage:k_PayStatus_Fail withCompletionBlock:^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:k_noti_AliPayCallBackFail object:nil];
                        }];
                    }
                }];
            }
            return YES;
        }
    }
    return result;
}

// 9.0之后
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    
    if (!result) {
        if ([WXApi handleOpenURL:url delegate:self]) {
            return YES;
        } else {
            if ([url.host isEqualToString:@"safepay"]) {
                [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                    NSLog(@"result = %@",resultDic);
                    //9000	订单支付成功
                    //8000	正在处理中
                    //4000	订单支付失败
                    //6001	用户中途取消
                    //6002	网络连接出错
                    NSInteger status = [resultDic[@"resultStatus"] intValue];
                    if (status == 9000) {
                        // 支付成功
                        [self showMessage:k_PayStatus_Success withCompletionBlock:^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:k_noti_AliPayCallBackSuccess object:nil];
                        }];
                    } else if (status == 6001) {
                        // 取消
                        [self showMessage:k_PayStatus_Cancel withCompletionBlock:^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:k_noti_AliPayCallBackCancel object:nil];
                        }];
                    } else {
                        // 失败
                        [self showMessage:k_PayStatus_Fail withCompletionBlock:^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:k_noti_AliPayCallBackFail object:nil];
                        }];
                    }
                }];
            }
            return YES;
        }
    }
    return result;
}


#pragma mark - 微信支付回调
/**
 *  微信支付回调
 *
 *  @param resp resp具体的回应内容，是自动释放的
 */
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
        switch (resp.errCode) {
            case WXSuccess:
                [self showMessage:k_PayStatus_Success withCompletionBlock:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:k_noti_WXPayCallBackSuccess object:nil];
                }];
                break;
            case WXErrCodeUserCancel:
                [self showMessage:k_PayStatus_Cancel withCompletionBlock:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:k_noti_WXPayCallBackCancel object:nil];
                }];
                break;
            default:
                [self showMessage:k_PayStatus_Fail withCompletionBlock:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:k_noti_WXPayCallBackFail object:nil];
                }];
                break;
        }
    }
}


#pragma mark - Utils
/**
 处理推送的逻辑
 
 @param userInfo userInfo
 */
- (void)handleRemoteNotification:(NSDictionary *)userInfo
{
    /// 记录推送过来的信息
    self.userInfoPush = userInfo;
    
    /// 只是告诉登录页面,有没有推送过来的消息而已
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:k_Noti_Push_HasMessage];
    
    /// 取出原来的数量
    NSInteger numInt = [[NSUserDefaults standardUserDefaults] integerForKey:k_Noti_Push_MessageNotReadNumber];
    
    /// 在原来的基础之上加1
    numInt = numInt + 1;
    
    /// 写会原来的数据
    [[NSUserDefaults standardUserDefaults] setInteger:numInt forKey:k_Noti_Push_MessageNotReadNumber];
    
    /// 同步
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    /// 记录推送未读 - 数量
    [UIApplication sharedApplication].applicationIconBadgeNumber = numInt;
    
}

/**
 *  显示提示信息(1秒后 自动消失)
 *
 *  @param msg 要显示的字符串
 */
- (void)showMessage:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
    [[CommonUtils getCurrentVC] presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

/**
 *  显示提示信息,并且在显示完成之后,做指定的block
 *
 *  @param msg             要显示的字符串
 *  @param completionBlock 显示完毕后的block
 */
- (void)showMessage:(NSString *)msg withCompletionBlock:(void(^)())completionBlock
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
    [[CommonUtils getCurrentVC] presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:^{
                completionBlock();
            }];
        });
    }];
}

@end
