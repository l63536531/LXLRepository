//
//  RefundApplicationCtr.h
//  ShopKeeper
//
//  Created by zhough on 16/6/15.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface RefundApplicationCtr : MABaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIAlertViewDelegate>{
    
    UITableView * mianTableView;
    UITextField * moneyTextField;
    
    UITextView * noteTextview;
    

    
}


@end
