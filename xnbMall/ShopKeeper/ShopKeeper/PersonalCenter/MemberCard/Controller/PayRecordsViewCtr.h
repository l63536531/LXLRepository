//
//  PayRecordsViewCtr.h
//  ShopKeeper
//
//  Created by zhough on 16/6/2.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface PayRecordsViewCtr : MABaseViewController<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView * mianTableView;
    
    UIView * bgview;
    
    NSInteger pageIndex;
    
    NSMutableArray * getdataList;
    
}

@property(nonatomic,strong)NSString* aid;


@end
