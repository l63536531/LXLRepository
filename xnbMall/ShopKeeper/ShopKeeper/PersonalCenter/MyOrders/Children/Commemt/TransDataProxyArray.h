//
//  TransDataProxyArray.h
//  ShopKeeper
//
//  Created by zhough on 16/7/26.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <Foundation/Foundation.h>



#import <Foundation/Foundation.h>
#define ERROR_DOMAIN_REQUEST @"ERROR_DOMAIN_REQUEST"
#define ERROR_DOMAIN_HTTP @"ERROR_DOMAIN_HTTP"
#define ERROR_DOMAIN_BUSINESS @"ERROR_DOMAIN_BUSINESS"
#define ERROR_DOMAIN_JSON @"ERROR_DOMAIN_JSON"

@interface TransDataProxyArray : NSObject
+(TransDataProxyArray*) shareController;
- (void) comment:(NSArray*)array block:(void (^)(NSDictionary *dic, NSError *error))block;
@end