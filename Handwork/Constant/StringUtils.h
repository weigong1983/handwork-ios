#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface StringUtils : NSObject {
	
}

/*
 * 获取App名字
 */
+ (NSString *) getAppName;

/*
 * 获取App 版本号
 */
+ (NSString *) getAppVersion;

/*
 * 获取App build版本
 */
+ (NSString *) getAppBuildVersion;


@end