//
//  OrderListBtnCell.h
//  ShopKeeper
//
//  Created by zhough on 16/6/14.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol OrderListBtndelegate;

@interface OrderListBtnCell : UITableViewCell
@property (nonatomic,weak) id<OrderListBtndelegate> delegate;

@property (nonatomic ,strong)NSArray* titlearray;
@property (nonatomic) NSInteger getrow;
-(void)update:(NSArray*)titlearray;

@end





@protocol OrderListBtndelegate <NSObject>

-(void)clickrow:(NSInteger)indexrow;


@end