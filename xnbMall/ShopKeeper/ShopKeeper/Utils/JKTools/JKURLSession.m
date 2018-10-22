//
//  JKURLSession.m
//  InnWaiter
//
//  Created by xnb on 16/7/27.
//  Copyright © 2016年 51xnb. All rights reserved.
//

#import "JKURLSession.h"

#import "TransDataProxy2.h" //error domain macro
#import "ShareUnity.h"
#import "JKTool.h"

@implementation JKURLSession

/**
 *  @author 黎国基, 16-08-01 11:08
 *
 *  网络请求方法，使用默认的BaseUrl，拼接method形成完整URL
 *
 *  @param method       具体的方法
 *  @param parameterDic 请求的参数，传入http body
 *  @param token        该方法是否需要token（若需要，则在方法内自动添加登录时返回的并保存的token）
 *  @param resultBlock  回调block（以及对code != 200的情形进行处理，返回error）
 */

+(void)taskWithMethod:(NSString *)method parameter:(NSDictionary *)parameterDic token:(BOOL)token resultBlock:(void(^)(NSDictionary *resultDic,NSError *error))resultBlock
{
    
    NSString *combinedUrlStr = [NSString stringWithFormat:@"%@/%@",SERVER_ADDR_XNBMALL,method];
    NSURL *url = [NSURL URLWithString:combinedUrlStr];
    
    NSLog(@"url:%@",combinedUrlStr);
    
    NSData *requestBody = [self getHttpBodyData:parameterDic];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:12];
    
    [request setHTTPMethod:@"POST"];
    
    if (token) {
        NSString* tokenStr = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
        
        if (tokenStr == nil) {
//            resultBlock(nil,[NSError errorWithDomain:@"CustomErrorDomain" code:-998 userInfo:@{NSLocalizedDescriptionKey:@"用户未登录！"}]);
//            return;
        }else {
            [request setValue:tokenStr forHTTPHeaderField:@"x_token"];
        }
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];//请求头
    //
    NSDictionary *sysConfig = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [sysConfig objectForKey:@"CFBundleShortVersionString"];
    
    NSString *headTemp = [NSString stringWithFormat:@"os=%@;device=%@;app=%@;appversion=%@",[[UIDevice currentDevice] systemVersion] ,[[UIDevice currentDevice] systemName],@"nongzhanggui",version];
    [request setValue:headTemp forHTTPHeaderField:@"Client-Info"];
    //
    
    [request setHTTPBody:requestBody];
    
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];//数据转为nsstring型
        NSLog(@"response: %@",result);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error != nil) {
                resultBlock(nil,[self createError:ERROR_DOMAIN_REQUEST code:error.code desc:error.localizedDescription]);
                return ;
            }
            
            NSDictionary *allHeaders = ((NSHTTPURLResponse*)response).allHeaderFields;
            //        NSLog(@"method,%@,allHeaders:%@",method,allHeaders);
            NSString *x_token = allHeaders[@"x_token"];
            if(![JKTool isNilStrOrSpace:x_token]){
                [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:LOGIN_TOKEN object:x_token];
            }
            
            NSInteger statusCode = ((NSHTTPURLResponse*)response).statusCode;
            if (statusCode != 200) {
                resultBlock(nil,[self createError:ERROR_DOMAIN_HTTP code:statusCode desc:@"无法连接服务器"]);
                return;
            }
            
            if (data == nil) {
                resultBlock(nil,[self createError:ERROR_DOMAIN_BUSINESS code:-999 desc:@"无数据"]);
                return ;
            }
            
            //        NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            
            NSError* jsonError = nil;
            NSDictionary* dicResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];//将NSData类型的实例转成JSONObject，使用缓冲区数据来解析
            
            
            if (dicResult == nil) {
                
                resultBlock(nil,[self createError:ERROR_DOMAIN_JSON code:-2 desc:@"错误：返回数据格式不是json格式"]);
                return;
            }
            
            
            NSNumber* code = [dicResult objectForKey:@"code"];
            
            if([code integerValue] == 401){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ShareUnity removeTheUserInformation];
                    [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:DICKEY_LOGIN];
                    [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:LOGIN_PHONE];
                    [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:LOGIN_SHOPNAME];
                    [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:MALL_IS_LOGIN];//商城的登录判断
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userinfo"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [MyUtile delUserDataUiyp];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"userReLogin" object:nil];
                });
                
                resultBlock(nil,[NSError errorWithDomain:@"CustomErrorDomain" code:-998 userInfo:@{NSLocalizedDescriptionKey:@"用户未登录！"}]);
                return;
            }
            
            NSString* message = [dicResult objectForKey:@"msg"];
            if (code == nil ) {
                resultBlock(nil,[self createError:ERROR_DOMAIN_BUSINESS code:-998 desc:@"无数据"]);
                return;
            }
            
            if ([code integerValue] == 200) {
                resultBlock(dicResult,nil);
                return;
            }else{
                resultBlock(nil,[self createError:ERROR_DOMAIN_BUSINESS code:[code integerValue] desc:message]);//NSLocalizedDescriptionKey
                return;
            }
        });
    }];
    
    [task resume];
}


/**
 *  @author 黎国基, 16-08-01 11:08
 *
 *  网络请求方法，使用默认的BaseUrl，拼接method形成完整URL
 *
 *  @param method       具体的方法
 *  @param parameterDic 请求的参数，传入http body
 *  @param token        该方法是否需要token（若需要，则在方法内自动添加登录时返回的并保存的token）
 *  @param resultBlock  回调block，返回的是html字符串，可直接用webview载入
 */

+(void)getHtmlWithMethod:(NSString *)method parameter:(NSDictionary *)parameterDic token:(BOOL)token resultBlock:(void(^)(NSString *htmlStr,NSError *error))resultBlock
{
    
    NSString *combinedUrlStr = [NSString stringWithFormat:@"%@/%@",SERVER_ADDR_XNBMALL,method];
    NSURL *url = [NSURL URLWithString:combinedUrlStr];
    
    NSLog(@"%@",combinedUrlStr);
    
    NSData *requestBody = [self getHttpBodyData:parameterDic];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:12];
    
    [request setHTTPMethod:@"POST"];
    
    if (token) {
        NSString* tokenStr = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
        
        if (tokenStr == nil) {
            //            resultBlock(nil,[NSError errorWithDomain:@"CustomErrorDomain" code:-998 userInfo:@{NSLocalizedDescriptionKey:@"用户未登录！"}]);
            //            return;
        }else {
            [request setValue:tokenStr forHTTPHeaderField:@"x_token"];
        }
    }
    
    //设置数据类型
    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    //设置编码
    [request setValue:@"UTF-8" forHTTPHeaderField:@"charset"];
    
    [request setHTTPBody:requestBody];
    
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];//数据转为nsstring型
        NSLog(@"response: %@",result);
        
        if (error != nil) {
            resultBlock(nil,[self createError:ERROR_DOMAIN_REQUEST code:error.code desc:error.localizedDescription]);
            return ;
        }
        
        NSInteger statusCode = ((NSHTTPURLResponse*)response).statusCode;
        
        if (statusCode != 200) {
            resultBlock(nil,[self createError:ERROR_DOMAIN_HTTP code:statusCode desc:@"无法连接服务器"]);
            return;
        }
        
        if (data == nil) {
            resultBlock(nil,[self createError:ERROR_DOMAIN_BUSINESS code:-999 desc:@"无数据"]);
            return ;
        }
        
        resultBlock(result,nil);
        
    }];
    
    [task resume];
}

+ (void)uploadFile:(NSData *)fileData fileName:(NSString *)fileName resultBlock:(void(^)(NSString *fileId,NSError *error))resultBlock {
    
    
    NSString *combinedUrlStr = [NSString stringWithFormat:@"%@/file/appUpload.do",SERVER_ADDR];
    NSURL *url = [NSURL URLWithString:combinedUrlStr];
    
    NSLog(@"%@",combinedUrlStr);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:12];
    
    [request setHTTPMethod:@"POST"];

    NSString* tokenStr = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    
    if (tokenStr == nil) {
        resultBlock(nil,[NSError errorWithDomain:@"CustomErrorDomain" code:-998 userInfo:@{NSLocalizedDescriptionKey:@"用户未登录！"}]);
        return;
    }
    [request setValue:tokenStr forHTTPHeaderField:@"x_token"];
    [request setValue:fileName forHTTPHeaderField:@"x_file_name"];
    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];       //设置数据类型
    
    [request setHTTPBody:fileData];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];//数据转为nsstring型
        NSLog(@"response: %@",result);
        
        if (error != nil) {
            resultBlock(nil,[self createError:ERROR_DOMAIN_REQUEST code:error.code desc:error.localizedDescription]);
            return ;
        }
        
        NSInteger statusCode = ((NSHTTPURLResponse*)response).statusCode;
        
        if (statusCode != 200) {
            resultBlock(nil,[self createError:ERROR_DOMAIN_HTTP code:statusCode desc:@"无法连接服务器"]);
            return;
        }
        
        if (data == nil) {
            resultBlock(nil,[self createError:ERROR_DOMAIN_BUSINESS code:-999 desc:@"无数据"]);
            return ;
        }
        
        //        NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSError* jsonError = nil;
        NSDictionary* dicResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];//将NSData类型的实例转成JSONObject，使用缓冲区数据来解析
        if (dicResult == nil) {
            resultBlock(nil,[self createError:ERROR_DOMAIN_JSON code:-2 desc:@"错误：返回数据格式不是json格式"]);
            return;
        }
        
        
        NSNumber* code = [dicResult objectForKey:@"code"];
        
        if([code integerValue] == 401){
            dispatch_async(dispatch_get_main_queue(), ^{
                [ShareUnity removeTheUserInformation];
                [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:DICKEY_LOGIN];
                [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:LOGIN_PHONE];
                [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:LOGIN_SHOPNAME];
                [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:MALL_IS_LOGIN];//商城的登录判断
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userinfo"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [MyUtile delUserDataUiyp];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"userReLogin" object:nil];
            });
            return;
        }
        
        NSString* message = [dicResult objectForKey:@"msg"];
        if (code == nil ) {
            resultBlock(nil,[self createError:ERROR_DOMAIN_BUSINESS code:-998 desc:@"无数据"]);
            return;
        }
        
        if ([code integerValue] == 200) {
            resultBlock(dicResult[@"data"],nil);
            return;
        }else{
            resultBlock(nil,[self createError:ERROR_DOMAIN_BUSINESS code:[code integerValue] desc:message]);//NSLocalizedDescriptionKey
            return;
        }
    }];
    
    
//    [[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:fileData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];//数据转为nsstring型
//        NSLog(@"response: %@",result);
//        
//        if (error != nil) {
//            resultBlock(nil,[self createError:ERROR_DOMAIN_REQUEST code:error.code desc:error.localizedDescription]);
//            return ;
//        }
//        
//        NSInteger statusCode = ((NSHTTPURLResponse*)response).statusCode;
//        
//        if (statusCode != 200) {
//            resultBlock(nil,[self createError:ERROR_DOMAIN_HTTP code:statusCode desc:@"http error"]);
//            return;
//        }
//        
//        if (data == nil) {
//            resultBlock(nil,[self createError:ERROR_DOMAIN_BUSINESS code:-999 desc:@"no data"]);
//            return ;
//        }
//        
//        //        NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
//        NSError* jsonError = nil;
//        NSDictionary* dicResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];//将NSData类型的实例转成JSONObject，使用缓冲区数据来解析
//        if (dicResult == nil) {
//            resultBlock(nil,[self createError:ERROR_DOMAIN_JSON code:-2 desc:@"return data is not json"]);
//            return;
//        }
//        
//        
//        NSNumber* code = [dicResult objectForKey:@"code"];
//        NSString* message = [dicResult objectForKey:@"msg"];
//        if (code == nil ) {
//            resultBlock(nil,[self createError:ERROR_DOMAIN_BUSINESS code:-998 desc:@"not return data"]);
//            return;
//        }
//        
//        if ([code integerValue] == 200) {
//            resultBlock(dicResult[@"data"],nil);
//            return;
//        }else{
//            resultBlock(nil,[self createError:ERROR_DOMAIN_BUSINESS code:[code integerValue] desc:message]);//NSLocalizedDescriptionKey
//            return;
//        }
//    }];
    
    [task resume];
}

/**
 *  @author 黎国基, 16-08-01 11:08
 *
 *  把参数表dictionary转成json data
 *
 *  @param param http请求的参数表
 *
 *  @return 转化后的json data
 */
+ (NSData*) getHttpBodyData:(NSDictionary*)param{
    NSError *error = nil;
    
    if (param == nil) {
        return nil;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];//将JSONObject的实例转成NSData
    if (error) {
        NSLog(@"dic->%@",error);
        return nil;
    }
    
    NSString* jsonText = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"requestJson: %@",jsonText);
    
    return jsonData;
}

/**
 *  @author 黎国基, 16-08-01 11:08
 *
 *  创建一个自定义的NSError
 *
 *  @param domain error域
 *  @param code   错误代码
 *  @param desc   error code本地描述(NSLocalizedDescriptionKey)
 *
 *  @return NSError
 */
+ (NSError*) createError:(NSString*)domain code:(NSInteger)code desc:(NSString*)desc{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    if(desc == nil){
        desc = @"";
    }
    [dic setObject:desc forKey:NSLocalizedDescriptionKey];
    NSError* error = [[NSError alloc]initWithDomain:domain code:code userInfo:dic];
    return error;
}

@end
