//
//  UIAlertView+HKAdditions.h
//  OZGTrade
//
//  Created by farben on 15/7/21.
//  Copyright (c) 2015年 FarBen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Additions)

+ (void)showWithMessage:(NSString*)msg;
+ (void)showWithMessage:(NSString*)msg cancelButtonTitle:(NSString*)buttonTitle;

@end
