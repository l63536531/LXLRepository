//
//  UserUiyp.h
//  ShopKeeper
//
//  Created by zzheron on 16/7/26.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserUiyp : NSObject
@property (strong,nonatomic) NSMutableArray *areaIds;
@property (strong,nonatomic) NSMutableArray *areaNames;

@property (assign,nonatomic) NSInteger managerPermission;
@property (assign,nonatomic) NSInteger operationPermission;
@property (copy,nonatomic)   NSString *preferredAreaId;
@property (copy,nonatomic)   NSString *serviceCenterId;
@property (assign,nonatomic) NSInteger serviceCenterPermission;
@property (assign,nonatomic) NSInteger serviceStationPermission;
@property (assign,nonatomic) NSInteger shopMemberPermission;
@property (copy,nonatomic)   NSString *stationOrCenterId;
@property (assign,nonatomic) NSInteger ystPermission;

@end
