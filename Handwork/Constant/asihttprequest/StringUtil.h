//
//  StringUtil.h
//  AndianDistribution
//
//  Created by shoujifeng on 14-8-29.
//  Copyright (c) 2014年 周文超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StringUtil : NSObject


/**
 *从URL中获取字段值
 **/
+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName;
/**
 *获取当前时间戳
 **/
+ (NSString*)getNowDate;
//设置今天
+(NSString*)setTimetodayNSString:(CGFloat)time;

+(NSString*)setTimetodayNSString1:(CGFloat)time;
//根据一个时间秒数转成时间戳

//无年
+(NSString*)getMS:(CGFloat)time setDateFormat:(NSString*)str;


+ (BOOL) isBlankString:(NSString *)string;

/**
 *MD5加密 32位MD5小写
 **/
+ (NSString*)md5Digest:(NSString *)str;
/**
 * 哈西加密
 **/
+ (NSString *)stringToSha1:(NSString *)str;
/**
 * 解析
 **/
+ (NSDictionary *)analysisURL:(NSString *)URL;
/**
 * 得到一个大于当前的时间 －  当前 时间 还剩多少天-多少小时-多少分-多少秒
 **/
+(NSString *)intervalSinceNow:(CGFloat)overtime;
/**
 * 启动浏览界面，打开网页 加分享shareContent
 **/
+(void)startWebview:(NSString *)url withTitle:(NSString *)title withShareContent:(NSString *)shareContent withShareEnable:(BOOL)shareEnable andViewController:(UIViewController*)viewController;
+ (NSString*)GetdeviceString;
/*
 * 图片转换为字符串
 */
//+ (NSString *) image2String:(UIImage *)image;

/*
 * 字符串转换为图片
 */
//+ (UIImage *) string2Image:(NSString *)string;
@end
