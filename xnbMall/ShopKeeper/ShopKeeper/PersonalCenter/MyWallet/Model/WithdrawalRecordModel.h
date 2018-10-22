//
//  WithdrawalRecordModel.h
//  ShopKeeper
//
//  Created by zhough on 16/6/17.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WithdrawalRecordModel : NSObject

//"id": "ID",
//"accountId": "资金账户ID",
//"submittername": "提现人",
//"submittingDate": "提现时间",
//"amount": "提现金额",
//"processResult": "处理结果",
//"bankAccount": "银行卡号",
//"bank": "开户行",
//"notes": "备注"
@property(nonatomic , copy) NSString * idD;
@property(nonatomic , copy) NSString * accountId;
@property(nonatomic , copy) NSString * submittername;
@property(nonatomic , copy) NSString * submittingDate;
@property(nonatomic , copy) NSString * amount;
@property(nonatomic , copy) NSString * processResult;
@property(nonatomic , copy) NSString * bankAccount;
@property(nonatomic , copy) NSString * bank;
@property(nonatomic , copy) NSString * notes;



+(WithdrawalRecordModel*)create:(NSDictionary*)dic;

@end
