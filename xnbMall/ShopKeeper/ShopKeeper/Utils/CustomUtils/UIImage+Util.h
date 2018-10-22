//
//  UIImage+Util.h
//  TaskGanGan
//
//  Created by zzheron on 15/11/2.
//  Copyright © 2015年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)

- (UIImage *)imageMaskedWithColor:(UIColor *)maskColor;
- (UIImage *)cropToRect:(CGRect)rect;

@end
