//
//  OrderDetailCell1.h
//  ShopKeeper
//
//  Created by zhough on 16/6/13.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OrderDetailCell1delegate;

@interface OrderDetailCell1 : UITableViewCell
@property (nonatomic ,strong)NSArray* titlearray;
@property (nonatomic,weak) id<OrderDetailCell1delegate> delegate;

-(void)update:(NSArray*)titlearray;

@end
@protocol OrderDetailCell1delegate <NSObject>

-(void)clickDingDengButton;


@end