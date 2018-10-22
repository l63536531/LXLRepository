//
//  MyWallelistModel.m
//  ShopKeeper
//
//  Created by zhough on 16/6/15.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MyWallelistModel.h"

@implementation MyWallelistModel

+(MyWallelistModel*)create:(NSDictionary*)dic{

    MyWallelistModel* model = [[MyWallelistModel alloc] init];
    model.walletType = dic[@"walletType"];
    model.balance = dic[@"account"][@"balance"];
    model.code = dic[@"account"][@"code"];
    model.createdBy = dic[@"account"][@"createdBy"];
    model.createdDate = dic[@"account"][@"createdDate"];
    model.idD = dic[@"account"][@"id"];
    model.ownerId = dic[@"account"][@"ownerId"];
    model.status = dic[@"account"][@"status"];
    model.withdrawBalance = dic[@"account"][@"withdrawBalance"];

    return model;
}

@end
