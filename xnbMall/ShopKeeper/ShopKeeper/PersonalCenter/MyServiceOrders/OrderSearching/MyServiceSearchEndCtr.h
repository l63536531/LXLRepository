//
//  MyServiceSearchEndCtr.h
//  ShopKeeper
//
//  Created by zhough on 16/7/26.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

#import "MyServiceOrdersCell.h"

@interface MyServiceSearchEndCtr : MABaseViewController<UITableViewDelegate,UITableViewDataSource,MyServiceOrdersdelegate>{
    UIView * bgview;
    
    NSInteger pageindex;
    NSInteger getindex;
}

@property (nonatomic,strong) UITableView* maintableview;
@property (nonatomic,strong) NSMutableArray* allorderArray;//
@property (nonatomic,strong)NSString * getkeyString;
@property (nonatomic)NSInteger getindid;

@end