//
//  JKImageView.h
//  LifeTelling
//
//  Created by IOS－001 on 15/4/17.
//  Copyright (c) 2015年 E-Techco Information Technologies Co., LTD. All rights reserved.
//
/**
 *  封装一个view，唯一目的是快捷的获取view的x,y坐标，以及其最大x,y坐标
 */
#import <UIKit/UIKit.h>

@interface JKImageView : UIImageView
@property(nonatomic,assign)CGFloat orgX;
@property(nonatomic,assign)CGFloat orgY;

@property(nonatomic,assign)CGFloat centerX;
@property(nonatomic,assign)CGFloat centerY;

@property(nonatomic,readonly)CGFloat maxX;
@property(nonatomic,readonly)CGFloat maxY;
@property(nonatomic,assign)CGFloat fWidth;
@property(nonatomic,assign)CGFloat fHeight;
@end
