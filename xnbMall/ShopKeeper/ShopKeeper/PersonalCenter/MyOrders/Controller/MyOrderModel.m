//
//  MyOrderModel.m
//  ShopKeeper
//
//  Created by zhough on 16/6/23.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MyOrderModel.h"

@implementation MyOrderModel
+(MyOrderModel*)create:(NSDictionary*)dic;
{

    MyOrderModel *  model = [[MyOrderModel alloc] init];
    


  
    
    
    model.orderId = dic[@"orderId"];
    model.userId = dic[@"userId"];
    
    NSNumber * paidAmountN = dic[@"paidAmount"];
    model.paidAmount = [paidAmountN floatValue];
    model.code = dic[@"code"];
    
    NSNumber * stateN =dic[@"state"];
    model.state =[stateN integerValue];
    
    NSNumber * bonus1 =dic[@"bonus"];
    model.bonus =[bonus1 integerValue];
    
    NSNumber * isdelay1 =dic[@"isdelay"];
    model.isdelay =[isdelay1 integerValue];

    
    NSNumber * activityType1 =dic[@"activityType"];
    model.activityType =[activityType1 integerValue];

    
    model.orderStateDes = dic[@"orderStateDes"];
    model.orderPayMethodDes = dic[@"orderPayMethodDes"];
    model.settleDate = dic[@"settleDate"];
    model.lastUpdatedDate = dic[@"lastUpdatedDate"];
    
    NSNumber * allGoodsComment =dic[@"allGoodsComment"];
    model.allGoodsComment =[allGoodsComment integerValue];
    model.goodsList = dic[@"goodsList"];

    

    
    
    
   
    return model;

}

@end
