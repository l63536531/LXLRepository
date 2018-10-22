/**
 * MASpecBtn.m 16/11/19
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MASpecBtn.h"

@implementation MASpecBtn

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    
    MASpecBtn *btn = [super buttonWithType:buttonType];
    
    btn.layer.cornerRadius = 5.f;
    btn.layer.borderWidth = 1.f;
    btn.layer.borderColor = [UIColor clearColor].CGColor;
    btn.clipsToBounds = YES;

    return btn;
}

/**
 *  @author 黎国基, 16-11-19 10:11
 *
 *  有3种状态--不可选 0、可选 1、选中 2
 */

- (void)setSpecState:(NSInteger)specState {
    
    _specState = specState;
    CGFloat bgGrayf = 240.f;
    if (_specState == 0) {
        //不可选
        self.backgroundColor = RGBGRAY(bgGrayf);
        [self setTitleColor:RGBGRAY(220) forState:UIControlStateNormal];
    }else if (_specState == 1) {
        //可选
        self.backgroundColor = RGBGRAY(bgGrayf);
        [self setTitleColor:RGBGRAY(150) forState:UIControlStateNormal];
    }else if (_specState == 2) {
        //选中
        self.backgroundColor = RGBCOLOR(226.f, 89.f, 84.f);
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

@end
