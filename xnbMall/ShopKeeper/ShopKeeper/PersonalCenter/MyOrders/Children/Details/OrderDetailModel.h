//
//  OrderDetailModel.h
//  ShopKeeper
//
//  Created by zhough on 16/6/23.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject



//{
//    "address":"西藏自治区_拉萨市_城关区_冲赛康街道_货款充值",
//    "amount":100.00,
//    "canSwitch":false,
//    "cardCashCoupon":0.00,
//    "comments":"",
//    "giftCardAmount":0.00,
//    "orderCode":"54631139543",
//    "orderGoodsList":[
//    {
//        "number":1,
//        "price":100.00,
//        "title":"货款"
//url
//    }
//                      ],
//    "orderId":"33034e4d-58d6-4afc-8c26-daafe0dd7bd7",
//    "orderStatus":5,
//    "orderStatusDesc":"买家已签收，服务费已转入相关资金账户",
//    "paidAmount":100.00,
//    "paymentMethod":"银联支付",
//    "phone":"13929556070",
//    "userId":"aa3eab7e-ec59-4fbc-be62-969bfbe65395",
//    "userName":"盒子"
//},



@property (nonatomic ,copy) NSString* address;
@property (nonatomic ) CGFloat amount;//现金
@property (nonatomic ) CGFloat cardCashCoupon;//现金券抵扣
@property (nonatomic ,copy) NSString*  comments;
@property (nonatomic ) CGFloat  giftCardAmount;//礼券
@property (nonatomic ,copy) NSString*  orderCode;
@property (nonatomic ) NSArray*  orderGoodsList;
@property (nonatomic ,copy) NSString*  orderId;
@property (nonatomic ) int orderStatus;

@property (nonatomic ) CGFloat paidAmount;

@property (nonatomic) NSInteger bonus;           //"积分",

@property (nonatomic ,copy) NSString*  paymentMethod;
@property (nonatomic ,copy) NSString*  phone;
@property (nonatomic ,copy) NSString*  userId;
@property (nonatomic ,copy) NSString*  userName;
@property (nonatomic ) int  activityType;//5，订金支付；6，积分支付
@property (nonatomic,copy) NSString * orderStatusDesc;
@property (nonatomic,copy) NSString * orderPayMethodDes;

@property (nonatomic) NSInteger isComment;           //，true表示已评论，false没评论"



+(OrderDetailModel*)create:(NSDictionary*)dic;
@end
