//
//  PayUtils.h
//  PayDemo_01
//
//  Created by 侯绪铭 on 2017/3/23.
//  Copyright © 2017年 HXM. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  支付类 -> 本地订单信息
 */
#import "LocalOrderInfo.h"

/**
 *  工具类
 */
#import "CommonUtils.h"

// 支付类型
#import "PayType.h"

/**
 *  支付
 */
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

#define k_AlipayDemmo @"AlipayDemo"

@interface PayUtils : NSObject

/**
 *  支付
 *
 *  @param payType 支付类型
 *  @param payInfo 订单信息
 *  @param vc      vc
 */
+ (void)PayWithPayType:(PayType)payType payInfo:(id)payInfo vc:(UIViewController *)vc;

@end
