//
//  OrderTrackingModel.m
//  ShopKeeper
//
//  Created by zhough on 16/6/23.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "OrderTrackingModel.h"

@implementation OrderTrackingModel
+(OrderTrackingModel*)create:(NSDictionary*)dic{


    OrderTrackingModel * model  = [[OrderTrackingModel alloc] init];
    model.log = dic[@"log"];
    model.logDate = dic[@"logDate"];
    model.orderId = dic[@"orderId"];
    model.status = dic[@"status"];

    model.expNum = dic[@"expNum"];
    model.expCode = dic[@"expCode"];
    model.userId = dic[@"userId"];
        model.logId = dic[@"logId"];

    return model;

}

//"expCode":"",
//"expNum":"0000000",
//"log":"订单已发货，物流公司：，物流单据号：0000000",
//"logDate":"2015-06-27T17:40:27",
//"orderId":"0a4c2b2e-32e8-4ce6-b84c-c974d8d71519",
//"status":"用户已签收",
//"userId":"9f4bdb0a-f150-4223-8699-6cce8d81cfe6


@end
