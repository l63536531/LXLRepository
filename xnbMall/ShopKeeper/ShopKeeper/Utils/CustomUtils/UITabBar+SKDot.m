//
//  UITabBar+SKDot.m
//  ShopKeeper
//
//  Created by XNB2 on 17/5/4.
//  Copyright © 2017年 Frechai. All rights reserved.
//

#import "UITabBar+SKDot.h"

//TabBar的数量
#define TabbarItemNums 4.0

@implementation UITabBar (SKDot)

//显示红点
- (void)showBadgeOnItmIndex:(NSInteger)index{
    [self removeBadgeOnItemIndex:index];
    //新建小红点
    UIView *bview = [[UIView alloc]init];
    bview.tag = 999+index;
    bview.layer.cornerRadius = 5;
    bview.clipsToBounds = YES;
    bview.backgroundColor = [UIColor redColor];
    CGRect tabFram = self.frame;
    
    float percentX = (index+0.6)/TabbarItemNums;
    CGFloat x = ceilf(percentX*tabFram.size.width);
    CGFloat y = ceilf(0.1*tabFram.size.height);
    bview.frame = CGRectMake(x, y, 10, 10);
    [self addSubview:bview];
    [self bringSubviewToFront:bview];
}
//隐藏红点
-(void)hideBadgeOnItemIndex:(NSInteger)index{
    [self removeBadgeOnItemIndex:index];
}
//移除控件
- (void)removeBadgeOnItemIndex:(NSInteger)index{
    for (UIView*subView in self.subviews) {
        if (subView.tag == 999+index) {
            [subView removeFromSuperview];
        }
    }
}
@end
