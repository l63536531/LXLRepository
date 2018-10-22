//
//  MemberCardViewCtr.h
//  ShopKeeper
//
//  Created by zhough on 16/6/2.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface MemberCardViewCtr : MABaseViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    
    UITableView * mianTableView;
    
    UITextField *cashcoupontext;
    
    
    
    
}

@property(nonatomic,copy) NSString * shopName;
@property(nonatomic,copy) NSString * balance;

@property(nonatomic,strong) NSString * aid;


@end
