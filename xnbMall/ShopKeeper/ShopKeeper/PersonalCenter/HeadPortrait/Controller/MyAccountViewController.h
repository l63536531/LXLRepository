//
//  MyAccountViewController.h
//  Roam
//
//  Created by zhough on 16/1/12.
//  Copyright © 2016年 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BaseController.h"

@interface MyAccountViewController : BaseController<UITextFieldDelegate,MBProgressHUDDelegate,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>{
    
    UITableView* myTableView;
    UIView* headerview ;//头像背景
    UILabel* label;//头像上名称
    UILabel *title;
    UILabel *titlephone;
    UIButton *Btn;
    
    
    
    MBProgressHUD* HUD;
    
    
}
@property (nonatomic , strong) NSString * nickname;//昵称

@property (nonatomic , strong) NSString * gender;//性别
@property (nonatomic , strong) NSString * region;// 地区


@end
