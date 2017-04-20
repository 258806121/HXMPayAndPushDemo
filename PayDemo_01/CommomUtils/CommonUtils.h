//
//  CommonUtils.h
//  Utils
//
//  Created by typc on 15/10/11.
//  Copyright © 2015年 tianyuanshihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommonUtils : NSObject

#pragma mark - UI无关的方法
//*******************************************
//和UI无关的方法
//*******************************************

/**
 *	@brief	判断应用运行在什么系统版本上
 *
 *	@return	返回系统版本 ：7.0     6.0     6.1等
 */
+ (CGFloat)checkSystemVersion;

/**
 *	@brief	判断应用的版本号
 *
 *	@return	返回版本号
 */
+ (NSString *)checkAPPVersion;


/**
 *	@brief	处理null字符串
 *
 *	@param
 */
+ (NSString*)fuckNULL:(NSObject*)obj;

/**
 *  产生一个随机数
 *
 *  @param from 开始
 *  @param to   结束
 *
 *  @return 随机数
 */
+ (NSInteger)getRandomNumberFrom:(NSInteger)from to:(NSInteger)to;

/**
 *  将tel替换为****
 *
 *  @param tel 电话号码
 *
 *  @return 替换完的tel
 */
+ (NSString *)telForStartWithTelNum:(NSString *)tel;


/**
 根据现有字典转换成一个json字典

 @param paramDic 参数字典

 @return
 */
+ (NSDictionary *)JSONDic:(NSDictionary *)paramDic;

#pragma mark -

/**
 *  单个文件的大小
 *
 *  @param filePath 文件路径
 *
 *  @return 大小bit
 */
+ (long long)fileSizeAtPath:(NSString*) filePath;

/**
 *  整个文件夹的大小
 *
 *  @param folderPath 文件路径
 *
 *  @return 大小M
 */
+ (float)folderSizeAtPath:(NSString*) folderPath;

/**
 *  清理缓存
 *
 *  @param path 路径
 */
+ (void)clearCache:(NSString *)path;

/**
 *  获取沙盒路径
 *
 *  @return Document路径
 */
+ (NSString *)pathForDoucument;

/**
 *  获取沙盒路径
 *
 *  @return caches路径
 */
+ (NSString *)pathForCaches;

/**
 *  获取沙盒路径
 *
 *  @return Document路径
 */
+ (NSString *)pathForTemp;


#pragma mark -

/**
 *  消息推送是否开启
 *
 *  @return 是否开启
 */
+ (BOOL)isAllowedNotification;

/**
 *  根据车牌号获取管局的信息
 *
 *  @param lsnum 车牌号
 *
 *  @return 管局的字符串信息
 */
+ (NSString *)getCarorgWithLsnum:(NSString *)lsnum;

#pragma mark -

/**
 *  检测用户名格式
 *
 *  @param str 字符串
 *
 *  @return bool
 */
+ (BOOL)checkQQ:(NSString *)qq;
//QQ
+ (BOOL)checkTel:(NSString *)tel;
//座机
+ (BOOL)checkTellandline:(NSString *)telland;
//邮箱
+ (BOOL)checkEmail:(NSString *)email;
//验证码
+ (BOOL)checkVerifyCode:(NSString *)code;
//用户名
+ (BOOL)checkUserName:(NSString *)username;
//密码
+ (BOOL)checkPassWord:(NSString *)password;
//用户输入
+ (BOOL)checkUserInput:(NSString *)input;
//身份证号
+ (BOOL)checkPersonID:(NSString *)personID;
/*车牌号验证 MODIFIED BY HELENSONG*/
+ (BOOL)checkCarNo:(NSString *)carNo;
/** 网址验证 */
+ (BOOL)checkURL:(NSString *)urlStr;
/**
 *  检查对象是不是null
 *
 *  @param imgStr 被检查的对象
 *
 *  @return 是 或者 不是 null
 */
+ (BOOL)checkImageURLIsNULL:(NSString *)imgStr;

#pragma mark -


/**
 根据时间戳获取时间字符串 (默认格式 yyyy-MM-DD)

 @param interval 时间戳

 @return 字符串
 */
+ (NSString *)dateStringFromInterval:(NSTimeInterval)interval;

/**
 根据时间戳获取时间字符串 (默认格式 yyyy-MM-DD)
 
 @param interval 时间戳
 
 @return 字符串
 */
+ (NSString *)dateStringFromInterval:(NSTimeInterval)interval withDateFormat:(NSString *)format;

/**
 *  把时间转化成字符串  YYYY - MM - DD
 *
 *  @param date 时间
 *
 *  @return 字符串时间
 */
+ (NSString *)dateStringFromDate:(NSDate *)date;

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
+ (NSString *)dateStringFromDate:(NSDate *)date withDateFormat:(NSString *)format;


/**
 根据目标时间,计算返回距离现在多久
 
 @param interval 时间戳
 
 @return 字符串
 */
+ (NSString *)compareCurrentTimeWithInterval:(NSTimeInterval)interval;


/**
 根据字符串和格式,计算距离今天多久
 
 @param dateStr 时间字符串
 @param formatStr 时间格式
 @return 多久
 */
+ (NSString *)compareCurrentTimeWithDateStr:(NSString *)dateStr andFormat:(NSString *)formatStr;



/**
 根据开始时间和结束时间,以及周几,计算一个时间数组
 */
+ (NSArray *)daysWithStartDate:(NSDate *)startDate
                  endDate:(NSDate *)endDate
                  weekStr:(NSString *)weekStr;

/**
 判断一个数组是否包含了一个日期
 
 @param arr  日期数组 (of NSDates)
 @param date 要查询的日期
 
 @return 是否包含
 */
+ (BOOL)hasDateInArr:(NSArray *)arr withDate:(NSDate *)date;

/**
 判断俩个时间是否在同一天
 
 @param date1 时间1
 @param date2 时间2
 
 @return 结果
 */
+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2;

/**
 获取星期几
 
 @param date 日期
 
 @return 星期字符串  1 2 3 4 5 6 7
 */
+ (NSString *)getWeekStrWithDate:(NSDate *)date;

#pragma mark - 扫描工具方法

/**
 判断扫描的二维码是不是约美的二维码
 
 @param codeString 扫描之后的字符串
 @return 是否是约美的扫描格式
 */
+ (BOOL)isYueMeiCode:(NSString *)codeString;

/**
 二维码类型
 
 @param codeString 整个二维码字符串
 @return 类型
 */
+ (NSString *)YueMeiCodeType:(NSString *)codeString;

/**
 订单号码
 
 @param codeString 整个二维码字符串
 @return 订单号
 */
+ (NSString *)YueMeiOrderNumber:(NSString *)codeString;


#pragma mark - UI相关的方法
//*******************************************
//UI相关的工具方法
//*******************************************

/**
 *  利用webView实现拨打电话的功能
 *
 *  @param phoneNumber 电话号码
 *  @param view        父视图
 */
+ (void)callPhone:(NSString *)phoneNumber withSuperView:(UIView *)view;


/**
 *	@brief	隐藏tableivew中多余的cell
 *
 *	@param 	tableview 	承载的Tableview
 */
+ (void)hiddleExtendCellForTableView:(UITableView *)tableView;

/**
 *  设置整个应用统一的返回按钮
 *
 *  @param image 返回按钮的图片
 */
+ (void)settingBackButtonImageWithImage:(UIImage *)image;

/**
 *  指定的tableView 滑动到最后一行
 *
 *  @param tableView tableView
 *  @param animated  是否动画显示
 */
+ (void)scrollToFootWithTableView:(UITableView *)tableView isAnimated:(BOOL)animated;


/**
 *
 *  @param image     要缩放的image
 *  @param scaleSize 缩放的比例
 *
 *  @return 缩放后的图片
 */
+ (UIImage *)scaleImage:(UIImage *)image withScale:(float)scale;

/**
 *  将UIImage旋转
 *
 *  @param image       要旋转的图片
 *  @param orientation 方向
 *
 *  @return 旋转完成之后的图片
 */
+ (UIImage *)rotateImage:(UIImage *)image rotation:(UIImageOrientation)orientation;


//计算高度
+ (CGFloat)heightForLabel:(UILabel *)label
                 WithText:(NSString *)text
                    width:(CGFloat)width;

/**
 *  自动计算label的高度(宽度可以传)
 */
+ (CGFloat)heightForLabel:(UILabel *)label
                 WithText:(NSString *)text
                 fontName:(NSString *)fontName
                 fontSize:(CGFloat)fontSize
                    width:(CGFloat)width;

//计算高度
+ (CGFloat)heightForTextView:(UITextView *)textView
                    WithText:(NSString *)text
                       width:(CGFloat)width;

/**
 计算文本的宽度
 
 @param label  label
 @param text  文字
 @param height 容器最大高度
 @return 文本宽度
 */
+ (CGFloat)widthForLabel:(UILabel *)label
                withText:(NSString *)text
                  height:(CGFloat)height;

/**
 *  显示文字
 *
 *  @param message 要显示的文字
 */
+ (void)showMessage:(NSString *)message;

/**
 *  获取最顶端当前屏幕显示的viewcontroller
 *
 *  @return viewcontroller
 */
+ (UIViewController *)getCurrentVC;

+ (UIViewController *)getPresentedViewController;

/**
 *  将imageStr转化为图片
 */
+ (UIImage *)imageWithString:(NSString *)imageString;

/* 计算两个时间差*/
+ (NSString *)intervalFromLastDate:(NSString *)startDate toTheDate:(NSString *)endDate;


@end
