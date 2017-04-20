//
//  PayUtils.m
//  PayDemo_01
//
//  Created by 侯绪铭 on 2017/3/23.
//  Copyright © 2017年 HXM. All rights reserved.
//

#import "PayUtils.h"

@implementation PayUtils

+ (void)PayWithPayType:(PayType)payType payInfo:(id)payInfo vc:(UIViewController *)vc
{
    if (payType == PayTypeAliPay) {
        [self AlipayWithPayInfo:payInfo vc:vc];
    } else if(payType == PayTypeWeChat){
        [self WeChatWithPayInfo:payInfo vc:vc];
    }
}

/**
 *  微信支付
 *
 *  @param payInfo 支付信息
 *  @param vc      vc
 */
+ (void)WeChatWithPayInfo:(id)payInfo vc:(UIViewController *)vc
{
    if ([payInfo isKindOfClass:[NSDictionary class]
        ]) {
        WeChatPayInfo *info = [[WeChatPayInfo alloc] initWithDict:payInfo];
        
        // 调起微信支付
        PayReq *req = [[PayReq alloc] init];
        req.partnerId = info.partnerid;
        req.timeStamp = [info.timestamp intValue];
        req.prepayId = info.prepayid;
        req.package = info.packages;
        req.nonceStr = info.noncestr;
        req.sign = info.sign;
        
        // 发送支付请求
        [WXApi sendReq:req];
    } else {
        NSLog(@"微信-支付信息异常");
    }
}

/**
 *  支付宝支付
 *
 *  @param payInfo 支付信息
 *  @param vc      vc
 */
+ (void)AlipayWithPayInfo:(id)payInfo vc:(UIViewController *)vc
{
    if ([payInfo isKindOfClass:[NSString class]]) {
        // 支付接口
        [[AlipaySDK defaultService] payOrder:payInfo
                                  fromScheme:k_AlipayDemmo
                                    callback:^(NSDictionary *resultDic) {
                                        NSLog(@"result = %@",resultDic);
                                        //        9000	订单支付成功
                                        //        8000	正在处理中
                                        //        4000	订单支付失败
                                        //        6001	用户中途取消
                                        //        6002	网络连接出错
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
    } else {
        
        NSLog(@"支付宝-支付信息异常");
    }
}

#pragma mark - 支付结果提示
/**
 *  显示提示信息(1秒后 自动消失)
 *
 *  @param msg 要显示的字符串
 */
+ (void)showMessage:(NSString *)msg
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
+ (void)showMessage:(NSString *)msg withCompletionBlock:(void(^)())completionBlock
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
