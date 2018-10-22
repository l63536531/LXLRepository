//
//  ProblemFeedbackCtr.h
//  ShopKeeper
//
//  Created by zhough on 16/6/3.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ProblemFeedbackCtr : MABaseViewController<UITableViewDelegate,UITableViewDataSource,
                                                    UITextViewDelegate,
                                                    UINavigationControllerDelegate,
                                                    UIImagePickerControllerDelegate,
                                                    UIAlertViewDelegate>

@property (nonatomic) UITableView *tableView;

@property (nonatomic) BOOL lastResult;



@end
