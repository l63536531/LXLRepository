//
//  CacheUtils.h
//  ShopKeeper
//
//  Created by zzheron on 16/6/29.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import "NSString+SHA.h"
#import "YYCache.h"

@interface CacheUtils : NSObject

+(id)getCacheData:(NSString*)url withPost:(id)post;
+(BOOL)setCacheData:(NSString*)url withPost:(id)post withData:(id)data;

@end
