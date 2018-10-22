/**
 * JKWebView.m 16/11/18
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "JKWebView.h"

@implementation JKWebView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - getters
-(CGFloat)orgX
{
    return self.frame.origin.x;
}

-(CGFloat)orgY
{
    return self.frame.origin.y;
}

-(CGFloat)centerX
{
    return self.center.x;
}

-(CGFloat)centerY
{
    return self.center.y;
}

-(CGFloat)maxX
{
    return self.frame.origin.x+self.frame.size.width;
}

-(CGFloat)maxY
{
    return self.frame.origin.y+self.frame.size.height;
}

-(CGFloat)fWidth
{
    return self.frame.size.width;
}

-(CGFloat)fHeight
{
    return self.frame.size.height;
}

#pragma mark - setters
-(void)setOrgX:(CGFloat)orgX
{
    CGRect frame = self.frame;
    frame.origin.x = orgX;
    [self setFrame:frame];
}

-(void)setOrgY:(CGFloat)orgY
{
    CGRect frame = self.frame;
    frame.origin.y = orgY;
    [self setFrame:frame];
}

-(void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    [self setCenter:center];
}

-(void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    [self setCenter:center];
}

-(void)setFWidth:(CGFloat)fWidth
{
    CGRect frame = self.frame;
    frame.size.width = fWidth;
    [self setFrame:frame];
}

-(void)setFHeight:(CGFloat)fHeight
{
    CGRect frame = self.frame;
    frame.size.height = fHeight;
    [self setFrame:frame];
}

#pragma mark - get viewController
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
