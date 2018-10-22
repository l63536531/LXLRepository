//
//  JKAutoFitsWidthLabel.h
//  LifeTelling
//
//  Created by IOS－001 on 15/4/25.
//  Copyright (c) 2015年 E-Techco Information Technologies Co., LTD. All rights reserved.
//

#import "JKLabel.h"

/**
 *  @author 黎国基, 16-09-08 10:09
 *
 *  警告，如果设置字符串尾部有空格，计算长度的时候（空格的长度）会被自动忽略！！！
 */
@interface JKAutoFitsWidthLabel : JKLabel

+(CGFloat)widthForLabelText:(NSString *)text font:(UIFont *)font;

//宽度固定，不随文字长短变化
-(void)setText:(NSString *)text WithFixedWidth:(CGFloat)fixedWidth;

//宽度根据text变化，但最大宽度不超过maxWidth
-(void)setText:(NSString *)text WithMaxWidth:(CGFloat)maxWidth;

@end
