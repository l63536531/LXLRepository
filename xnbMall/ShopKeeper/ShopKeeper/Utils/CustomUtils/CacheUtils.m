//
//  CacheUtils.m
//  ShopKeeper
//
//  Created by zzheron on 16/6/29.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "CacheUtils.h"

#define CACHE_PATH @"51xnb_cache_path"

@implementation CacheUtils

+(id)getCacheData:(NSString*)url withPost:(id)post{
    
    NSString *strSha = [NSString stringWithFormat:@"%@?json=%@",url,[Utils DataTOjsonString:post]];
    NSString *strKey = [strSha md5HexDigest];
    
    YYCache *yyc = [[YYCache alloc] initWithName:CACHE_PATH];
    
    return [yyc objectForKey:strKey];
}


+(BOOL)setCacheData:(NSString*)url withPost:(id)post withData:(id)data{
    NSString *strSha = [NSString stringWithFormat:@"%@?json=%@",url,[Utils DataTOjsonString:post]];
    NSString *strKey = [strSha md5HexDigest];
    
    YYCache *yyc = [[YYCache alloc] initWithName:CACHE_PATH];
    
    [yyc setObject:data forKey:strKey];
    
    return YES;
}
@end
