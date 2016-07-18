//
//  FileTools.m
//  Handwork
//
//  Created by mac on 15/6/17.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import "FileTools.h"
#import "AudioToolbox/AudioToolbox.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <sys/xattr.h>

@implementation FileTools

/**
	生成当前时间字符串
	@returns 当前时间字符串
 */
+ (NSString*)getCurrentTimeString
{
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyy-MM-dd-HHmmss"];
    return [dateformat stringFromDate:[NSDate date]];
}


/**
	获取缓存路径
	@returns 缓存路径
 */

+ (NSString*)getCacheDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    
//    return [[paths objectAtIndex:0]stringByAppendingPathComponent:@"Voice"];
}

/**
	判断文件是否存在
	@param _path 文件路径
	@returns 存在返回yes
 */
+ (BOOL)fileExistsAtPath:(NSString*)_path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:_path];
}

-(NSString *)recordPathOrigin{
    NSString * filePath;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *str1 = NSHomeDirectory();
    filePath = [NSString stringWithFormat:@"%@/Documents/Record/record.wav",str1];
    
    if(![fileManager fileExistsAtPath:filePath]){
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *directryPath = [path stringByAppendingPathComponent:@"Record"];
        [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *filePath = [directryPath stringByAppendingPathComponent:@"record.wav"];
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    [self skipICloud:filePath];
    
    return filePath;
}
- (void)skipICloud:(NSString*)url{
    u_int8_t b = 1;
    if (nil == url ) {
        return;
    }
    setxattr([url fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
}

- (NSString *)recordPathAMRToWAV{
    NSString * filePath;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *str1 = NSHomeDirectory();
    filePath = [NSString stringWithFormat:@"%@/Documents/Record/new_record.wav",str1];
    
    if(![fileManager fileExistsAtPath:filePath]){
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *directryPath = [path stringByAppendingPathComponent:@"Record"];
        [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *filePath = [directryPath stringByAppendingPathComponent:@"new_record.wav"];
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    [self skipICloud:filePath];
    
    return filePath;
}

/**
	删除文件
	@param _path 文件路径
	@returns 成功返回yes
 */
+ (BOOL)deleteFileAtPath:(NSString*)_path
{
    return [[NSFileManager defaultManager] removeItemAtPath:_path error:nil];
}

/**
	生成文件路径
	@param _fileName 文件名
	@param _type 文件类型
	@returns 文件路径
 */
+ (NSString*)getPathByFileName:(NSString *)_fileName ofType:(NSString *)_type
{
    NSString* fileDirectory = [[[FileTools getCacheDirectory]stringByAppendingPathComponent:_fileName]stringByAppendingPathExtension:_type];
    return fileDirectory;
}

/**
 生成文件路径
 @param _fileName 文件名
 @returns 文件路径
 */
+ (NSString*)getPathByFileName:(NSString *)_fileName{
    NSString* fileDirectory = [[FileTools getCacheDirectory]stringByAppendingPathComponent:_fileName];
    return fileDirectory;
}

/**
	获取录音设置
	@returns 录音设置
 */
+ (NSDictionary*)getAudioRecorderSettingDict
{
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                   //                                   [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                                   nil];
    return recordSetting;
}
@end
