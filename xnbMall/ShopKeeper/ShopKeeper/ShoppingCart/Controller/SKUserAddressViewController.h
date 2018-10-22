//
//  SKUserAddressViewController.h
//  ShopKeeper
//
//  Created by zzheron on 16/8/23.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"


@protocol SkChangeAddressDelegate <NSObject>
- (void)changeAddress:(NSDictionary *)value;
@end

@interface SKUserAddressViewController : MABaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) UITableView *tableView;

@property (nonatomic,weak) id<SkChangeAddressDelegate> delegate;

@end
