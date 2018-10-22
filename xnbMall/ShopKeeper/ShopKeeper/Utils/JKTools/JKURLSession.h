//
//  JKURLSession.h
//  InnWaiter
//
//  Created by xnb on 16/7/27.
//  Copyright © 2016年 51xnb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKURLSession : NSObject

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

+(void)taskWithMethod:(NSString *)method parameter:(NSDictionary *)parameterDic token:(BOOL)token resultBlock:(void(^)(NSDictionary *resultDic,NSError *error))resultBlock;

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

+(void)getHtmlWithMethod:(NSString *)method parameter:(NSDictionary *)parameterDic token:(BOOL)token resultBlock:(void(^)(NSString *htmlStr,NSError *error))resultBlock;

+ (void)uploadFile:(NSData *)data fileName:(NSString *)fileName resultBlock:(void(^)(NSString *fileId,NSError *error))resultBlock ;

@end
