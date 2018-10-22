/**
 * MACreditsGoodsCell.m 16/11/14
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MACreditsGoodsCell.h"

#import "JKViews.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MACreditsGoodsCell () {
    JKImageView *_imageView;            //商品图片
    JKLabel *_titleLabel;               //商品title
    JKLabel *_priceLabel;               //价格 或 已抢光
}

@end

@implementation MACreditsGoodsCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self != nil) {
        
        CGFloat width = frame.size.width;
        CGFloat imageH = width * 1.f;
        
        _imageView = [[JKImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, imageH)];
        [self.contentView addSubview:_imageView];
        
        
        CGFloat btnW = 44.f;
        CGFloat btnH = 32.f;
        CGFloat btnX = width - btnW - 4.f;
        CGFloat labelW = btnX - 4.f - 1.f;
        
        CGFloat titleLabelH = 34.f;
        _titleLabel = [[JKLabel alloc] initWithFrame:CGRectMake(4.f, _imageView.maxY, labelW, titleLabelH)];
        _titleLabel.font = FONT_HEL(11.f);
        _titleLabel.textColor = RGBGRAY(150.f);
        _titleLabel.numberOfLines = 2;
        [self addSubview:_titleLabel];
        
        CGFloat labelH = 18.f;
        
        _priceLabel = [[JKLabel alloc] initWithFrame:CGRectMake(4.f, _titleLabel.maxY + 0.f, labelW, labelH)];
        _priceLabel.font = FONT_HEL(11.f);
        _priceLabel.textColor = THEMECOLOR;
        [self addSubview:_priceLabel];
        
        JKButton *exchangeBtn = [JKButton buttonWithType:UIButtonTypeCustom];
        [exchangeBtn setFrame:CGRectMake(btnX, _imageView.maxY + 10.f, btnW, btnH)];
        exchangeBtn.backgroundColor = [UIColor whiteColor];// KFontColor(@"#ffffff");
        [exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
        [exchangeBtn setTitleColor:KFontColor(@"#ec584c") forState:UIControlStateNormal];
        exchangeBtn.titleLabel.font = FONT_HEL(13.f);
        [exchangeBtn addTarget:self action:@selector(exchangeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:exchangeBtn];
        
        exchangeBtn.layer.borderWidth = 1;
        exchangeBtn.layer.cornerRadius = 4.0;
        exchangeBtn.layer.borderColor = KFontColor(@"#ec584c").CGColor;
        exchangeBtn.layer.masksToBounds =YES;
        

        
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)exchangeBtn:(JKButton *)btn {
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(creditsCellExchangeGoodsAtItem:)]) {
        [_delegate creditsCellExchangeGoodsAtItem:_item];
    }
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


- (void)setCredits:(NSInteger)credits {
    _priceLabel.text = [NSString stringWithFormat:@"需要：%zd积分",credits];

//    NSRange range1 = [_priceLabel.text rangeOfString:@"要 "];
//    NSRange range2 = [_priceLabel.text rangeOfString:@" 积"];
//    
//    
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_priceLabel.text];
//    [str addAttribute:NSForegroundColorAttributeName
//                value:KFontColor(@"#ec584c")
//                range:NSMakeRange(range1.location+range1.length, range2.location - range1.location-range1.length)];
//    [str addAttribute:NSForegroundColorAttributeName
//                value:[UIColor lightGrayColor]
//                range:NSMakeRange(0,range1.location+range1.length)];
//    [str addAttribute:NSForegroundColorAttributeName
//                value:[UIColor lightGrayColor]
//                range:NSMakeRange(range2.location, _priceLabel.text.length-range2.location)];
//    
//    _priceLabel.attributedText=str;
   
}

@end
