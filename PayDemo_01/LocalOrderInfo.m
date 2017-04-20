//
//  LocalOrderInfo.m
//  
//
//  Created by 侯绪铭 on 2017/3/23.
//
//

#import "LocalOrderInfo.h"

/**
    支付宝本地订单信息
 */
@implementation AlipayInfo

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (!self) {
        self = [[AlipayInfo alloc] init];
    }
    self.datas = [CommonUtils fuckNULL:dict[@"data"]];
    return self;
}

@end

/**
    微信本地订单信息
 */
@implementation WeChatPayInfo

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (!self) {
        self = [[WeChatPayInfo alloc] init];
        self.appid     = [CommonUtils fuckNULL:dict[@"appid"]];
        self.noncestr  = [CommonUtils fuckNULL:dict[@"noncestr"]];
        self.packages  = [CommonUtils fuckNULL:dict[@"packages"]];
        self.partnerid = [CommonUtils fuckNULL:dict[@"partnerid"]];
        self.prepayid  = [CommonUtils fuckNULL:dict[@"prepayid"]];
        
        self.sign      = [CommonUtils fuckNULL:dict[@"sign"]];
        self.timestamp = [CommonUtils fuckNULL:dict[@"timestamp"]];
    }
    return self;
}

@end
