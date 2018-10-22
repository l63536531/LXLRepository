/**
 * MAGoodsDetailsTitleView.m 16/11/18
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MAGoodsDetailsTitleView.h"

#import "JKViews.h"

@interface MAGoodsDetailsTitleView () {
    
    JKLabel *_titleLabel;
    JKLabel *_descLabel;
    JKLabel *_priceLabel;
    
    JKButton *_shareBtn;
    
    JKView *_separator;
}

@end

@implementation MAGoodsDetailsTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 0.f)];
    if (self != nil) {
        
        CGFloat cellW = SCREEN_WIDTH;
        CGFloat leading = 8.f;
        
        CGFloat shareBtnW = 30.f;
        
        CGFloat titleLbaelW = cellW - shareBtnW - 20.f;
        
        _titleLabel = [[JKLabel alloc] initWithFrame:CGRectMake(leading, 8.f, titleLbaelW, 38.f)];
        _titleLabel.font = FONT_HEL(15.f);
        _titleLabel.textColor = RGBGRAY(100.f);
        _titleLabel.numberOfLines = 2;
        [self addSubview:_titleLabel];
        _titleLabel.text = @"title";
        
        _descLabel = [[JKLabel alloc] initWithFrame:CGRectMake(leading, _titleLabel.maxY + 4.f, titleLbaelW, 21.f)];
        _descLabel.font = FONT_HEL(12.f);
        _descLabel.textColor = RGBGRAY(100.f);
        [self addSubview:_descLabel];
        _descLabel.text = @"desc";
        
        _priceLabel = [[JKLabel alloc] initWithFrame:CGRectMake(leading, _descLabel.maxY + 4.f, titleLbaelW, 21.f)];
        _priceLabel.font = FONT_HEL(15.f);
        _priceLabel.textColor = THEMECOLOR;
        [self addSubview:_priceLabel];
        _priceLabel.text = @"售价￥";
        
        _shareBtn = [JKButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setFrame:CGRectMake(cellW - shareBtnW - 8.f, 8.f, shareBtnW, shareBtnW)];
        [_shareBtn setBackgroundImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_shareBtn];
        
        JKLabel *shareLabel = [[JKLabel alloc] initWithFrame:CGRectMake(0.f, _shareBtn.maxY + 0.f, 40.f, 21.f)];
        shareLabel.centerX = _shareBtn.centerX;
        shareLabel.textAlignment = NSTextAlignmentCenter;
        shareLabel.font = FONT_HEL(14.f);
        shareLabel.textColor = RGBGRAY(150.f);
        [self addSubview:shareLabel];
        shareLabel.text = @"分享";
        
        _separator = [[JKView alloc] initWithFrame:CGRectMake(0.f, _priceLabel.maxY + 8.f, SCREEN_WIDTH, 10.f)];
        _separator.backgroundColor = RGBGRAY(240.f);
        [self addSubview:_separator];
        
        self.fHeight = _separator.maxY;
        
    }
    return self;
}

#pragma mark - Touch events

- (void)shareBtn:(id)sender {
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(titleViewShare)]) {
        [_delegate titleViewShare];
    }
}

#pragma mark - setters

- (void)setTitle:(NSString *)title {
    
    _titleLabel.text = title;
}

- (void)setDesc:(NSString *)desc {
    
    _descLabel.text = desc;
}

- (void)setPrice:(CGFloat)price {
    
    if (price > 0) {
        _priceLabel.text = [NSString stringWithFormat:@"售价￥%.2f",price];
    }else {
        _priceLabel.text = @"暂无货";
    }
}

@end
