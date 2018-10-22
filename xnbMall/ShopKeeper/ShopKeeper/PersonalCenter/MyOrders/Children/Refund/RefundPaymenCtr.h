//
//  RefundPaymenCtr.h
//  ShopKeeper
//
//  Created by zhough on 16/6/21.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"
//未支付
@interface RefundPaymenCtr : MABaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIAlertViewDelegate,UITextViewDelegate>{
    
    UITableView * mianTableView;
    UITextField * moneyTextField;
    
    UITextView * noteTextview;
    
    
    
    
}


@end
