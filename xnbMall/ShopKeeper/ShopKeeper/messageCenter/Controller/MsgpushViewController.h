//
//  MsgpushViewController.h
//  ShopKeeper
//
//  Created by zhough on 16/8/8.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface MsgpushViewController : MABaseViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    
    
    UITableView * mianTableView;
    
    UITextField *cashcoupontext;
    
    CGFloat getheight;
    
    
    
    
}

@property (nonatomic,strong) NSDictionary * dicdata;
@property (nonatomic,strong) NSString * getmessgeid;


@end
