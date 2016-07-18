//
//  HttpRequest.h
//  WTRequestCenter
//
//  Created by apple on 15-5-11.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "Config.h"
#import "API.h"
@interface HttpRequest : NSObject
+(ASIHTTPRequest*)requestPost:(NSString*)url Dic:(NSDictionary*)dic authorization:(BOOL)yes;
#pragma mark - URL
+(NSString *)urlModule:(NSInteger)index;

//实际应用示例
+(NSString*)urlWithIndex:(NSInteger)index;
@end
