//
//  OrderTrackingCtr.h
//  ShopKeeper
//
//  Created by zhough on 16/6/14.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface OrderTrackingCtr : MABaseViewController

@property (nonatomic,strong) NSString * getorderID;
@property (nonatomic,strong) NSString * getOrderNumber;
@property (nonatomic,strong) NSString * getOrderState;

@property (nonatomic,assign)BOOL jumpForFre;
@end
