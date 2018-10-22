//
//  MsgDetailViewController.h
//  ShopKeeper
//
//  Created by zzheron on 16/6/22.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface MsgDetailViewController :  MABaseViewController

@property (nonatomic,strong) NSDictionary * dicdata;
@property (nonatomic,strong) NSString * getmessgeid;

/** Navtitle */
@property (nonatomic, copy)NSString *titleName;

@end
