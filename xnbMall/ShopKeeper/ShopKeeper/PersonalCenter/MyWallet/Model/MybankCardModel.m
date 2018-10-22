//
//  MybankCardModel.m
//  ShopKeeper
//
//  Created by zhough on 16/6/18.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MybankCardModel.h"

@implementation MybankCardModel

+(MybankCardModel*)create:(NSDictionary*)dic{

    
    MybankCardModel* model = [[MybankCardModel alloc] init];

    model.idD = dic[@"id"];
    model.accountId = dic[@"accountId"];
    model.bankNo = dic[@"bankNo"];
    model.bankName = dic[@"bankName"];
    model.defaultAccount = dic[@"defaultAccount"];

    return model;
    
    
}




@end
