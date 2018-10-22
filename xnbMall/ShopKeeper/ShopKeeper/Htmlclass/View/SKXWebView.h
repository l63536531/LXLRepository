//
//  SKBaseWebView.h
//  ShopKeeper
//
//  Created by XNB2 on 16/11/1.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class SKXWebView;

@protocol SKXWebViewDelegate <NSObject>


@optional
- (void)zlcwebView:(SKXWebView *)webview didFinishLoadingURL:(NSURL *)URL;
- (void)zlcwebView:(SKXWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error;
- (void)zlcwebView:(SKXWebView *)webview shouldStartLoadWithURL:(NSURL *)URL;
- (void)zlcwebViewDidStartLoad:(SKXWebView *)webview;

@end

@interface SKXWebView : UIView <WKNavigationDelegate, WKUIDelegate, UIWebViewDelegate,WKScriptMessageHandler>

#pragma mark - Public Properties

//zlcdelegate
@property (nonatomic, weak) id <SKXWebViewDelegate> delegate;

// The main and only UIProgressView
@property (nonatomic, strong) UIProgressView *progressView;
// The web views
// Depending on the version of iOS, one of these will be set
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIWebView *uiWebView;



#pragma mark - Initializers view
- (instancetype)initWithFrame:(CGRect)frame;


#pragma mark - Static Initializers
@property (nonatomic, strong) UIBarButtonItem *actionButton;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *barTintColor;
@property (nonatomic, assign) BOOL actionButtonHidden;
@property (nonatomic, assign) BOOL showsURLInNavigationBar;
@property (nonatomic, assign) BOOL showsPageTitleInNavigationBar;



//Allow for custom activities in the browser by populating this optional array
@property (nonatomic, strong) NSArray *customActivityItems;

#pragma mark - Public Interface


// Load a NSURLURLRequest to web view
// Can be called any time after initialization
- (void)loadRequest:(NSURLRequest *)request;

// Load a NSURL to web view
// Can be called any time after initialization
- (void)loadURL:(NSURL *)URL;

// Loads a URL as NSString to web view
// Can be called any time after initialization
- (void)loadURLString:(NSString *)URLString;


// Loads an string containing HTML to web view
// Can be called any time after initialization
- (void)loadHTMLString:(NSString *)HTMLString;


@end
