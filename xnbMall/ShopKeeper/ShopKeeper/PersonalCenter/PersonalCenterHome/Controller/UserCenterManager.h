//
//  UserCenterManager.h
//  ShopKeeper
//
//  Created by zhough on 16/7/28.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCenterManager : NSObject

#pragma mark 查询当前用户的礼券余额
+(NSString*)queryGiftcardBalance;

@end
