//
//  UIScrollView+ScalableCover.h
//  ScalableCover
//
//  Created by zzheron on 15/11/2.
//  Copyright © 2015年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat MaxHeight = 200;


@interface ScalableCover : UIImageView

@property (nonatomic, weak) UIScrollView *scrollView;

@end




@interface UIScrollView (ScalableCover)

@property (nonatomic, weak) ScalableCover *scalableCover;

- (void)addScalableCoverWithImage:(UIImage *)image;
- (void)removeScalableCover;

@end

