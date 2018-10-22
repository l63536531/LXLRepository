//
//  ShippingAddressCell.h
//  ShopKeeper
//
//  Created by zhough on 16/6/1.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShipingAdderssModel.h"


@protocol ShippingAddressCellDelegate ;



@interface ShippingAddressCell : UITableViewCell
@property (nonatomic ,strong)NSArray* titlearray;
@property (nonatomic,assign)NSInteger isdefault;
@property (nonatomic)ShipingAdderssModel * shipingmodel;
@property (nonatomic,assign) NSInteger index;


-(void)update:(ShipingAdderssModel*)titlearray;

@property (nonatomic,weak) id<ShippingAddressCellDelegate> delegate;


@end



@protocol ShippingAddressCellDelegate <NSObject>

-(void)clickButton:(NSInteger)tag index:(NSInteger)index;



@end