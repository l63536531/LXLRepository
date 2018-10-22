//
//  MsgCenterViewController.h
//  ShopKeeper
//
//  Created by zzheron on 16/5/26.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface MsgCenterViewController : MABaseViewController<UITableViewDelegate,UITableViewDataSource>{

}

@property (nonatomic) UITableView *tableView;

@end
