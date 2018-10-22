//
//  MyServiceOrdersCell.h
//  ShopKeeper
//
//  Created by zhough on 16/6/14.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyOrderModel.h"

@protocol MyServiceOrdersdelegate;


@interface MyServiceOrdersCell : UITableViewCell
@property (nonatomic ,strong)NSArray* titlearray;
@property (nonatomic,weak) id<MyServiceOrdersdelegate> delegate;
@property (nonatomic)MyOrderModel * getmodel;
@property (nonatomic) NSInteger getindex;
@property (nonatomic)NSInteger getindexrow;



-(void)update:(MyOrderModel*)model;
@end

@protocol MyServiceOrdersdelegate <NSObject>

-(void)clickButton:(NSInteger)tag row:(NSInteger)indexrow;


@end