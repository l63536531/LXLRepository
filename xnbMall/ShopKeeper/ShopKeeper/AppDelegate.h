//
//  AppDelegate.h
//  ShopKeeper
//
//  Created by zzheron on 16/5/26.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "GeTuiSdk.h"

//MasterSecret：rzHAVBSKf57f29EkjpNud3
@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate,GeTuiSdkDelegate>

@property (strong, nonatomic) UIWindow *window;

//-(void)msseagestart;

@end

