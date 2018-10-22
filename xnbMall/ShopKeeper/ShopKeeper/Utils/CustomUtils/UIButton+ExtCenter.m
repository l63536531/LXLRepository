//
//  UIButton+ExtCenter.m
//  ShopKeeper
//
//  Created by zzheron on 16/6/22.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "UIButton+ExtCenter.h"

@implementation UIButton (ExtCenter)


- (void)verticalImageAndTitle:(CGFloat)spacing
{
    //self.titleLabel.backgroundColor = [UIColor greenColor];
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    //CGSize textSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
    
    
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
}


- (void)verticalImageRight:(CGFloat)spacing
{
    //self.titleLabel.backgroundColor = [UIColor greenColor];
    CGSize imageSize = self.imageView.frame.size;
    //CGSize titleSize = self.titleLabel.frame.size;
    //CGSize textSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
    
    
    //CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    //if (imageSize.height + 0.5 < frameSize.height) {
    //    imageSize.height = frameSize.height;
    //}
    //CGFloat totalWidth = (imageSize.width + titleSize.width + spacing);
    //self.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width+imageSize.width+spacing, 0.0, 0);
    //self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, titleSize.width+imageSize.width+spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, textSize.width+spacing, 0, -textSize.width-spacing);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width-spacing, 0, imageSize.width+spacing);
}


@end
