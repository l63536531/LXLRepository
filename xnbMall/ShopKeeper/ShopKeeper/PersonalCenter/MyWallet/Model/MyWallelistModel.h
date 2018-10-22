//
//  MyWallelistModel.h
//  ShopKeeper
//
//  Created by zhough on 16/6/15.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyWallelistModel : NSObject
@property(nonatomic , copy) NSString * walletType;
@property(nonatomic , copy) NSString * balance;
@property(nonatomic , copy) NSString * code;
@property(nonatomic , copy) NSString * createdBy;
@property(nonatomic , copy) NSString * createdDate;
@property(nonatomic , copy) NSString * idD;
@property(nonatomic , copy) NSString * ownerId;
@property(nonatomic , copy) NSString * status;
@property(nonatomic , copy) NSString * withdrawBalance;



+(MyWallelistModel*)create:(NSDictionary*)dic;


@end
