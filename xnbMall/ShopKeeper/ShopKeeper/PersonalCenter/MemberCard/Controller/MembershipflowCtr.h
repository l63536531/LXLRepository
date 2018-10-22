//
//  MembershipflowCtr.h
//  ShopKeeper
//
//  Created by zhough on 16/7/27.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface MembershipflowCtr : MABaseViewController<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView * mianTableView;
    
    UIView * bgview;
    
    
    NSMutableArray* moneyflowingArray;
    
    
    
}
@property(nonatomic, copy) NSString* getid;
@property(nonatomic) NSInteger pageindex;


@end
