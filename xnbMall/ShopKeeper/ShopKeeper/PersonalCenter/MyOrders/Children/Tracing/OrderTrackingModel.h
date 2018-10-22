//
//  OrderTrackingModel.h
//  ShopKeeper
//
//  Created by zhough on 16/6/23.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderTrackingModel : NSObject

@property (nonatomic ,copy) NSString* log;
@property (nonatomic ,copy) NSString* logDate;
@property (nonatomic ,copy) NSString* orderId;
@property (nonatomic ,copy) NSString* status;
@property (nonatomic ,copy) NSString* userId;
@property (nonatomic ,copy) NSString* expNum;
@property (nonatomic ,copy) NSString* expCode;
@property (nonatomic ,copy) NSString* logId;


+(OrderTrackingModel*)create:(NSDictionary*)dic;

//"expCode":"",
//"expNum":"0000000",
//"log":"订单已发货，物流公司：，物流单据号：0000000",
//"logDate":"2015-06-27T17:40:27",
//"orderId":"0a4c2b2e-32e8-4ce6-b84c-c974d8d71519",
//"status":"用户已签收",
//"userId":"9f4bdb0a-f150-4223-8699-6cce8d81cfe6

//"logId":"日志id"
@end
