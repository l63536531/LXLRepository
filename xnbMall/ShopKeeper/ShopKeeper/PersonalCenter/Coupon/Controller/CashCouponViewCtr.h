//
//  CashCouponViewCtr.h
//  ShopKeeper
//
//  Created by zhough on 16/6/1.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface CashCouponViewCtr : MABaseViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    
    
    UITableView * mianTableView;
    
    UITextField *cashcoupontext;
   
    
    
    
}


@end
