//
//  RefundApplicationRecordCtr.h
//  ShopKeeper
//
//  Created by zhough on 16/6/21.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface RefundApplicationRecordCtr : MABaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIAlertViewDelegate>{
    
    UITableView * mianTableView;
    UITextField*  messagetextview;
    UITextView * noteTextview;
    UITextField * moneyTextField;

    UILabel * labwhy;

    
}


@end
