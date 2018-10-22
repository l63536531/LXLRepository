//
//  JKTextField.h
//  LifeTelling
//
//  Created by IOS－001 on 15/5/25.
//  Copyright (c) 2015年 E-Techco Information Technologies Co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKTextField : UITextField

@property(nonatomic,assign)CGFloat orgX;
@property(nonatomic,assign)CGFloat orgY;

@property(nonatomic,assign)CGFloat centerX;
@property(nonatomic,assign)CGFloat centerY;

@property(nonatomic,readonly)CGFloat maxX;
@property(nonatomic,readonly)CGFloat maxY;
@property(nonatomic,assign)CGFloat fWidth;
@property(nonatomic,assign)CGFloat fHeight;

@end
