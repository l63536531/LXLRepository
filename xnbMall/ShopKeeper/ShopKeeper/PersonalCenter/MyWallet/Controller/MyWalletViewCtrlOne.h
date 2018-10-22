//
//  MyWalletViewCtrlOne.h
//  ShopKeeper
//
//  Created by zhough on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface MyWalletViewCtrlOne : MABaseViewController<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView * mianTableView;
    
    
    
}

@property(nonatomic ,strong) NSString * getid;
@property (nonatomic,strong) NSDictionary * getDic;




@end
