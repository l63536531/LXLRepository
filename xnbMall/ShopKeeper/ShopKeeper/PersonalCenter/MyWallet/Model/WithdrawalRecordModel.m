//
//  WithdrawalRecordModel.m
//  ShopKeeper
//
//  Created by zhough on 16/6/17.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "WithdrawalRecordModel.h"

@implementation WithdrawalRecordModel


+(WithdrawalRecordModel*)create:(NSDictionary*)dic{

    WithdrawalRecordModel* model = [[WithdrawalRecordModel alloc] init];
    
    model.idD = dic[@"id"];
    model.accountId = dic[@"accountId"];
    model.submittername = dic[@"submittername"];
    model.submittingDate = dic[@"submittingDate"];
    NSNumber * getamount = dic[@"amount"];
    model.amount = [NSString stringWithFormat:@"%0.2f",[getamount floatValue]];
    NSNumber * resrlt =dic[@"processResult"];
    if (resrlt != nil) {
        model.processResult = [NSString stringWithFormat:@"%d",[resrlt intValue]];
    }
    else{
        model.processResult = nil;
    }
    model.bankAccount = dic[@"bankAccount"];
    model.bank = dic[@"bank"];
    model.notes = dic[@"notes"];
 


    return model;
}

@end
