//
//  UserCenterManager.m
//  ShopKeeper
//
//  Created by zhough on 16/7/28.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "UserCenterManager.h"
#import "TransDataProxyCenter.h"

@implementation UserCenterManager


+(NSString*)queryGiftcardBalance{
    
    
    [[TransDataProxyCenter shareController] queryGiftcardBalanceblock:^(NSDictionary *dic, NSError *error) {
        
    }];

    return nil;
}



@end
