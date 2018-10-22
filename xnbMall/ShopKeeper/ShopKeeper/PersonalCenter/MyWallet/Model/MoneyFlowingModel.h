//
//  MoneyFlowingModel.h
//  ShopKeeper
//
//  Created by zhough on 16/6/17.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyFlowingModel : NSObject




@property(nonatomic , copy) NSString * idD;
@property(nonatomic , copy) NSString * accountId;
@property(nonatomic , copy) NSString * amount;
@property(nonatomic , copy) NSString * notes;
@property(nonatomic , copy) NSString * accountBalance;
@property(nonatomic , copy) NSString * createdDate;
@property(nonatomic , copy) NSString * flowType;



+(MoneyFlowingModel*)create:(NSDictionary*)dic;

@end
