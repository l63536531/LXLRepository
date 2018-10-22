//
//  LoginViewController.h
//  InnWaiter
//
//  Created by oracle on 16/5/10.
//  Copyright © 2016年 51xnb. All rights reserved.
//

#import "MABaseViewController.h"
#import "MBProgressHUD.h"




@interface LoginViewController : MABaseViewController{
    
}

/**
 *  @author 黎国基, 16-11-17 11:11
 *
 *  先执行dissmiss，dissmiss complete后，再掉block
 */
@property (nonatomic, copy) void (^loginResultBlock)(BOOL success);

/**
 *  @author 黎国基, 16-11-17 11:11
 *
 *  此block执行0.1s后，再执行dismiss（购物车特殊需要）
 */
@property (nonatomic, copy) void (^loginResultBlockBeforeDissmiss)(BOOL success);

@end
