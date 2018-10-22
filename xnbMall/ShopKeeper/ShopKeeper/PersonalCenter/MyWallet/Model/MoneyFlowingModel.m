//
//  MoneyFlowingModel.m
//  ShopKeeper
//
//  Created by zhough on 16/6/17.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MoneyFlowingModel.h"

@implementation MoneyFlowingModel
+(MoneyFlowingModel*)create:(NSDictionary*)dic{
    
    MoneyFlowingModel * model = [[MoneyFlowingModel alloc] init];
    model.idD = dic[@"idD"];
    model.accountId = dic[@"accountId"];
    model.amount = dic[@"amount"];
    model.notes = dic[@"notes"];
    model.accountBalance = dic[@"accountBalance"];
    model.createdDate = dic[@"createdDate"];
    model.flowType = dic[@"flowType"];

    return model;
}

@end
