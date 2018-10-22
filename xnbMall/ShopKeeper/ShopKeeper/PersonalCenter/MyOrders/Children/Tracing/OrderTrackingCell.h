//
//  OrderTrackingCell.h
//  ShopKeeper
//
//  Created by zhough on 16/6/14.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>





@protocol OrderTrackingdelegate;


@interface OrderTrackingCell : UITableViewCell
@property (nonatomic ,strong)NSArray* titlearray;
@property (nonatomic,weak) id<OrderTrackingdelegate> delegate;
@property (nonatomic) NSInteger getsetion;
@property (nonatomic) bool isbtnshow;//yes；



-(void)update:(NSArray*)titlearray;
@end


@protocol OrderTrackingdelegate <NSObject>

-(void)clickButton:(NSInteger)tag;


@end