/**
 * MAHotGoodsCell.m 16/11/12
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MAHotGoodsCell.h"

#import "JKViews.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MAHotGoodsCell () {
    JKImageView *_imageView;            //商品图片
    JKLabel *_titleLabel;               //商品title
    JKLabel *_priceLabel;               //价格 或 已抢光
}

@end

@implementation MAHotGoodsCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self != nil) {
        
        CGFloat width = frame.size.width;
        CGFloat imageH = width * 1.f;
        
        _imageView = [[JKImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, imageH)];
        [self.contentView addSubview:_imageView];
        
        CGFloat titleLabelH = 34.f;
        _titleLabel = [[JKLabel alloc] initWithFrame:CGRectMake(4.f, _imageView.maxY, width - 8.f, titleLabelH)];
        _titleLabel.font = FONT_HEL(12.f);
        _titleLabel.textColor = RGBGRAY(150.f);
        _titleLabel.numberOfLines = 2;
        [self addSubview:_titleLabel];
        
        JKView *sp = [[JKView alloc] initWithFrame:CGRectMake(0.f, _titleLabel.maxY, width, 1.f)];
        sp.backgroundColor = RGBGRAY(240.f);
        [self.contentView addSubview:sp];
        
        CGFloat labelH = 18.f;
        
        _priceLabel = [[JKLabel alloc] initWithFrame:CGRectMake(4.f, sp.maxY + 0.f, width - 8.f, labelH)];
        _priceLabel.font = FONT_HEL(12.f);
        _priceLabel.textColor = THEMECOLOR;
        [self addSubview:_priceLabel];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setImageUrlStr:(NSString *)imageUrlStr {
    
    if (imageUrlStr == nil) {
        [_imageView setImage:[UIImage imageNamed:@"commonPlaceHolderIcon"]];
    }else {
        NSURL *url = [NSURL URLWithString:imageUrlStr];
        [_imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"commonPlaceHolderIcon"]];
    }
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleLabel.text = titleStr;
}

- (void)setPrice:(CGFloat)price {
    _price = price;
    if (_isSellOut) {
        _priceLabel.text = @"已抢光";
    }else {
        _priceLabel.text = [NSString stringWithFormat:@"活动价：￥%.2f",price];
    }
}

- (void)setIsSellOut:(BOOL)isSellOut {
    if (_isSellOut) {
        _priceLabel.text = @"已抢光";
    }else {
        _priceLabel.text = [NSString stringWithFormat:@"活动价：￥%.2f",_price];
    }
}

/**
 *  @author 黎国基, 16-11-14 09:11
 *
 *  礼券直接设置 价格label text
 */

- (void)setPriceLabelText:(NSString *) text {
    _priceLabel.text = text;
}

@end
