//
//  LocalOrderInfo.h
//  
//
//  Created by 侯绪铭 on 2017/3/23.
//
//

#import <Foundation/Foundation.h>
#import "CommonUtils.h"

/**
 *  支付宝本地订单信息
 */
@interface AlipayInfo : NSObject

@property (nonatomic, copy) NSString *datas;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

/**
 *  微信支付本地订单信息
 */
@interface WeChatPayInfo : NSObject

// 应用APPID
@property(copy, nonatomic) NSString *appid;
// 随机字符串
@property(copy, nonatomic) NSString *noncestr;
// 扩展字段
@property(copy, nonatomic) NSString *packages;
// 商户号
@property(copy, nonatomic) NSString *partnerid;
// 预支付交易会话标识
@property(copy, nonatomic) NSString *prepayid;
// 签名
@property(copy, nonatomic) NSString *sign;
// 时间戳
@property(copy, nonatomic) NSString *timestamp;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
