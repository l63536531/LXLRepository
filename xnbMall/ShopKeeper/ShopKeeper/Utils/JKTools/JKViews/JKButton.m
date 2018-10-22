//
//  JKButton.m
//  LifeTelling
//
//  Created by IOS－001 on 15/4/17.
//  Copyright (c) 2015年 E-Techco Information Technologies Co., LTD. All rights reserved.
//

#import "JKButton.h"

#import "JKTool.h"

@implementation JKButton

+(id)buttonWithType:(UIButtonType)buttonType
{
    JKButton *btn = [super buttonWithType:buttonType];
    if (btn) {
        [btn setExclusiveTouch:YES];
        btn.backgroundColor = [UIColor clearColor];
    }
    return btn;
}

#pragma mark - 

+(void)layoutImageAndTitleForBtn:(UIButton *)btn titlePosition:(BtnTitlePosition)titlePosition
{
    btn.titleLabel.hidden = YES;//屏蔽掉title、image位置互换的动画
    btn.imageView.hidden = YES;
    
    btn.titleEdgeInsets = UIEdgeInsetsZero;//必须的！！！，否则以下方式计算就不对
    btn.imageEdgeInsets = UIEdgeInsetsZero;//必须的！！！，否则以下方式计算就不对
    
    CGFloat btnW = btn.frame.size.width;
    CGFloat btnH = btn.frame.size.height;
    
    CGFloat imageW = btn.imageView.frame.size.width;
    CGFloat imageH = btn.imageView.frame.size.height;
    
    CGFloat titleW = btn.titleLabel.frame.size.width;
    CGFloat titleH = btn.titleLabel.frame.size.height;
    
    CGPoint titleLableStartCenter = btn.titleLabel.center;
    CGPoint imageViewStartCenter = btn.imageView.center;
    
    CGPoint titleLableEndCenter;
    CGPoint imageViewEndCenter;
    
    switch (titlePosition) {
        case BtnTitlePositionTop:
        {
            titleLableEndCenter = CGPointMake(btnW/2.f,btnH/2.f-(imageH+titleH)/2.f+titleH/2.f);
            imageViewEndCenter = CGPointMake(btnW/2.f,btnH/2.f+(imageH+titleH)/2.f-imageH/2.f);
        }
            break;
        case BtnTitlePositionLeft:
        {
            titleLableEndCenter = CGPointMake(btnW/2.f-(imageW+titleW)/2.f+titleW/2.f, btnH/2.f);
            imageViewEndCenter = CGPointMake(btnW/2.f+(imageW+titleW)/2.f-imageW/2.f, btnH/2.f);
        }
            break;
        case BtnTitlePositionBottom:
        {
            titleLableEndCenter = CGPointMake(btnW/2.f,btnH/2.f+(imageH+titleH)/2.f-titleH/2.f);
            imageViewEndCenter = CGPointMake(btnW/2.f,btnH/2.f-(imageH+titleH)/2.f+imageH/2.f);
        }
            break;
        case BtnTitlePositionRigtht:
        {
            titleLableEndCenter = CGPointMake(btnW/2.f+(imageW+titleW)/2.f-titleW/2.f, btnH/2.f);
            imageViewEndCenter = CGPointMake(btnW/2.f-(imageW+titleW)/2.f+imageW/2.f, btnH/2.f);
        }
            break;
            
        default:
            break;
    }
    
    
    
    //title edgeInsets
    CGFloat titleTopInset = titleLableEndCenter.y-titleLableStartCenter.y;
    CGFloat titleLeftInset = titleLableEndCenter.x - titleLableStartCenter.x;
    CGFloat titleBottomInset = -titleTopInset;
    CGFloat titleRightInset = -titleLeftInset;
    
    btn.titleEdgeInsets = UIEdgeInsetsMake(titleTopInset, titleLeftInset, titleBottomInset, titleRightInset);
    //image edgeInsets
    CGFloat imageTopInset = imageViewEndCenter.y-imageViewStartCenter.y;
    CGFloat imageLeftInset = imageViewEndCenter.x-imageViewStartCenter.x;
    CGFloat imageBottomInset = -imageTopInset;
    CGFloat imageRightInset = -imageLeftInset;
    
    btn.imageEdgeInsets = UIEdgeInsetsMake(imageTopInset, imageLeftInset, imageBottomInset, imageRightInset);
    
    btn.titleLabel.hidden = NO;
    btn.imageView.hidden = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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

#pragma mark - 
-(void)showImageAtX:(CGFloat)X Y:(CGFloat)Y width:(CGFloat)width height:(CGFloat)height
{
    [JKTool showImageAtX:X Y:Y width:width height:height btn:self];
}

-(void)showTitleAtX:(CGFloat)X Y:(CGFloat)Y width:(CGFloat)width height:(CGFloat)height
{
    [JKTool showTitleAtX:X Y:Y width:width height:height btn:self];
}

@end
