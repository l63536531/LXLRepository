//
//  HttpReq.h
//  TaskGanGan
//
//  Created by zzheron on 15/10/30.
//  Copyright © 2015年 zzheron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpReq : NSObject

//+(HttpReq *)sharedInstance;

-(id)get:(NSString*)surl;
-(id)post:(NSString*)surl withPost:(NSDictionary*)postdata;
+(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;

@end
