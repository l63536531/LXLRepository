//
//  SKGoodsCommentViewController.h
//  ShopKeeper
//
//  Created by zzheron on 16/9/27.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface SKGoodsCommentViewController : MABaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) UITableView *tableView;

@property (nonatomic)  NSString *goodsId;
@end
