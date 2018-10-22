//
//  MybankCardModel.h
//  ShopKeeper
//
//  Created by zhough on 16/6/18.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MybankCardModel : NSObject
//
//"id":"银行卡ID",
//"accountId":"资金账户Id",
//"bankNo":"银行卡号",
//"bankName":"开户行",
//"defaultAccount":"是否是默认银行卡"


@property(nonatomic , copy) NSString * idD;
@property(nonatomic , copy) NSString * accountId;
@property(nonatomic , copy) NSString * bankNo;
@property(nonatomic , copy) NSString * bankName;
@property(nonatomic , copy) NSString * defaultAccount;




+(MybankCardModel*)create:(NSDictionary*)dic;


@end
