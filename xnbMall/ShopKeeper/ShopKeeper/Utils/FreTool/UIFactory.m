//
//  SaleActivityController.m
//  ShopKeeper
//
//  Created by frechai on 16/10/19.
//  Copyright © 2016年 51xnb. All rights reserved.
//

#import "UIFactory.h"

@implementation UIFactory
+ (UIButton *)creatButtonCustomWithNorTitle:(NSString *)norTitle NorTextColor:(UIColor *)norColor NorImage:(UIImage *)norImage SeleTitle:(NSString *)seleTitle SeleTextColor:(UIColor *)seleColor SeleImage:(UIImage *)seleImage funtion:(SEL)funtion target:(id)target font:(CGFloat)font{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (norTitle||seleTitle) {
    [button setTitle:norTitle forState:UIControlStateNormal];
    [button setTitle:seleTitle forState:UIControlStateSelected];
    }
    [button setTitleColor:norColor forState:UIControlStateNormal];
    [button setTitleColor:seleColor forState:UIControlStateSelected];
    [button setImage:norImage forState:UIControlStateNormal];
    [button setImage:seleImage forState:UIControlStateSelected];

    [button addTarget:target action:funtion forControlEvents:UIControlEventTouchUpInside];
    
    
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    return button;
}

+ (UILabel*)creatLabelWithtext:(NSString *)text textColor:(UIColor *)textcolor font:(CGFloat)font textAlignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc]init];
    
    if (text) {
       label.text = text;
    }
    label.textColor = textcolor;
    label.font = [UIFont systemFontOfSize:font];
    label.textAlignment = alignment;
    label.numberOfLines = 0;
    return label;
    
    
}
+ (void)creatTapGestureRecognizerForImageView:(UIView *)view target:(id)target action:(SEL)action{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tap];
    
}
+ (UIImageView *)creatImageViewWithImage:(UIImage *)image {
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = image;
    return imageView;
    
}
+ (UITextField *)creatTextFileldWithHolder:(NSString *)holder LayerColor:(UIColor *)layerColor LayerWidth:(CGFloat)layerWidth HasSpace:(BOOL)hasOrNot{
    UITextField *textField =[[UITextField alloc] init];
    textField.layer.borderColor = layerColor.CGColor;
    textField.layer.borderWidth=layerWidth;
    textField.placeholder = holder;
    if (hasOrNot==YES) {
    textField.leftViewMode =UITextFieldViewModeAlways;
    textField.rightViewMode =UITextFieldViewModeAlways;
    UIView *left =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
    textField.leftView = left;
    UIView *right =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
    textField.rightView = right;
    }
    return textField;
 
}






@end
