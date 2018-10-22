/**
 * MAGoodsDetailWebHeader.m 16/11/19
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MAGoodsDetailWebHeader.h"

#import "JKViews.h"

@interface MAGoodsDetailWebHeader () {
    
    JKView *_redMask;
}

@end

@implementation MAGoodsDetailWebHeader

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 50.f)];
    if (self != nil) {
        
        CGFloat btnH = 50.f;
        CGFloat btnW = SCREEN_WIDTH / 3.f;
        
        UIColor *spColor = RGBGRAY(240.f);
        
        JKView *hSp1 = [[JKView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 1.f)];
        hSp1.backgroundColor = spColor;
        [self addSubview:hSp1];
        
        JKView *hSp2 = [[JKView alloc] initWithFrame:CGRectMake(0.f, 49, SCREEN_WIDTH, 1.f)];
        hSp2.backgroundColor = spColor;
        [self addSubview:hSp2];
        
        JKView *vSp1 = [[JKView alloc] initWithFrame:CGRectMake(btnW - 0.5f, 0.f, 1.f, btnH)];
        vSp1.backgroundColor = spColor;
        [self addSubview:vSp1];
        
        JKView *vSp2 = [[JKView alloc] initWithFrame:CGRectMake(btnW * 2.f - 0.5f, 0.f, 1.f, btnH)];
        vSp2.backgroundColor = spColor;
        [self addSubview:vSp2];
        
//        JKView *redMask = [[JKView alloc] initWithFrame:CGRectMake(0.f, 0.f, btnW, btnH)]; //去掉选中框框
//        redMask.layer.borderColor = THEMECOLOR.CGColor;
//        redMask.layer.borderWidth = 1.f;
//        [self addSubview:redMask];
//        _redMask = redMask; //去掉选中框框
        
        
        NSArray *titleArray = @[@"商品详情",@"规格参数",@"包装售后"];
        for (int i = 0; i < 3; i++) {
            
            CGFloat x = btnW * i;
            JKButton *btn = [JKButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(x, 0.f, btnW, btnH)];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:RGBGRAY(100.f) forState:UIControlStateNormal];
            [btn setTitleColor:THEMECOLOR forState:UIControlStateSelected];
            btn.titleLabel.font = FONT_HEL(16.f);
            [btn addTarget:self action:@selector(headertn:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            [self addSubview:btn];
            if (i == 0) {
                btn.selected = YES;
            }
        }
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)headertn:(JKButton *)btn {
    
//    _redMask.orgX = _redMask.fWidth * btn.tag;//去掉选中框框
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[JKButton class]]) {
            JKButton *enumBtn = (JKButton *)view;
            enumBtn.selected = (enumBtn.tag == btn.tag);
        }
    }
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(goodsDetailsWebHeaderBtnClicked:)]) {
        [_delegate goodsDetailsWebHeaderBtnClicked:btn.tag];
    }
}

@end
