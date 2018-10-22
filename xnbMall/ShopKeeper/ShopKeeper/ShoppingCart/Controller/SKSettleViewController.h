//
//  SKSettleViewController.h
//  ShopKeeper
//
//  Created by zzheron on 16/8/18.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"
#import "SKUserAddressViewController.h"
#import "ChangeAddressViewCtr.h"

@interface SKSettleViewController : MABaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SkChangeAddressDelegate,SkGetDefultAddressDelegate>

@property (nonatomic) UITableView *tableView;

@property (nonatomic) NSDictionary *data;
@property (nonatomic) NSDictionary *goods;
@property (nonatomic) NSString *areaId;
@property (nonatomic) NSString *usedGiftCard;

@end
