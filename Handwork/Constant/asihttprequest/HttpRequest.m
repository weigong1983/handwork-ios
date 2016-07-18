//
//  HttpRequest.m
//  WTRequestCenter
//
//  Created by apple on 15-5-11.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "HttpRequest.h"
#import "ASIFormDataRequest.h"
#import <CommonCrypto/CommonDigest.h>
#import "StringUtil.h"

@implementation HttpRequest
//#define NETWORK_TIMEOUT 60.0

+(ASIHTTPRequest*)requestPost:(NSString *)url Dic:(NSDictionary *)dic authorization:(BOOL)yes
{
    
    
    NSMutableString* theUrl = [NSMutableString string];
    
    if (IS_DEBUG)
        [theUrl  setString:API_BASE_DEBUG];
    else
        [theUrl  setString:API_BASE];
    
    [theUrl appendString:url];
    //NSLog(@"地址: %@",theUrl);
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:theUrl]];
    
    
    
    NSMutableString *theSig = [NSMutableString string];
    
    
    if (dic!=nil) {
        NSString *key;
        for(key in dic)
        {
            [theSig appendString:[NSString stringWithFormat:@"%@=%@", key,[dic objectForKey:key]]];
        }
    }
    
    [theSig appendString:[NSString stringWithFormat:@"appkey=%@", @"14u30u97d86c69a"]];
    
    // 授权处理
    NSString *auth = nil;
    
    //NSString* sig;
    
    //如果要验证签名
    if (yes)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *token = [NSString stringWithFormat:@"%@",[defaults objectForKey:API_TOKEN]];
        
        NSString *secret =[NSString stringWithFormat:@"%@",[defaults objectForKey:API_SECRET]];
        
        [theSig appendString:secret];
        NSString *sig =[StringUtil stringToSha1:theSig];
        auth = [NSString stringWithFormat:@"token=%@,appkey=%@,sig=%@", token, @"14u30u97d86c69a", sig];
        //UILog(@"token: %@",token);
    }else
    {
        [theSig appendString:@"6531ybti5593tlci4860bcus2200osqi"];
        NSString *sig = [StringUtil stringToSha1:theSig];
        auth = [NSString stringWithFormat:@"appkey=%@,sig=%@", @"14u30u97d86c69a",sig];
        //NSLog(@"auth:---->   %@",auth);
    }
    
    
    NSMutableString* body = [NSMutableString string];
    //有数据的情况
    if (dic!=nil){
        NSString* key;
        for (key in dic)
        {
            [theSig appendString:[NSString stringWithFormat:@"%@=%@",key,[dic objectForKey:key]]];
            [request setPostValue:[dic objectForKey:key] forKey:key];
            [body appendFormat:@"%@=%@&",key,[dic objectForKey:key]];
        }
    }
     //NSLog(@"theSig:---->   %@",theSig);
    //ningwei 修改
    if ([body length]>0){
        [body deleteCharactersInRange:NSMakeRange([body length]-1, 1)];
    }
    //UILog(@"auth:---->%@  Body%@",auth,body);
    request.postFormat = ASIURLEncodedPostFormat;
    
    [request addRequestHeader:@"Authorization" value:auth];
    
    [request setTimeOutSeconds: NETWORK_TIMEOUT];
    
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    return request;
}


#pragma mark - URL
+(NSString *)urlModule:(NSInteger)index
{
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    [urls addObject:@"Account"];
    [urls addObject:@"HomePage"];
    [urls addObject:@"Activity"];
    [urls addObject:@"Messages"];
    [urls addObject:@"Find"];
    [urls addObject:@"HomePage"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    
    //  10-19
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    
    
    
    NSString *url = urls[index];
    NSString *urlString = [NSString stringWithFormat:@"%@",url];
    return urlString;
}
//实际应用示例
+(NSString*)urlWithIndex:(NSInteger)index
{
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    //  0-9
    [urls addObject:@"login"];
    [urls addObject:@"getRecommendWorks"];
    [urls addObject:@"getTopActivity"];
    [urls addObject:@"getWorksIndex"];
    [urls addObject:@"detailActivity"];
    [urls addObject:@"joinActivity"];
    [urls addObject:@"cancelActivity"];
    [urls addObject:@"worksIndex"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    
    //  10-19
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    
    
    
    NSString *url = urls[index];
    NSString *urlString = [NSString stringWithFormat:@"%@",url];
    return urlString;
}
@end
