//
//  HttpReq.m
//  TaskGanGan
//
//  Created by zzheron on 15/10/30.
//  Copyright © 2015年 zzheron. All rights reserved.
//

#import "HttpReq.h"
#import "AFHTTPSessionManager+Util.h"
#import "NSString+Utils.h"

@implementation HttpReq

/*static HttpReq* shareController = nil;
 

+(HttpReq*) sharedInstance{
    if(shareController == nil){
        shareController = [[HttpReq alloc]init];
    }
    return shareController;
}

-(id)init{
    self = [super init];
    if(!self){
        return self;
    }
    return self;
}
*/

-(id)get:(NSString *)surl {
    __block NSDictionary *data = nil ;
    //AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    
    [manager GET:surl parameters:nil
         success:^(NSURLSessionTask *operation, id responseObject) {
             //请求成功的回调
             NSError *error;
             data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
             
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             //请求失败的回调
             
         }];
    return data;
}


/**
 异步http请求
 */
-(id)postAsync:(NSString*)surl withPost:(NSDictionary*)postdata{
    __block NSDictionary *data  ;
    
    //void (^testBlock)(id) = ^(id redata){
    //    NSLog(@"%@",redata);
    //};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:surl parameters:postdata
          success:^(NSURLSessionTask *operation, id responseObject) {
              //testBlock(responseObject);
              //请求成功的回调
              //NSError *error;
              //NSLog(@"responseObject:%@",responseObject);
              //data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
              data = responseObject;
              
          } failure:^(NSURLSessionTask *operation, NSError *error) {
              //请求失败的回调
              
          }];
    return data;

}



/**
 同步http请求
 */
-(id)post:(NSString*)surl withPost:(NSDictionary*)postdata{
    return nil;
}


+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id))success
     failure:(void (^)(NSError *))failure
{
    // post请求
    // 1. 创建请求管理者:请求和解析
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    if(![NSString isBlankString:token])
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];

    
    // 2. 发送post请求
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}



@end
