//
//  CommonUtils.m
//  Utils
//
//  Created by typc on 15/10/11.
//  Copyright © 2015年 tianyuanshihua. All rights reserved.
//

#import "CommonUtils.h"
#import "SDImageCache.h"
#import "JYJSON.h"

@implementation CommonUtils


+ (CGFloat)checkSystemVersion
{
    static dispatch_once_t onceToken;
    __block float systemVersion = 0;
    dispatch_once(&onceToken, ^{
        systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    return systemVersion;
}

+ (NSString *)checkAPPVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    return appVersion;
}

/**
 *  检查对象是不是null
 *
 *  @param imgStr 被检查的对象
 *
 *  @return 是 或者 不是 null
 */
+ (BOOL)checkImageURLIsNULL:(NSString *)imgStr
{
    if (imgStr == nil || [imgStr isKindOfClass:[NSNull class]]) {
        return YES;
    } else if (![imgStr isKindOfClass:[NSString class]]){
        return YES;
    } else {
        if ([imgStr isEqualToString:@"<null>"]) {
            return YES;
        } else if ([imgStr isEqualToString:@"<NULL>"]) {
            return YES;
        } else if ([imgStr isEqualToString:@"NULL"]) {
            return YES;
        } else if ([imgStr isEqualToString:@"null"]) {
            return YES;
        } else if ([imgStr isEqualToString:@""]) {
            return YES;
        } else {
            return NO;
        }
    }
}

+ (NSString*)fuckNULL:(NSObject*)obj
{
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        return @"";
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",obj];
    } else if(![obj isKindOfClass:[NSString class]]) {
        return @"";
    } else if ([obj isKindOfClass:[NSString class]]) {
        if ([(NSString *)obj isEqualToString:@"<null>"]) {
            return @"";
        } else if ([(NSString *)obj isEqualToString:@"(null)"]){
            return @"";
        } else if ([(NSString *)obj isEqualToString:@"<NULL>"]) {
            return @"";
        } else if ([(NSString *)obj isEqualToString:@"NULL"]) {
            return @"";
        } else if ([(NSString *)obj isEqualToString:@"null"]) {
            return @"";
        } else {
            return [NSString stringWithFormat:@"%@",obj];
        }
    } else {
        return @"";
    }
}

/**
 *  随机数
 *
 *  @param from 开始
 *  @param to   结束
 *
 *  @return 随机数
 */
+ (NSInteger)getRandomNumberFrom:(NSInteger)from to:(NSInteger)to
{
    return (long)(from + (arc4random() % (to -from + 1)));
}

/**
 根据现有字典转换成一个json字典
 
 @param paramDic 参数字典
 
 @return
 */
+ (NSDictionary *)JSONDic:(NSDictionary *)paramDic
{
    if (!paramDic) {
        return nil;
    } else {
        return @{@"param":[JYJSON JSONStringWithDictionaryOrArray:paramDic]};
    }
}

//单个文件的大小
+ (long long)fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


//遍历文件夹获得文件夹大小，返回多少M
+ (float)folderSizeAtPath:(NSString*) folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

/**
 *  清理缓存
 *
 *  @param path 路径
 */
+ (void)clearCache:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}

/**
 *  获取Document路径
 *
 *  @return 路径
 */
+ (NSString *)pathForDoucument
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}

/**
 *  获取Document路径
 *
 *  @return 路径
 */
+ (NSString *)pathForCaches
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return paths[0];
}

+ (NSString *)pathForTemp
{
    NSString *tmpDir =  NSTemporaryDirectory();
    return tmpDir;
}

//消息推送是否开启
+ (BOOL)isAllowedNotification
{
    //iOS8 check if user allow notification
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone != setting.types) {
        return YES;
    }
    return NO;
}

/**
 *  根据车牌号获取管局的信息
 *
 *  @param lsnum 车牌号
 *
 *  @return 管局的字符串信息
 */
+ (NSString *)getCarorgWithLsnum:(NSString *)lsnum
{
    NSString *city;//城市
    NSString *carorg;//管局
    
    if( lsnum && lsnum.length >= 1)  {
        city = [lsnum substringToIndex:1];
        if ([@"沪" isEqualToString:city]) {
            carorg = @"shanghai";
        } else if ([@"渝" isEqualToString:city]) {
            carorg = @"chongqing";
        } else if ([@"渝" isEqualToString:city]) {
            carorg = @"chongqing";
        } else if ([@"冀" isEqualToString:city]) {
            carorg = @"hebei";
        } else if ([@"晋" isEqualToString:city]) {
            carorg = @"shanxi";
        } else if ([@"辽" isEqualToString:city]) {
            carorg = @"liaoning";
        } else if ([@"吉" isEqualToString:city]) {
            carorg = @"jilin";
        } else if ([@"黑" isEqualToString:city]) {
            carorg = @"heilongjiang";
        } else if ([@"浙" isEqualToString:city]) {
            carorg = @"zhejiang";
        } else if ([@"皖" isEqualToString:city]) {
            carorg = @"anhui";
        } else if ([@"鲁" isEqualToString:city]) {
            carorg = @"shandong";
        } else if ([@"豫" isEqualToString:city]) {
            carorg = @"henan";
        } else if ([@"鄂" isEqualToString:city]) {
            carorg = @"hubei";
        } else if ([@"湘" isEqualToString:city]) {
            carorg = @"hunan";
        } else if ([@"粤" isEqualToString:city]) {
            carorg = @"guangdong";
        } else if ([@"琼" isEqualToString:city]) {
            carorg = @"hainan";
        } else if ([@"川" isEqualToString:city]) {
            carorg = @"sichuan";
        } else if ([@"贵" isEqualToString:city]) {
            carorg = @"guizhou";
        } else if ([@"云" isEqualToString:city]) {
            carorg = @"yunnan";
        } else if ([@"陕" isEqualToString:city]) {
            carorg = @"shanxi";
        } else if ([@"甘" isEqualToString:city]) {
            carorg = @"gansu";
        } else if ([@"青" isEqualToString:city]) {
            carorg = @"qinghai";
        } else if ([@"内" isEqualToString:city]) {
            carorg = @"neimenggu";
        } else if ([@"藏" isEqualToString:city]) {
            carorg = @"xizang";
        } else if ([@"宁" isEqualToString:city]) {
            carorg = @"ningxia";
        } else if ([@"新" isEqualToString:city]) {
            carorg = @"xijiang";
        }
        return carorg;
    } else {
        return @"";
    }
}

#pragma mark 匹配账户合法性(3_16位_字母数字和下划线的组合)

//验证用户输入不能为空
+ (BOOL)checkUserInput:(NSString *)input
{
    if ([input length] == 0) {
        return NO;
    }
    
    int length = (int)[input stringByReplacingOccurrencesOfString:@" " withString:@""].length;
    
    if (length == 0) {
        return NO;
    }
    
    return YES;
}

//验证用户名
+ (BOOL)checkUserName:(NSString *)username
{
    if ([username length] == 0) {
        return NO;
    }
    
    NSString *regex = @"^[a-zA-Z][a-zA-Z0-9_]{3,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:username];
    
    if (!isMatch) {
        return NO;
    }
    
    return YES;
}


//验证密码
+ (BOOL)checkPassWord:(NSString *)password
{
    if ([password length] == 0) {
        return NO;
    }
    
    NSString *regex = @"^[a-zA-Z0-9_]{6,17}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:password];
    
    if (!isMatch) {
        return NO;
    }
    
    return YES;
}


//验证验证码格式
+ (BOOL)checkVerifyCode:(NSString *)code
{
    if ([code length] == 0) {
        return NO;
    }
    
    NSString *regex = @"[0-9]{6}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:code];
    
    if (!isMatch) {
        return NO;
    }
    
    return YES;
    
}

//验证QQ
+ (BOOL)checkQQ:(NSString *)qq
{
    if ([qq length] == 0) {
        return NO;
    }
    
    NSString *regex = @"[0-9]{4,15}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:qq];
    
    if (!isMatch) {
        return NO;
    }
    
    return YES;
}

//验证手机格式
+ (BOOL)checkTel:(NSString *)tel
{
    if ([tel length] == 0 ) {
        return NO;
    }
    
    NSString *regex = @"^((13[0-9])|(14[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:tel];
    
    if (!isMatch) {
        return NO;
    }
    
    return YES;
}

//验证座机格式
+ (BOOL)checkTellandline:(NSString *)telland
{
    if ([telland length] == 0) {
        return NO;
    }
    
    NSString *regex = @"\\d{2,5}-\\d{7,8}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:telland];
    
    if (!isMatch) {
        return NO;
    }
    
    return YES;
}

//验证邮箱
+ (BOOL)checkEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**
 *
 *
 *  @param personID 身份证号
 *
 *  @return 是否匹配
 */
+ (BOOL)checkPersonID:(NSString *)personID
{
    NSString *personIDRegex = @"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$";
    NSPredicate *personIDTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", personIDRegex];
    return [personIDTest evaluateWithObject:personID];
}

/*车牌号验证 MODIFIED BY HELENSONG*/
+ (BOOL)checkCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[A-Z]{1}[A-Z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:carNo];
}

/** 网址验证 */
+ (BOOL)checkURL:(NSString *)urlStr
{
    NSString *urlRegex = @"^((http)|(https))+:[^\\s]+\\.[^\\s]*$";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",urlRegex];
    return [urlTest evaluateWithObject:urlStr];
}


/**
 *  将tel替换为****
 *
 *  @param tel 电话号码
 *
 *  @return 替换完的tel
 */
+ (NSString *)telForStartWithTelNum:(NSString *)tel
{
    if (tel.length < 11) {
        return @"格式错误";
    }
    return [tel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}

/**
 根据时间戳获取时间字符串 (默认格式 yyyy-MM-DD)
 
 @param interval 时间戳
 
 @return 字符串
 */
+ (NSString *)dateStringFromInterval:(NSTimeInterval)interval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
    return [self dateStringFromDate:date];
}

/**
 根据时间戳获取时间字符串 (默认格式 yyyy-MM-DD)
 
 @param interval 时间戳
 
 @return 字符串
 */
+ (NSString *)dateStringFromInterval:(NSTimeInterval)interval withDateFormat:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
    return [self dateStringFromDate:date withDateFormat:format];
}

/**
 *  把时间转化成字符串  YYYY - MM - DD
 *
 *  @param date 时间
 *
 *  @return 字符串时间
 */
+ (NSString *)dateStringFromDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    return [format stringFromDate:date];
}

/**
 *  @author mjy
 *
 *  @brief 把时间转化成字符串
 *
 *  @param date   时间
 *  @param format 格式
 *
 *  @return 字符串时间
 */
+ (NSString *)dateStringFromDate:(NSDate *)date withDateFormat:(NSString *)format
{
    if (!format) {
        return [self dateStringFromDate:date];
    } else {
        
        NSDateFormatter *ft = [[NSDateFormatter alloc] init];
        ft.dateFormat = format;
        return [ft stringFromDate:date];
    }
}


/**
 根据目标时间,计算返回距离现在多久
 
 @param interval 时间戳-毫秒
 
 @return 字符串
 */
+ (NSString *)compareCurrentTimeWithInterval:(NSTimeInterval)interval
{
    // 获取当前时时间戳 1466386762 十位整数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = interval/1000;
    // 时间差
    NSTimeInterval timeInterval = currentTime - createTime;
    
    long temp = 0;
    NSString *result;
    
    if ( timeInterval/60 < 1 ) {
        result = [NSString stringWithFormat:@"刚刚"];
    } else if ( (temp = timeInterval/60) < 60 ) {
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    } else if ( (temp = temp/60) < 24 ){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    } else if ( (temp = temp/24) < 30 ){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    } else if( (temp = temp/30) < 12 ) {
        result = [NSString stringWithFormat:@"%ld月前",temp];
    } else {
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    return result;
}


/**
 根据字符串和格式,计算距离今天多久
 
 @param dateStr 时间字符串
 @param formatStr 时间格式
 @return 多久
 */
+ (NSString *)compareCurrentTimeWithDateStr:(NSString *)dateStr andFormat:(NSString *)formatStr
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatStr];
    [dateFormat setLocale:[NSLocale currentLocale]];
    NSDate *date = [dateFormat dateFromString:dateStr];
    NSTimeInterval interval = [date timeIntervalSince1970] * 1000;
    return [self compareCurrentTimeWithInterval:interval];
}




/**
 根据开始时间和结束时间,以及周几,计算一个时间数组
 */
+ (NSArray *)daysWithStartDate:(NSDate *)startDate
                       endDate:(NSDate *)endDate
                       weekStr:(NSString *)weekStr
{
    NSMutableArray * maTimes = [NSMutableArray array];
    NSDate *nowDate = [NSDate date];
    
    ///结束时间已过-->  不要在往下走了..
    if ([endDate compare:nowDate] != NSOrderedDescending) {
        return maTimes.copy;
    }
    //1.有多少天
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [greCalendar components:NSCalendarUnitDay fromDate:startDate toDate:endDate options:0];
    NSInteger days = dateComponents.day;
    
    ///如果开始时间和结束时间相差不到一天, 直接是开始时间
    if (days == 0) {
        [maTimes addObject:startDate];
        return maTimes.copy;
    }
    //2.需要过滤掉周几
    NSArray *arrWeekStrs;//接口返回的
    NSMutableArray *arrWeeksAll = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"].mutableCopy;//全部星期信息
    if (weekStr) {
        if ([weekStr containsString:@","]) {
            //可以截取
            arrWeekStrs = [weekStr componentsSeparatedByString:@","];
        } else {
            //不能截取,只有一天
            arrWeekStrs = @[weekStr];
        }
        //检查,需要过滤掉周几
        for (NSString *str in arrWeekStrs) {
            if ([arrWeeksAll containsObject:str]) {
                [arrWeeksAll removeObject:str];
            }
        }
        //剩下的就是需要过滤掉的day的信息
        if (arrWeeksAll.count > 0) {
            //有需要过滤的day
            for ( int i = 0; i < days + 2; i ++ ) {
                NSDate *dateForArr = [startDate dateByAddingTimeInterval:24 * 60 * 60 * i];
                if ([dateForArr compare:endDate] != NSOrderedDescending && ![arrWeeksAll containsObject:[self getWeekStrWithDate:dateForArr]]) {
                    /// 在活动时间范围内  && 在需要排除的星期之外
                    if ([dateForArr compare:nowDate] != NSOrderedDescending) {
                        if ([self isSameDay:nowDate date2:dateForArr]) {
                            [maTimes addObject:dateForArr];
                        }
                    } else {
                        [maTimes addObject:dateForArr];
                    }
                } else {
                    /// 不加
                }
            }
            
        } else {
            //不需要过滤
            for ( int i = 0; i < days + 2; i ++ ) {
                NSDate *dateForArr = [startDate dateByAddingTimeInterval:24 * 60 * 60 * i];
                if ([dateForArr compare:endDate] != NSOrderedDescending) {
                    /// 在活动时间范围内
                    if ([dateForArr compare:nowDate] != NSOrderedDescending) {
                        if ([self isSameDay:nowDate date2:dateForArr]) {
                            [maTimes addObject:dateForArr];
                        }
                    } else {
                        [maTimes addObject:dateForArr];
                    }
                } else {
                    /// 不加
                }
            }
        }
        
        /// 这里需要考虑一下最后的时间  防止缺少最后的时间
        if (![self hasDateInArr:maTimes withDate:endDate]) {
            [maTimes addObject:endDate];
        }
        ///  这里就能确定 日期啦.. 我了个擦!!!
        return maTimes.copy;
    } else {
        //数据返回错误
        return maTimes.copy;
    }
}


/**
 判断一个数组是否包含了一个日期
 
 @param arr  日期数组 (of NSDates)
 @param date 要查询的日期
 
 @return 是否包含
 */
+ (BOOL)hasDateInArr:(NSArray *)arr withDate:(NSDate *)date
{
    BOOL hasDate = NO;
    NSTimeInterval dateInterval = [date timeIntervalSince1970];
    for (NSDate *date1 in arr) {
        NSTimeInterval timeInterval = [date1 timeIntervalSince1970];
        /// 一小时之内 --  表示包含
        if (fabs(dateInterval - timeInterval) < 5 * 60) {
            // 表示包含了..
            hasDate = YES;
            break;
        }
    }
    return hasDate;
}

/**
 判断俩个时间是否在同一天
 
 @param date1 时间1
 @param date2 时间2
 
 @return 结果
 */
+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    return [comp1 day] == [comp2 day] && [comp1 month] == [comp2 month] && [comp1 year] == [comp2 year];
}


/**
 获取星期几
 
 @param date 日期
 
 @return 星期字符串  1 2 3 4 5 6 7
 */
+ (NSString *)getWeekStrWithDate:(NSDate *)date
{
    //initializtion parameter
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitWeekday;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger weekNum = comps.weekday;
    
    //Week: 在这一步耽误了不少时间!
    //    1－－星期天
    //    2－－星期一
    //    3－－星期二
    //    4－－星期三
    //    5－－星期四
    //    6－－星期五
    //    7－－星期六
    NSString *weekStr ;
    switch (weekNum) {
        case 1:
            weekStr = @"7";
            break;
        case 2:
            weekStr = @"1";
            break;
        case 3:
            weekStr = @"2";
            break;
        case 4:
            weekStr = @"3";
            break;
        case 5:
            weekStr = @"4";
            break;
        case 6:
            weekStr = @"5";
            break;
        case 7:
            weekStr = @"6";
            break;
        default:
            weekStr = @"7";
            break;
    }
    return weekStr;
}

#pragma mark - 验证码

/**
 判断扫描的二维码是不是约美的二维码
 
 @param codeString 扫描之后的字符串
 @return 是否是约美的扫描格式
 */
+ (BOOL)isYueMeiCode:(NSString *)codeString
{
    // 定义二维码的格式
    // 例如: YM0001http://www.baidu.com
    // YM 约美的前缀,如果扫描二维码获得的字符串是以YM开头的,则解析,否则不是约美的二维码 -> 提示用户错误
    // 0001 约美二维码的内置类型,需要自己定义,例如: 0001 表示优惠券核销  0002 表示美食   0003 表示约美支付二维码  ... 等等
    // http://www.baidu.com : 这是二维码的正式内容 (需要拿来做处理的真正信息)
    
    // 所有的二维码类型数组
    NSArray *arrCodeTypes = @[
                              @"0001",//优惠券
                              @"0002",//美食&玩乐
                              @"0003",//百货
                              @"0004",//收银
                              @"0008",//活动
                              ];
    
    if (!codeString) {
        return NO;
    }
    
    if (codeString.length < 6) {
        //长度不够(格式不对,最低YM0001)
        return NO;
    } else {
        if (![codeString hasPrefix:@"YM"]) {
            // 没有前缀为YM的字符串 -> 格式不对
            return NO;
        } else {
            NSString *codeType = [codeString substringWithRange:NSMakeRange(2, 4)];
            if ([arrCodeTypes containsObject:codeType]) {
                //包含
                return YES;
            } else {
                //不包含
                return NO;
            }
        }
    }
}

/**
 二维码类型
 
 @param codeString 整个二维码字符串
 @return 类型
 */
+ (NSString *)YueMeiCodeType:(NSString *)codeString
{
    return [codeString substringWithRange:NSMakeRange(2, 4)];
}

/**
 订单号码
 
 @param codeString 整个二维码字符串
 @return 订单号
 */
+ (NSString *)YueMeiOrderNumber:(NSString *)codeString
{
    if (codeString.length <= 6) {
        return @"";
    } else {
        return [codeString substringFromIndex:6];
    }
}

#pragma mark - UI


//--------------------------------UI
//隐藏tableView多余的分割线
+ (void)hiddleExtendCellForTableView:(UITableView *)tableView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

//拨打电话
+ (void)callPhone:(NSString *)phoneNumber withSuperView:(UIView *)view
{
    if (!phoneNumber) {
        return;
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:[phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""]]]];
}

//统一返回按钮
+ (void)settingBackButtonImageWithImage:(UIImage *)image
{
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
}

//滑动到最后一行
+ (void)scrollToFootWithTableView:(UITableView *)tableView isAnimated:(BOOL)animated
{
    NSInteger s = [tableView numberOfSections];
    if (s<1) return;
    
    NSInteger r = [tableView numberOfRowsInSection:s-1];
    if (r<1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    [tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    
}


//等比缩放UIImage
+ (UIImage *)scaleImage:(UIImage *)image withScale:(float)scale
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scale, image.size.height * scale));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scale, image.size.height * scale)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//图片旋转
+ (UIImage *)rotateImage:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

//计算高度
+ (CGFloat)heightForLabel:(UILabel *)label
                 WithText:(NSString *)text
                 fontName:(NSString *)fontName
                 fontSize:(CGFloat)fontSize
                    width:(CGFloat)width
{
    if (!text) {
        return 0;
    } else {
        if (!fontName) {
            //系统默认的字体
            fontName = @"Helvetica";
        }
        
        //创建字体信息
        UIFont *textFont = [UIFont fontWithName:fontName size:fontSize];
        //字体字典信息
        NSDictionary *fontDict =[NSDictionary dictionaryWithObject:textFont forKey:NSFontAttributeName];
        
        //设置label的属性
        label.numberOfLines = 0 ;
        label.lineBreakMode = NSLineBreakByCharWrapping;//以字符为显示单位显示，后面部分省略不显示。
        label.backgroundColor = [UIColor clearColor];
        label.font = textFont;
        
        CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                         options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                      attributes:fontDict
                                         context:nil];
        
        return rect.size.height + 1;
    }
    
}

//计算高度
+ (CGFloat)heightForLabel:(UILabel *)label
                 WithText:(NSString *)text
                    width:(CGFloat)width
{
    //创建字体信息
    UIFont *textFont = label.font;
    //字体字典信息
    NSDictionary *fontDict =[NSDictionary dictionaryWithObject:textFont forKey:NSFontAttributeName];
    
    //设置label的属性
    label.numberOfLines = 0 ;
    label.lineBreakMode = NSLineBreakByCharWrapping;//以字符为显示单位显示，后面部分省略不显示。
    label.backgroundColor = [UIColor clearColor];
    label.font = textFont;
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                  attributes:fontDict
                                     context:nil];
    return rect.size.height+1;
}

//计算高度
+ (CGFloat)heightForTextView:(UITextView *)textView
                    WithText:(NSString *)text
                       width:(CGFloat)width
{
    //创建字体信息
    UIFont *textFont = textView.font;
    //字体字典信息
    NSDictionary *fontDict =[NSDictionary dictionaryWithObject:textFont forKey:NSFontAttributeName];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                  attributes:fontDict
                                     context:nil];
    return rect.size.height + 1;
}

/**
 计算文本的宽度
 
 @param label  label
 @param text  文字
 @param height 容器最大高度
 @return 文本宽度
 */
+ (CGFloat)widthForLabel:(UILabel *)label
                withText:(NSString *)text
                  height:(CGFloat)height
{
    if (!text) {
        return 0;
    }
    
    UIFont *textFont = label.font;
    NSDictionary *fontDic = @{ NSFontAttributeName:textFont };
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                  attributes:fontDic context:nil];
    return rect.size.width + 1;
    
}


//显示提示信息
+ (void)showMessage:(NSString *)message
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    //创建字体信息
    UIFont *textFont = [UIFont systemFontOfSize:13];
    //字体字典信息
    NSDictionary *fontDict =[NSDictionary dictionaryWithObject:textFont forKey:NSFontAttributeName];
    CGRect rect = [message boundingRectWithSize:CGSizeMake(300, MAXFLOAT)
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:fontDict
                                        context:nil];
    
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = rect.size;
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:13];
    [showview addSubview:label];
    showview.frame = CGRectMake((screenWidth - LabelSize.width - 20)/2, screenHeight - 100, LabelSize.width+20, LabelSize.height+10);
    [UIView animateWithDuration:3 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}


//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController * vc =  [self getPresentedViewController];
    if (vc) {
        return vc;
    } else {
        UIViewController *result = nil;
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        if (window.windowLevel != UIWindowLevelNormal) {
            NSArray *windows = [[UIApplication sharedApplication] windows];
            for(UIWindow * tmpWin in windows) {
                if (tmpWin.windowLevel == UIWindowLevelNormal) {
                    window = tmpWin;
                    break;
                }
            }
        }
        UIView *frontView = [[window subviews] objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
            result = nextResponder;
        else
            result = window.rootViewController;
        return result;
    }
}

+ (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

/**
 *  将imageStr转化为图片
 */
+ (UIImage *)imageWithString:(NSString *)imageString
{
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]]];
}

/* 计算两个时间差*/
+ (NSString *)intervalFromLastDate:(NSString *)startDate toTheDate:(NSString *)endDate
{
    NSArray *timeArray1 = [startDate componentsSeparatedByString:@"."];
    startDate = [timeArray1 objectAtIndex:0];
    
    NSArray *timeArray2 = [endDate componentsSeparatedByString:@"."];
    endDate = [timeArray2 objectAtIndex:0];
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSDate *d1 = [date dateFromString:startDate];
    
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
    
    NSDate *d2 = [date dateFromString:endDate];
    
    NSTimeInterval late2 = [d2 timeIntervalSince1970]*1;
    
    NSTimeInterval cha = late2-late1;
    NSString *timeString = @"";
    NSString *house = @"";
    NSString *min = @"";
    NSString *sen = @"";
    
    sen = [NSString stringWithFormat:@"%d", (int)cha%60];
    // min = [min substringToIndex:min.length-7];
    // 秒
    sen=[NSString stringWithFormat:@"%@", sen];
    
    min = [NSString stringWithFormat:@"%d", (int)cha/60%60];
    // min = [min substringToIndex:min.length-7];
    // 分
    min=[NSString stringWithFormat:@"%@", min];
    
    // 小时
    house = [NSString stringWithFormat:@"%d", (int)cha/3600];
    // house = [house substringToIndex:house.length-7];
    house=[NSString stringWithFormat:@"%@", house];
    
    timeString=[NSString stringWithFormat:@"%@小时 %@分 %@秒",house,min,sen];
    return timeString;
}


@end
