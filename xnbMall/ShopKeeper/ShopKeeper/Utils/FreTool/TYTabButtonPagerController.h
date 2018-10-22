//
//  SaleActivityController.m
//  ShopKeeper
//
//  Created by frechai on 16/10/19.
//  Copyright © 2016年 51xnb. All rights reserved.
//
#import "TYTabPagerController.h"
#import "TYTabTitleCellProtocol.h"

// register cell conforms to TYTabTitleViewCellProtocol

@interface TYTabButtonPagerController : TYTabPagerController<TYTabPagerControllerDelegate,TYPagerControllerDataSource>

// pagerBar color
@property (nonatomic, strong) UIColor *pagerBarColor;
@property (nonatomic, strong) UIColor *collectionViewBarColor;

// progress view
@property (nonatomic, assign) CGFloat progressRadius;
@property (nonatomic, strong) UIColor *progressColor;

// text color
@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIColor *selectedTextColor;

@end
