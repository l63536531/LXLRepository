//
//  MybankCardViewCtrl.h
//  ShopKeeper
//
//  Created by zhough on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface MybankCardViewCtrl : MABaseViewController<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView * mianTableView;
    NSMutableArray* getcardlist;
    NSString * paypassword;
    
    
}
@property(nonatomic, strong) NSString* getid;

@end
