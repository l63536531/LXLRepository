//
//  MyServiceOrdersCtr.h
//  ShopKeeper
//
//  Created by zhough on 16/6/14.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"
#import "MyServiceOrdersCell.h"

@interface MyServiceOrdersCtr : MABaseViewController<UITableViewDelegate,UITableViewDataSource,MyServiceOrdersdelegate>{
    UIView * bgview;

    NSInteger pageindex;
    NSInteger getindex;
}
@property (nonatomic,strong) UITableView* maintableview;
@property (nonatomic,strong) NSMutableArray* allorderArray;//

@end
