/**
 * MAShoppingCartHeader.m 16/11/15
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MAShoppingCartHeader.h"

#import "JKViews.h"

@interface MAShoppingCartHeader () {
    
    JKButton *_checkBtn;                    //勾选按钮
    
    JKLabel *_customTitleLabel;              //标题
    JKButton *_lookForSameGoodsBtn;         //凑单/查看更多按钮。只是文案改变，都是去看同厂家可混批商品
}

@end

@implementation MAShoppingCartHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self != nil) {
        
        CGFloat headerH = [MAShoppingCartHeader headerHeight];
        
        //勾选按钮
        CGFloat checkBtnW = 30.f;
        _checkBtn =  [JKButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setFrame:CGRectMake(5.f, 0.f, checkBtnW, checkBtnW)];
        _checkBtn.centerY = headerH / 2.f;
        [_checkBtn setImage:[UIImage imageNamed:@"uncheckedCircle"] forState:UIControlStateNormal];
        [_checkBtn setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateSelected];
        [_checkBtn addTarget:self action:@selector(checkBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_checkBtn];
        
        UIFont *lookForSameGoodsBtnFont = FONT_HEL(12.f);
        CGFloat lookForSameGoodsBtnW = [JKAutoFitsWidthLabel widthForLabelText:@"查看更多" font:lookForSameGoodsBtnFont] + 8.f;
        CGFloat lookForSameGoodsBtnX = SCREEN_WIDTH - 5.f - lookForSameGoodsBtnW;
        
        _lookForSameGoodsBtn = [JKButton buttonWithType:UIButtonTypeCustom];
        [_lookForSameGoodsBtn setFrame:CGRectMake(lookForSameGoodsBtnX, 0.f, lookForSameGoodsBtnW, 35.f)];
        _lookForSameGoodsBtn .centerY = headerH / 2.f;
        _lookForSameGoodsBtn.titleLabel.font = lookForSameGoodsBtnFont;
        [_lookForSameGoodsBtn setTitle:@"去凑单" forState:UIControlStateNormal];
        [_lookForSameGoodsBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
        [_lookForSameGoodsBtn addTarget:self action:@selector(lookForSameGoodsBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_lookForSameGoodsBtn];
        
        
        CGFloat customTitleLabelX = _checkBtn.maxX + 4.f;
        CGFloat customTitleLabelW = _lookForSameGoodsBtn.orgX - customTitleLabelX - 4.f;
        CGFloat customTitleLabelH = 40.f;
        _customTitleLabel = [[JKLabel alloc] initWithFrame:CGRectMake(customTitleLabelX,0.f, customTitleLabelW , customTitleLabelH)];
        _customTitleLabel.centerY = headerH / 2.f;
        _customTitleLabel.font = FONT_HEL(12.f);
        _customTitleLabel.textColor = RGBGRAY(100.f);
        _customTitleLabel.numberOfLines = 2;
        [self.contentView addSubview:_customTitleLabel];
        
        CGFloat bottmSpX = customTitleLabelX - 3.f;
        JKView *bottmSp = [[JKView alloc] initWithFrame:CGRectMake(bottmSpX, headerH - 1.f, SCREEN_WIDTH - bottmSpX, 1.f)];
        bottmSp.backgroundColor = RGBGRAY(240.f);
        [self.contentView addSubview:bottmSp];
        
        JKView *vSP = [[JKView alloc] initWithFrame:CGRectMake(bottmSpX, 0.f, 1.f, headerH)];
        vSP.backgroundColor = RGBGRAY(240.f);
        [self.contentView addSubview:vSP];
    }
    return self;
}

#pragma mark - Touch events

- (void)checkBtn:(JKButton *)btn {
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(shoppingCartHeaderCheckAtSection:)]) {
        [_delegate shoppingCartHeaderCheckAtSection:_section];
    }
}

- (void)lookForSameGoodsBtn:(JKButton *)btn {
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(shoppingCartHeaderLookForSameGoodsAtSection:)]) {
        [_delegate shoppingCartHeaderLookForSameGoodsAtSection:_section];
    }
}

#pragma mark - setters

- (void)setIsChecked:(BOOL)isChecked {
    _checkBtn.selected = isChecked;
}

/**
 *  @author 黎国基, 16-11-15 19:11
 *
 *  是否支持混批
 *
 *  @param isMinBuy     是否支持混批（如果为NO，则后面的参数都不要不需要，可随便传入）
 *  @param minCount     如果支持混批，最低购买数量
 *  @param currentCount 如果支持混批，当前已选购买数量
 *  @param increment    如果支持混批，增量
 *  @param unit         单位（用于显示，千克/件/升等等）
 */
- (void)setIsMinBuy:(BOOL)isMinBuy minCount:(NSInteger)minCount currentCount:(NSInteger)currentCount increment:(NSInteger)increment unit:(NSString *)unit{
    
    if (isMinBuy) {
        
        _lookForSameGoodsBtn.hidden = NO;
        if (currentCount >= minCount) {
            //满足最起订量，
            if (currentCount % minCount % increment == 0) {
                //满足条件
                _customTitleLabel.text = [NSString stringWithFormat:@"起订量%zd%@，增订量%zd%@",minCount,unit,increment,unit];
                
                [_lookForSameGoodsBtn setTitle:@"查看更多" forState:UIControlStateNormal];
            }else {
                //不满足条件。不满足增量
                NSInteger lackCount = increment - (currentCount % minCount % increment);
                _customTitleLabel.text = [NSString stringWithFormat:@"起订量%zd%@，增订量%zd%@，还差%zd%@可下单",minCount,unit,increment,unit,lackCount,unit];
                
                [_lookForSameGoodsBtn setTitle:@"去凑单" forState:UIControlStateNormal];
            }
        }else {
            //不满足 起订量
            NSInteger lackCount = minCount - currentCount;
            _customTitleLabel.text = [NSString stringWithFormat:@"起订量%zd%@，增订量%zd%@，还差%zd%@可下单",minCount,unit,increment,unit,lackCount,unit];
            
            [_lookForSameGoodsBtn setTitle:@"去凑单" forState:UIControlStateNormal];
        }
    }else {
        
        _lookForSameGoodsBtn.hidden = YES;
        _customTitleLabel.text = @"不支持混批";
    }
}


#pragma mark -

+ (CGFloat)headerHeight {
    return 40.f;
}

@end
