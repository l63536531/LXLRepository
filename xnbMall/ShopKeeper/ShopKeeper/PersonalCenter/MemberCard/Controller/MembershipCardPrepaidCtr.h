//
//  MembershipCardPrepaidCtr.h
//  ShopKeeper
//
//  Created by zhough on 16/6/3.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MembershipCardPrepaidCtr : MABaseViewController<UITableViewDelegate,UITableViewDataSource,
UITextFieldDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIAlertViewDelegate>

@property (nonatomic) UITableView *tableView;

@property (nonatomic) BOOL lastResult;
@property (nonatomic,strong)NSString* aid;


@end
