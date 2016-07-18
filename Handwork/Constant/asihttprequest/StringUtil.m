//
//  StringUtil.m
//  AndianDistribution
//
//  Created by shoujifeng on 14-8-29.
//  Copyright (c) 2014年 周文超. All rights reserved.
//

#import "StringUtil.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "JSONKit.h"
#import "sys/utsname.h"

@implementation StringUtil
+(NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName
{
    if (![paramName hasSuffix:@"="])
    {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }
    
    NSString * str = nil;
    NSRange start = [url rangeOfString:paramName];
    if (start.location != NSNotFound)
    {
        // confirm that the parameter is not a partial name match
        unichar c = '?';
        if (start.location != 0)
        {
            c = [url characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#')
        {
            NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
            NSUInteger offset = start.location+start.length;
            str = end.location == NSNotFound ?
            [url substringFromIndex:offset] :
            [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return str;
}
+(BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL){
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
+ (NSString*)GetdeviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}
+(NSString*)setTimetodayNSString:(CGFloat)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *dateSMS = [dateFormatter stringFromDate:date];
    NSDate *now = [NSDate date];
    NSString *dateNow = [dateFormatter stringFromDate:now];
    
    if ([dateSMS isEqualToString:dateNow])
    {
        [dateFormatter setDateFormat:@"今天"];
        //UILog(@"今天: %@",dateSMS);
    }
    else {
        [dateFormatter setDateFormat:@"MM月dd日"];
    }
    dateSMS = [dateFormatter stringFromDate:date];
    //UILog(@"dateSMS:  %@",dateSMS);
    //UILog(@"今天: %@",dateSMS);
    
    return dateSMS;
}

+(NSString*)setTimetodayNSString1:(CGFloat)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *dateSMS = [dateFormatter stringFromDate:date];
    NSDate *now = [NSDate date];
    NSString *dateNow = [dateFormatter stringFromDate:now];
    if ([dateSMS isEqualToString:dateNow])
    {
        [dateFormatter setDateFormat:@"今天 HH:mm"];
        //UILog(@"今天: %@",dateSMS);
    }
    else {
        [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    }
    dateSMS = [dateFormatter stringFromDate:date];
    //UILog(@"dateSMS:  %@",dateSMS);
    //UILog(@"今天: %@",dateSMS);
    
    dateSMS = [dateFormatter stringFromDate:date];
    return dateSMS;
}

+(NSString*)getMS:(CGFloat)time setDateFormat:(NSString*)str
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [dateFormatter setDateFormat:str];
    //用[NSDate date]可以获取系统当前时间

    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    
    return currentDateStr;
}
//getMS1


//-(void)GetTime
//{
//    //根据字符串转换成一种时间格式 供下面解析
//    NSString* string = @"2013-07-16 13:21";
//    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
//    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSDate* inputDate = [inputFormatter dateFromString:string];
//    
//    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *comps = [[[NSDateComponents alloc] init];
//    NSInteger unitFlags = NSYearCalendarUnit |
//    NSMonthCalendarUnit |
//    NSDayCalendarUnit |
//    NSWeekdayCalendarUnit |
//    NSHourCalendarUnit |
//    NSMinuteCalendarUnit |
//    NSSecondCalendarUnit;
//    
//    comps = [calendar components:unitFlags fromDate:inputDate];
//    NSInteger week = [comps weekday];
//    NSString *strWeek = [self getweek:week];
//    //self.textfield.text = strWeek;
//    NSLog(@"week is:%@",strWeek);
//}




-(NSString*)getweek:(NSInteger)week
{
    NSString*weekStr=nil;
    if(week==1)
    {
        weekStr=@"星期天";
    }else if(week==2){
        weekStr=@"星期一";
        
    }else if(week==3){
        weekStr=@"星期二";
        
    }else if(week==4){
        weekStr=@"星期三";
        
    }else if(week==5){
        weekStr=@"星期四";
        
    }else if(week==6){
        weekStr=@"星期五";
        
    }else if(week==7){
        weekStr=@"星期六";
        
    }
    return weekStr;
}

+ (NSString *)getNowDate
{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[[NSDateFormatter alloc] init]autorelease];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    //return [NSString stringWithFormat:@"%ld", time(NULL)];
    return locationString;
}
+(NSString*)md5Digest:(NSString *)str{
    //32位MD5小写
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    
    CC_MD5( cStr,strlen(cStr), result );
    
    return [NSString stringWithFormat:
            
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ];
}
+ (NSDictionary *)analysisURL:(NSString *)URL
{
    NSString *URLEncoding = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *nsURL = [NSURL URLWithString:URLEncoding];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:nsURL];
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] init];
    NSData *retData = [NSURLConnection sendSynchronousRequest:theRequest
                                            returningResponse:&response error:nil];
    NSString *json=[[[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding]autorelease];
    NSDictionary *dic=[json objectFromJSONString];
    return dic;
}
+ (NSString *)stringToSha1:(NSString *)str{
    const char *s = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
    CC_SHA1(keyData.bytes,keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    hash = [hash uppercaseString];
    return hash;
}
// 得到一个大于当前的时间 －  当前 时间 还剩多少天-多少小时-多少分-多少秒
+(NSString *)intervalSinceNow:(CGFloat)overtime
{
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM月dd日 HH:mm:ss"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:overtime];
    
    NSString *timeString=@"";
    
    NSDateFormatter *format=[[[NSDateFormatter alloc] init]autorelease];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate *fromdate=[format dateFromString:theDate];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate:date];
    NSDate *fromDate = [date  dateByAddingTimeInterval: frominterval];
    
    //获取当前时间
    NSDate *adate = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: adate];
    NSDate *localeDate = [adate  dateByAddingTimeInterval: interval];
    
    double intervalTime = [fromDate timeIntervalSinceReferenceDate] - [localeDate timeIntervalSinceReferenceDate];
    long lTime = fabs((long)intervalTime);
    NSInteger iSeconds =  lTime % 60;
    NSInteger iMinutes = (lTime / 60) % 60;
    NSInteger iHours = fabs(lTime/3600);
    NSInteger iDays = lTime/60/60/24;
    //    NSInteger iMonth =lTime/60/60/24/12;
    //    NSInteger iYears = lTime/60/60/24/384;
    
    
    //NSLog(@"%d天%d时%d分%d秒",iDays,iHours,iMinutes,iSeconds);
    
    
    //    if (iHours<1 && iMinutes>0)
    //    {
    //        timeString=[NSString stringWithFormat:@"%d分",iMinutes];
    //
    //    }else if (iHours>0&&iDays<1 && iMinutes>0) {
    //        timeString=[NSString stringWithFormat:@"%d时%d分",iHours,iMinutes];
    //    }
    //    else if (iHours>0&&iDays<1) {
    //        timeString=[NSString stringWithFormat:@"%d时",iHours];
    //    }else if (iDays>0 && iHours>0)
    //    {
    //        timeString=[NSString stringWithFormat:@"%d天%d时",iDays,iHours];
    //    }
    if (iDays==0)
    {
        timeString=[NSString stringWithFormat:@"%ld时%ld分%ld秒",(long)iHours,(long)iMinutes,(long)iSeconds];
    }
    if(iHours>=24)
    {
        iHours = iHours%24;
        //iDays +=1;
    }
    if (iDays>=1) {
        timeString=[NSString stringWithFormat:@"%ld天%ld时%ld分%ld秒",(long)iDays,(long)iHours,(long)iMinutes,(long)iSeconds];
    }
    
    return timeString;
}
+(void)startWebview:(NSString *)url withTitle:(NSString *)title withShareContent:(NSString *)shareContent withShareEnable:(BOOL)shareEnable andViewController:(UIViewController*)viewController;
{
    //NSLog(@"打开网页：【%@】标题：[%@]", url, title);
//    WebDetailViewController *web = [[WebDetailViewController alloc]initWithNibName:@"WebDetailViewController" bundle:nil];
//    web.html = url;
//    web.ProName = title;
//    web.shareContent = shareContent;
//    web.shareEnable = shareEnable;
//    [viewController.navigationController pushViewController:web animated:YES];
//    [web release];
}

#pragma mark -  > > > > > > > > > > > > > > > > >  NSString / NSData / char* 类型之间的转换  > > > > > > > > > > > > > > > > >
+(void)memcpyWantToConvert:(NSString*)str
{
    NSString* fname = @"Test";
    char fnameStr[10];
    memcpy(fnameStr, [str cStringUsingEncoding:NSUnicodeStringEncoding], 2*([fname length]));
}

-(void)NSStringTest
{
    //char * 转化为 NSString
    //NSString 转化为 char *
    //const char * a =[str UTF8String];
    //return a;
    
    //-(NSString*)WantToConvert:(char*)str
    //{
    //   return [NSString stringWithCString  encoding:NSUTF8StringEncoding];
    //}
    //char * 转化 NSData
    //char * a = (char*)malloc(sizeof(byte)*16);
    //NSData *data = [NSData dataWithBytes: a   length:strlen(a)];
    
    
    
    //转换为NSString： - (id)initWithUTF8String:(const char *)bytes
    //然后用NSString的 - (NSData *)dataUsingEncoding:(NSStringEncoding)encoding
    //
    //NSData 转化 char *
    //NSData data ；
    //char* a=[data bytes];
    //
    //NSData 转化 NSString;
    //NSData* data;
    //NSString* aStr= ［NSString alloc] initWithData:data   encoding:NSASCIIStringEncoding];
    //
    //7. NSString 转化 NSData对象
    //
    //NSData* xmlData = [@"testdata" dataUsingEncoding:NSUTF8StringEncoding];
    //
    //http://blog.sina.com.cn/s/articlelist_1256141290_14_1.html
    //
    //NSString 转化 NSURL
    ////NSURL *url = [NSURL URLWithString:[str   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
    //NSString *urlString=[@"http://www.google.com/search?client=safari&rls=en&q=搜索&ie=UTF-8&oe=UTF-8" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSURL 转化 NSString
    //NSURL *url=[NSURL URLWithString:urlString];
    //NSString *s=[[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    //NSArray *arr = [urlStr componentsSeparatedByString:@"&"];
    //NSURL *url = [NSURL URLWithString:[[arr objectAtIndex:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //[request setHTTPMethod:@"POST"];
    //
    //NSMutableArray *_array = [[NSMutableArray alloc] initWithCapacity:0];
    //for (int i = 1; i < [arr count]; ++i ){
    //    NSString *str = [arr objectAtIndex:i];
    //    [_array addObject:str];
    //}
    //[_array componentsJoinedByString:@"&"];
    //NSData *data = [[_array componentsJoinedByString:@"&"] dataUsingEncoding: NSASCIIStringEncoding];
    //[request setHTTPBody:data];
    //发送请求并获得服务器反馈的数据
    //NSData *urldata = [AESEnCDeCViewController Get:url];
    
    // 第一种 转换NSData数据到char*字符串
    //char * test = (char*)[urldata bytes];
    //std::string old = deaes(test);
    
    // 第二种 转换NSData到UTF8编码的NSString中再转换为char*字符串
    //    NSString *desStr = [[NSString alloc] initWithData:urldata encoding:NSUTF8StringEncoding];
    //    const char *desresult = [desStr UTF8String];
    //    std::string old = deaes(desresult);
    
    // 解密字字符串到明文
    //NSString *oldstr = [[NSString alloc] initWithCString:old.c_str()];
    
    
    //很多时候软件读取的中文网页编码集是gb2312，所以显示出来的是乱码。这时需要将NSString文字编码转换
    //1 NSURL *url = [NSURL URLWithString:urlStr];
    //2 NSData *data = [NSData dataWithContentsOfURL:url];
    //3 NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //4 NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
}

@end
