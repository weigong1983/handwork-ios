#import "StringUtils.h"

@implementation StringUtils


/*
 * 获取App名字
 */
+ (NSString *) getAppName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

/*
 * 获取App 版本号
 */
+ (NSString *) getAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

/*
 * 获取App build版本
 */
+ (NSString *) getAppBuildVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

@end