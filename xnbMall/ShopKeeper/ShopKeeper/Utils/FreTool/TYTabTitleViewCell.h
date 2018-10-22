//
//  SaleActivityController.m
//  ShopKeeper
//
//  Created by frechai on 16/10/19.
//  Copyright © 2016年 51xnb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYTabTitleCellProtocol.h"

@interface TYTabTitleViewCell : UICollectionViewCell<TYTabTitleCellProtocol>
@property (nonatomic, weak,readonly) UILabel *titleLabel;
@end
