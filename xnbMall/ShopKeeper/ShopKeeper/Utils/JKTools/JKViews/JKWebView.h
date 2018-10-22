/**
 * JKWebView.h 16/11/18
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import <UIKit/UIKit.h>

@interface JKWebView : UIWebView

@property(nonatomic,assign)CGFloat orgX;
@property(nonatomic,assign)CGFloat orgY;

@property(nonatomic,assign)CGFloat centerX;
@property(nonatomic,assign)CGFloat centerY;

@property(nonatomic,readonly)CGFloat maxX;
@property(nonatomic,readonly)CGFloat maxY;

//fWidht - means frame.size.width
@property(nonatomic,assign)CGFloat fWidth;
@property(nonatomic,assign)CGFloat fHeight;

//获取拥有view的controller
- (UIViewController*)viewController;

@end
