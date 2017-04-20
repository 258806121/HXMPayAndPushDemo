//
//  ViewController.m
//  PayDemo_01
//
//  Created by 侯绪铭 on 2017/3/23.
//  Copyright © 2017年 HXM. All rights reserved.
//

#import "ViewController.h"

/**
 *  share
 */
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

static NSString *const UMS_THUMB_IMAGE = @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
static NSString *const UMS_Title = @"【友盟+】社会化组件U-Share";
static NSString* const UMS_Web_Desc = @"W欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！";
static NSString* const UMS_WebLink = @"http://mobile.umeng.com/social";

@interface ViewController ()<
UMSocialShareMenuViewDelegate>
{
    BOOL hasPushNotification;// 是否有推送的消息
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnShare];
    [btnShare setTitle:@"点击" forState:UIControlStateNormal];
    btnShare.frame = CGRectMake(100, 100, 100, 100);
    [btnShare addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    btnShare.backgroundColor = [UIColor blackColor];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self checkNotification];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Noti method
- (void)creatNoti
{
    /**
     *  微信支付
     */
    // 支付成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPaySuccess) name:k_noti_WXPayCallBackSuccess object:nil];
    // 支付取消
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPayCancel) name:k_noti_WXPayCallBackCancel object:nil];
    // 支付失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPayFail) name:k_noti_WXPayCallBackFail object:nil];
    
    /**
     *  支付宝支付
     */
    // 支付成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aliPaySuccess) name:k_noti_AliPayCallBackSuccess object:nil];
    // 支付取消
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aliPayCancel) name:k_noti_AliPayCallBackCancel object:nil];
    // 支付失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aliPayFail) name:k_noti_AliPayCallBackFail object:nil];
    
}

#pragma mark - 微信支付回调

// 支付成功
- (void)weChatPaySuccess
{
    NSLog(@"支付成功");
}

// 支付取消
- (void)weChatPayCancel
{
    NSLog(@"支付取消");
}

// 支付失败
- (void)weChatPayFail
{
    NSLog(@"支付失败");
}

#pragma mark - 支付宝支付回调

// 支付成功
- (void)aliPaySuccess
{
   NSLog(@"支付成功");
}

// 支付取消
- (void)aliPayCancel
{
   NSLog(@"支付取消");
}

// 支付失败
- (void)aliPayFail
{
   NSLog(@"支付失败"); 
}

#pragma mark - Custom method
/**
 检查有没有推送信息
 */
- (void)checkNotification
{
    /// 记录推送未读 - 数量
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:k_Noti_Push_MessageNotReadNumber];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    /*
     * 推送相关!!
     */
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:k_Noti_Push_HasMessage]) {
        
        hasPushNotification = YES;
        
        /// 先清空推送消息状态
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:k_Noti_Push_HasMessage];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSDictionary *dic = ApplicationDelegate.userInfoPush;
        
        if (!dic) {
            return;
        }
        
        NSString *url = dic[@"url"];
        
        if (url && [url isKindOfClass:[NSString class]] && ![url isEqualToString:@""]) {
            
            /// 有url -> 直接跳转url
            
        } else {
            
            /// 无url
            if (ApplicationDelegate.isLogin) {
                
                
            } else {
                
            }
        }
        
    } else {
        /// 无推送消息  -> 什么也不做
        hasPushNotification = NO;
    }
}

/**
 *  分享
 */
- (void)shareAction
{
    /**
     *  设置用户要分享到的自定义平台
     */
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine),
                                               @(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_Qzone)]];
    
    //设置分享面板的显示和隐藏的代理回调
    [UMSocialUIManager setShareMenuViewDelegate:self];
    
    // 分享面板类的位置
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    // 分享平台的图标样式(例如 微信 QQ),有图片，没有圆背景，
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        [self shareWebPageToPlatformType:platformType];
    }];
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  UMS_THUMB_IMAGE;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:UMS_Title
                                                                             descr:UMS_Web_Desc
                                                                         thumImage:[UIImage imageNamed:@""]];
    //设置网页地址
    shareObject.webpageUrl = UMS_WebLink;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        NSLog(@"======%@",error);
        [self alertWithError:error];
    }];
}

- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功"];
    } else {
        result = [NSString stringWithFormat:@"分享失败"];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UMSocialShareMenuViewDelegate
- (void)UMSocialShareMenuViewDidAppear
{
    NSLog(@"UMSocialShareMenuViewDidAppear");
}
- (void)UMSocialShareMenuViewDidDisappear
{
    NSLog(@"UMSocialShareMenuViewDidDisappear");
}

//不需要改变父窗口则不需要重写此协议
- (UIView*)UMSocialParentView:(UIView*)defaultSuperView
{
    return defaultSuperView;
}

@end
