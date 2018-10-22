//
//  SKMainViewCell.h
//  ShopKeeper
//
//  Created by zzheron on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface SKMainViewCell : UITableViewCell
@property (nonatomic) NSDictionary *data_1;
@property (nonatomic) NSDictionary *data_2;

@property(nonatomic) UIView *bv_1;
@property(nonatomic) UIView *bv_2;


@property(nonatomic) UserInfo *user;


@end
