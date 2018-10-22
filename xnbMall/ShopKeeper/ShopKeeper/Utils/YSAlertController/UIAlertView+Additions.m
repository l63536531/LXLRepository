//
//  UIAlertView+HKAdditions.m
//  OZGTrade
//
//  Created by farben on 15/7/21.
//  Copyright (c) 2015年 FarBen. All rights reserved.
//

#import "UIAlertView+Additions.h"

@implementation UIAlertView (Additions)

+ (void)showWithMessage:(NSString *)msg {
    [UIAlertView showWithTitle:msg message:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil tag:0];
}

+ (void)showWithMessage:(NSString*)msg cancelButtonTitle:(NSString*)buttonTitle {
    [UIAlertView showWithTitle:msg message:nil cancelButtonTitle:buttonTitle otherButtonTitles:nil tag:0];
}

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)msg
    cancelButtonTitle:(NSString *)buttonTitle
    otherButtonTitles:(NSString *)otherTitle
                  tag:(NSInteger )iTag{
    
    UIAlertView *_alertView = [[UIAlertView alloc] initWithTitle:title
                                                         message:msg
                                                        delegate:nil
                                               cancelButtonTitle:buttonTitle
                                               otherButtonTitles: nil];
    _alertView.tag = iTag;
    [_alertView show];
}








@end
