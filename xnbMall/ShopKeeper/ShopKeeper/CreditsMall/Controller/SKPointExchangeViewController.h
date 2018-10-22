//
//  SKPointExchangeViewController.h
//  ShopKeeper
//
//  Created by zzheron on 16/9/8.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"
#import "SKUserAddressViewController.h"

@interface SKPointExchangeViewController : MABaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SkChangeAddressDelegate>

@property (nonatomic) UITableView *tableView;

@property (nonatomic,copy) NSDictionary *data;

@end
