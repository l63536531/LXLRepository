//
//  BaseH5ViewController.h
//  groupVIP
//
//  Created by oracle on 16/1/6.
//  Copyright © 2016年 kinal guo. All rights reserved.
//


@interface BaseH5ViewController : UIViewController<UIWebViewDelegate>{
    UIWebView* myWebView;
    CGFloat webViewHeight;
    
    UIView* progressView;     
}

@property (nonatomic) NSMutableDictionary* dic;

@end
