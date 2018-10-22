//
//  MyServiceOrderDetailCtr.h
//  ShopKeeper
//
//  Created by zhough on 16/7/6.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyServiceOrderDetailCtr :  UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>{
    
    UITextField*  textfield;
    NSMutableArray * getdetailArray;
    NSInteger isTheFirstgetdata;
    
    
}
@property (nonatomic,strong) UITableView* maintableview;
@property (nonatomic , strong) UILabel * shouldpaylab;
@property (nonatomic,strong)NSString * getorderId;


@end
