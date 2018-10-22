//
//  PreferentialRecordCtr.h
//  ShopKeeper
//
//  Created by zhough on 16/6/2.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface PreferentialRecordCtr : MABaseViewController<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView * mianTableView;
    
    UIView * bgview;
    NSMutableArray * getlistarray;
    NSArray * getlist;
    
    
}


@end
