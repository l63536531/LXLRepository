//
//  SaleActivityController.m
//  ShopKeeper
//
//  Created by frechai on 16/10/19.
//  Copyright © 2016年 51xnb. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface UIFactory : NSObject
//创建一个按钮通过图片或者title
+ (UIButton *)creatButtonCustomWithNorTitle:(NSString *)norTitle NorTextColor:(UIColor *)norColor NorImage:(UIImage *)norImage SeleTitle:(NSString *)seleTitle SeleTextColor:(UIColor *)seleColor SeleImage:(UIImage *)seleImage funtion:(SEL)funtion target:(id)target font:(CGFloat)font;

//创建一个label来设置它的字体颜色
+ (UILabel*)creatLabelWithtext:(NSString *)text textColor:(UIColor *)textcolor font:(CGFloat)font textAlignment:(NSTextAlignment)alignment ;
//将当前的view（或者它的子类）添加一个手势
+ (void)creatTapGestureRecognizerForImageView:(UIView *)view target:(id)target action:(SEL)action;
//创建一个图片 通过图片或者颜色
+ (UIImageView *)creatImageViewWithImage:(UIImage *)image ;

//创建一个texfield yes则左右边保留间距 no 则没有

+ (UITextField *)creatTextFileldWithHolder:(NSString *)holder LayerColor:(UIColor *)layerColor LayerWidth:(CGFloat)layerWidth HasSpace:(BOOL)hasOrNot;



@end
