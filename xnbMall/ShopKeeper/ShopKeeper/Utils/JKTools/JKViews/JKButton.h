//
//  JKButton.h
//  LifeTelling
//
//  Created by IOS－001 on 15/4/17.
//  Copyright (c) 2015年 E-Techco Information Technologies Co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,BtnTitlePosition) {
    BtnTitlePositionTop,
    BtnTitlePositionLeft,
    BtnTitlePositionRigtht,
    BtnTitlePositionBottom
};

@interface JKButton : UIButton

@property(nonatomic,assign)CGFloat orgX;
@property(nonatomic,assign)CGFloat orgY;

@property(nonatomic,assign)CGFloat centerX;
@property(nonatomic,assign)CGFloat centerY;

@property(nonatomic,readonly)CGFloat maxX;
@property(nonatomic,readonly)CGFloat maxY;
@property(nonatomic,assign)CGFloat fWidth;
@property(nonatomic,assign)CGFloat fHeight;

+(void)layoutImageAndTitleForBtn:(UIButton *)btn titlePosition:(BtnTitlePosition)titlePosition;

-(void)showImageAtX:(CGFloat)X Y:(CGFloat)Y width:(CGFloat)width height:(CGFloat)height;

-(void)showTitleAtX:(CGFloat)X Y:(CGFloat)Y width:(CGFloat)width height:(CGFloat)height;
@end
