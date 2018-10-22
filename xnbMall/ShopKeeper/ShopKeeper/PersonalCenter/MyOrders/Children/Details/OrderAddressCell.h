//
//  OrderAddressCell.h
//  ShopKeeper
//
//  Created by zhough on 16/6/13.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderAddressCell : UITableViewCell
@property (nonatomic ,strong)NSArray* titlearray;
-(void)update:(NSArray*)titlearray;
@end
