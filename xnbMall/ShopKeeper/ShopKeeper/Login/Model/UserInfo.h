//
//  UserInfo.h
//  ShopKeeper
//
//  Created by zzheron on 16/7/26.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserUiyp.h"

@interface UserInfo : NSObject
@property (copy,nonatomic) NSString *userid;
@property (copy,nonatomic) NSString *token;
@property (copy,nonatomic) NSString *currentMembershopId;
@property (copy,nonatomic) NSDictionary *memberShipsMap;
@property (strong, nonatomic) UserUiyp *uiyp;

-(NSInteger) GetPermissionType;//权限类别
-(NSInteger) GetIndexType;//权限首页类型
-(NSInteger) GetPriceType:(NSDictionary*)goodsprice;//价格显示类型

@end
