//
//  MyWalletCell.h
//  ShopKeeper
//
//  Created by zhough on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWallelistModel.h"

@interface MyWalletCell : UITableViewCell


@property (nonatomic ,strong)NSArray* titlearray;
@property (nonatomic) MyWallelistModel* model;

-(void)update:(MyWallelistModel*)model;




@end
