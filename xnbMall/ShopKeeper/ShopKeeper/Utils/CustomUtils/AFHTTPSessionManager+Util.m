//
//  AFHTTPRequestOperationManager+Util.m
//  TaskGanGan
//
//  Created by zzheron on 15/11/2.
//  Copyright © 2015年 zzheron. All rights reserved.
//

#import "AFHTTPSessionManager+Util.h"

//#import <AFOnoResponseSerializer.h>
#import <UIKit/UIKit.h>
#import "UIDevice+ProcessesAdditions.h"

@implementation AFHTTPSessionManager (Util)

+ (instancetype)RWTXmlManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:[self generateUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    return manager;
}



+ (instancetype)RWTJsonManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
;
    [manager.requestSerializer setValue:[self generateUserAgent] forHTTPHeaderField:@"User-Agent"];
    manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    //manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    
    return manager;
}


+ (instancetype)RWTManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    //manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 120.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager.requestSerializer setValue:[self generateUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    return manager;
}



+ (NSString *)generateUserAgent
{
    //NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    //NSString *IDFV = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    //NSLog(@"uniqueIdentifier: %@", [[UIDevice currentDevice] uniqueIdentifier]);
    //NSLog(@"name: %@", [[UIDevice currentDevice] name]);
    //NSLog(@"systemName: %@", [[UIDevice currentDevice] systemName]);
    //NSLog(@"systemVersion: %@", [[UIDevice currentDevice] systemVersion]);
    //NSLog(@"model: %@", [[UIDevice currentDevice] model]);
    //NSLog(@"localizedModel: %@", [[UIDevice currentDevice] localizedModel]);
    
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //NSLog(@"infoDictionary:%@",infoDictionary);
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleExecutable"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    //NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSString *app_label = [NSString stringWithFormat:@"%@_v%@", app_Name, app_Version];
    NSString *app_model = [UIDevice getCurrentDeviceModel];
    
    return [NSString stringWithFormat:@"%@/%@/%@/%@", app_label,
            [UIDevice currentDevice].systemName,
            [UIDevice currentDevice].systemVersion,
            app_model];
}

@end
