//
//  MABaseViewController.h
//  InnWaiter
//
//  Created by xnb on 16/7/27.
//  Copyright © 2016年 51xnb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SKMACROs.h"
#import "JKTool.h"
#import "JKURLSession.h"
#import "JKViews.h"
//#import "MBProgressHUD.h"
//#import "SVProgressHUD.h"
//#import "MyUtile.h"
//#import "BlocksKit.h"
//#import "BlocksKit+UIKit.h"
//#import "UIView+Util.h"
//#import "NSString+Utils.h"
#import "AppDelegate.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "UMMobClick/MobClick.h"

@interface MABaseViewController : UIViewController

- (CGFloat)naviControllerContentHeight;

/**
 *  @author 黎国基, 16-08-18 17:08
 *
 *  一个页面如果同时进行多个网络请求，则每启动一个请求，requestCount+1，每结算一个请求，requestCount-1，每次结束请求时，判断requestCount，如果等于0，则结束关闭HUD
 */
@property (nonatomic, assign) NSInteger requestCount;

@property (nonatomic, strong) MBProgressHUD *baseMBHUD;

- (void)showAutoDissmissHud:(NSString *)text;

@end
