//
//  SKMixBuyGoodsViewController.h
//  ShopKeeper
//
//  Created by zzheron on 16/8/17.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface SKMixBuyGoodsViewController : MABaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) UITableView *tableView;

@property (nonatomic,assign) NSString *templateId;
@property (nonatomic,assign) NSString *goodsFactoryId;
@property (nonatomic,assign) NSString *lastDate;

@end
