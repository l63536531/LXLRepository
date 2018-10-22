//
//  MyWalletCellOne.h
//  ShopKeeper
//
//  Created by zhough on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyWalletCellOne : UITableViewCell

@property (nonatomic ,strong)NSArray* titlearray;
@property (nonatomic) NSInteger getrow;
-(void)update:(NSArray*)titlearray;

@end
