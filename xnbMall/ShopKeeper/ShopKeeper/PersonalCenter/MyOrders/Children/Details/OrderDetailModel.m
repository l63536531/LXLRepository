//
//  OrderDetailModel.m
//  ShopKeeper
//
//  Created by zhough on 16/6/23.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel


+(OrderDetailModel*)create:(NSDictionary*)dic{

    OrderDetailModel * model = [[OrderDetailModel alloc] init];

    

    model.address  = dic[@"address"];
    model.comments  = dic[@"comments"];
    model.orderCode  = dic[@"orderCode"];
    model.orderId  = dic[@"orderId"];
    
    NSNumber * getstatu = dic[@"orderStatus"];
    model.orderStatus  = [getstatu intValue];
    model.phone  = dic[@"phone"];
    model.userName  = dic[@"userName"];

    
    NSNumber * getamount = dic[@"amount"];
    model.amount =[getamount floatValue];
    
    NSNumber* getcardcoupon = dic[@"cardCashCoupon"];
    model.cardCashCoupon = [getcardcoupon floatValue];
    
    NSNumber* getgiftCardAmount = dic[@"giftCardAmount"];
    model.giftCardAmount = [getgiftCardAmount floatValue];

    NSNumber* getpaidAmount = dic[@"paidAmount"];
    model.paidAmount = [getpaidAmount floatValue];
    
    
    NSNumber* getbonus = dic[@"bonus"];
    model.bonus = [getbonus integerValue];

    model.orderGoodsList = dic[@"orderGoodsList"];
    model.paymentMethod = dic[@"paymentMethod"];
    model.userId = dic[@"userId"];

    NSNumber * getactivityType = dic[@"activityType"];
    model.activityType =[getactivityType intValue];

    NSNumber * getisComment = dic[@"isComment"];
    model.isComment =[getisComment intValue];

    
    model.orderStatusDesc =dic[@"orderStatusDesc"];
    model.orderPayMethodDes =dic[@"orderPayMethodDes"];
    
    return model;
}






@end
