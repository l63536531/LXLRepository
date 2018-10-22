//
//  SaleActivityController.m
//  ShopKeeper
//
//  Created by frechai on 16/10/19.
//  Copyright © 2016年 51xnb. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TapBlock) ();
@interface BGTapView : UIView
@property (nonatomic,copy)TapBlock tapBlock;
@end
