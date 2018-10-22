/**
 * MAGoodsReusableHeader.m 16/11/11
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MAGoodsReusableHeader.h"

#import "JKViews.h"

@interface MAGoodsReusableHeader () {
    
    JKLabel *_titleLabel;       //标题
    
    JKButton *_moreBtn;         //更多>>
}

@end

@implementation MAGoodsReusableHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        
        CGFloat assumeHeaderH = 48.f;
        
        CGFloat btnW = [JKAutoFitsWidthLabel widthForLabelText:@"更多>>" font:FONT_HEL(14.f)] + 10.f;
        CGFloat btnX = SCREEN_WIDTH - btnW - 8.f;
        
        _moreBtn = [JKButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setFrame:CGRectMake(btnX, 0.f, btnW, assumeHeaderH)];
        _moreBtn.titleLabel.font = FONT_HEL(14);
        [_moreBtn setTitle:@"更多>>" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:RGBGRAY(150.f) forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreBtn];
        
        CGFloat titleLabelW = btnX - 8.f - 5.f;
        
        _titleLabel = [[JKLabel alloc] initWithFrame:CGRectMake(8.f, 0.f, titleLabelW, assumeHeaderH)];
        _titleLabel.font = FONT_HEL(15.f);
        _titleLabel.textColor = RGBGRAY(100.f);
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    
    _title = title;
    _titleLabel.text = title;
}

- (void)moreBtn:(id)sender {
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(goodsHeaderSeeMoreGoodsAtSection:)]) {
        [_delegate goodsHeaderSeeMoreGoodsAtSection:_section];
    }
}

@end
