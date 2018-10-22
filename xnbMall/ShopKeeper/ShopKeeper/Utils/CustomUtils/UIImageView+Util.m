//
//  UIImageView+Util.m
//  TaskGanGan
//
//  Created by zzheron on 15/11/2.
//  Copyright © 2015年 zzheron. All rights reserved.
//

#import "UIImageView+Util.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (Util)

- (void)loadPortrait:(NSURL *)portraitURL
{
    [self sd_setImageWithURL:portraitURL placeholderImage:[UIImage imageNamed:@"default-portrait"] options:0];
}

@end
