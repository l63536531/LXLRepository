//
//  UIViewController+Extension.h
//  ShopKeeper
//
//  Created by XNB2 on 16/11/1.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)

/**
 *  @author chenxinju
 *
 *  跳转的URL
 *
 *  @param URL 
 */
- (void)pushWebViewWithURL:(NSString *)URL andTitle:(NSString *)title ishidesBottomBar:(BOOL )isBarHide;
@end
