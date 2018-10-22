//
//  JKTextField.m
//  LifeTelling
//
//  Created by IOS－001 on 15/5/25.
//  Copyright (c) 2015年 E-Techco Information Technologies Co., LTD. All rights reserved.
//

#import "JKTextField.h"

@implementation JKTextField

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

@end
