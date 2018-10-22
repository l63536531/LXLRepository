//
//  JKAutoFitsWidthLabel.m
//  LifeTelling
//
//  Created by IOS－001 on 15/4/25.
//  Copyright (c) 2015年 E-Techco Information Technologies Co., LTD. All rights reserved.
//

#import "JKAutoFitsWidthLabel.h"

@implementation JKAutoFitsWidthLabel

/**
 *  必须先设置font，后设置text
 *  如果label原始高度小于所需要的最小高度，则自动将label高度调整为所需要的最小高度
 */
-(void)setText:(NSString *)text
{
    [super setText:text];
    CGSize miniSize = [text sizeWithAttributes:@{NSFontAttributeName:self.font}];

    CGRect frame = self.frame;
    frame.size.width = miniSize.width;
    
    if (frame.size.height<miniSize.height) {
        frame.size.height = miniSize.height;
    }
    
    [self setFrame:frame];
}

//宽度固定，不随文字长短变化
-(void)setText:(NSString *)text WithFixedWidth:(CGFloat)fixedWidth
{
    self.fWidth = fixedWidth;
    [super setText:text];
}

//宽度根据text变化，但最大宽度不超过maxWidth
-(void)setText:(NSString *)text WithMaxWidth:(CGFloat)maxWidth
{
    CGFloat expectedWidth = [JKAutoFitsWidthLabel widthForLabelText:text font:self.font];
    
    if (expectedWidth > maxWidth) {
        self.fWidth = maxWidth;
    }else
    {
        self.fWidth = expectedWidth;
    }
    [super setText:text];
}

//固定高度50 ,50足以容纳一般的字体高度
+(CGFloat)widthForLabelText:(NSString *)text font:(UIFont *)font
{
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 50.f) options:NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:font} context:nil].size;
    return size.width;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
