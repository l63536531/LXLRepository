//
//  MoneyFlowingCell.h
//  ShopKeeper
//
//  Created by zhough on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoneyFlowingModel.h"

@interface MoneyFlowingCell : UITableViewCell


@property (nonatomic ,strong)NSArray* titlearray;
@property (nonatomic)MoneyFlowingModel * flowingmondel;

-(void)update:(MoneyFlowingModel*)titlearray;
@end
