//
//  SKYiextremelyPayController.h
//  ShopKeeper
//
//  Created by XNB2 on 16/10/28.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "BaseController.h"

/**
 *  @author chenxinju, 16-10-28 11:10:02
 *
 *  易极付pay
 */
@interface SKYiextremelyPayController : BaseController 


@property(nonatomic,copy) NSString *orderId; //订单id
@property(nonatomic,copy)NSString *userid; ///用户id

@property(nonatomic,copy) NSString *payCode;
@property(nonatomic,copy) NSString *productName;

@property(nonatomic,copy) NSString *productDescription;
@end
