//
//  SKSearchViewController.h
//  ShopKeeper
//
//  Created by zzheron on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface SKSearchViewController : MABaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) UITableView *tableView;

@end
