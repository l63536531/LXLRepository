/**
 * MAGoodsCountCellContent.m 16/11/19
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MAGoodsCountCellContent.h"

#import "JKViews.h"

@interface MAGoodsCountCellContent ()<UITextFieldDelegate> {
    JKTextField *_countTextField;           //件数
    
    JKView *_mixBuyBgView;                     //混批专有的内容
    JKLabel *_mixBuyTipsLabel;              //混批提示语
    JKButton *_infoIcon;                      //信息图标
}
@end

@implementation MAGoodsCountCellContent

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 0.f)];
    if (self != nil) {
        
        CGFloat cellContentH = 60.f;
        CGFloat spH = 10.f;             //分割线
        
        CGFloat countLbW = 30.f;       // '+','-'按钮的字
        CGFloat countLbH = countLbW;
        CGFloat countTextFieldW = 40.f;
        
        CGColorRef layerColor = RGBGRAY(240.f).CGColor;
        
        JKAutoFitsWidthLabel *preCountLabel = [[JKAutoFitsWidthLabel alloc] initWithFrame:CGRectMake(8.f, 0.f, 0.f, 21.f)];
        preCountLabel.centerY = (cellContentH - spH) / 2.f;
        preCountLabel.font = FONT_HEL(15.f);
        preCountLabel.textColor = RGBGRAY(100.f);
        preCountLabel.text = @"数量：";
        [self addSubview:preCountLabel];
        
        // '+','-'按钮的字
        JKLabel *minusLb = [[JKLabel alloc] initWithFrame:CGRectMake(preCountLabel.maxX, 0.f, countLbW , countLbH)];
        minusLb.centerY = preCountLabel.centerY;
        minusLb.font = FONT_HEL(24.f);
        minusLb.textAlignment = NSTextAlignmentCenter;
        minusLb.textColor = THEMECOLOR;
//        minusLb.text = @"－";//原来是 用text，现改为minusIcon，但保留边框*************************
        [self addSubview:minusLb];
        minusLb.layer.borderColor = layerColor;
        minusLb.layer.borderWidth = 1.f;
        
        CGFloat countIconD = 7.f;
        //"-","+"号
        JKImageView *minusIcon = [[JKImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, countIconD, countIconD)];
        [minusIcon setImage:[UIImage imageNamed:@"minusIcon"]];
        minusIcon.centerX = minusLb.fWidth / 2.f;
        minusIcon.centerY = minusLb.fHeight / 2.f;
        [minusLb addSubview:minusIcon];
        
        _countTextField = [[JKTextField alloc] initWithFrame:CGRectMake(minusLb.maxX, 0.f, countTextFieldW, countLbH)];
        _countTextField.centerY = minusLb.centerY;
        _countTextField.font = FONT_HEL(12.f);
        _countTextField.textAlignment = NSTextAlignmentCenter;
        _countTextField.textColor = RGBGRAY(100.f);
        _countTextField.text = @"0";
        _countTextField.delegate = self;
        _countTextField.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:_countTextField];
        _countTextField.layer.borderColor = layerColor;
        _countTextField.layer.borderWidth = 1.f;
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 30.f)];
        UIBarButtonItem *flexibleSpacingItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        UIBarButtonItem *resignItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(resignItem)];
        toolbar.items = @[flexibleSpacingItem,resignItem];
        _countTextField.inputAccessoryView = toolbar;
        
        JKLabel *plusLb = [[JKLabel alloc] initWithFrame:CGRectMake(_countTextField.maxX, 0.f, countLbW , countLbH)];
        plusLb.centerY = minusLb.centerY;
        plusLb.font = FONT_HEL(22.f);
        plusLb.textAlignment = NSTextAlignmentCenter;
        plusLb.textColor = THEMECOLOR;
//        plusLb.text = @"+";//原来是 用text，现改为minusIcon，但保留边框*************************
        [self addSubview:plusLb];
        plusLb.layer.borderColor = layerColor;
        plusLb.layer.borderWidth = 1.f;
        
        JKImageView *plusIcon = [[JKImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, countIconD, countIconD)];
        [plusIcon setImage:[UIImage imageNamed:@"plusIcon"]];
        plusIcon.centerX = minusLb.fWidth / 2.f;
        plusIcon.centerY = minusLb.fHeight / 2.f;
        [plusLb addSubview:plusIcon];
        
        //'+','-'按钮
        CGFloat countBtnW = countLbW + 10.f;
        CGFloat countBtnH = countLbH + 10.f;
        
        JKButton *minusBtn = [JKButton buttonWithType:UIButtonTypeCustom];
        [minusBtn setFrame:CGRectMake(minusLb.maxX - countBtnW, 0.f, countBtnW, countBtnH)];
        minusBtn.centerY = minusLb.centerY;
        [minusBtn addTarget:self action:@selector(minusBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:minusBtn];
        
        JKButton *plusBtn = [JKButton buttonWithType:UIButtonTypeCustom];
        [plusBtn setFrame:CGRectMake(plusLb.orgX, 0.f, countBtnW, countBtnH)];
        plusBtn.centerY = minusLb.centerY;
        [plusBtn addTarget:self action:@selector(plusBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        //可能有，可能没有的内容。混批则有
        _mixBuyBgView = [[JKView alloc] initWithFrame:CGRectMake(plusLb.maxX + 10.f, 0.f, SCREEN_WIDTH - plusLb.maxX - 15.f, cellContentH - spH)];
        [self addSubview:_mixBuyBgView];
        [self sendSubviewToBack:_mixBuyBgView];//不要遮挡plushBtn
        
        CGFloat infoIconD = 25.f;
        
        _infoIcon = [JKButton buttonWithType:UIButtonTypeCustom];
        [_infoIcon setFrame:CGRectMake(_mixBuyBgView.fWidth - infoIconD, 5.f, infoIconD, infoIconD)];
        [_infoIcon setImage:[UIImage imageNamed:@"about"] forState:UIControlStateNormal];
        [_infoIcon addTarget:self action:@selector(infoButton) forControlEvents:UIControlEventTouchUpInside];
        [_mixBuyBgView addSubview:_infoIcon];
        
        CGFloat mixBuyTipsLabelW = [JKAutoFitsWidthLabel widthForLabelText:@"起订量9999件，增订量999件" font:FONT_HEL(11.f)] + 10.f;
        CGFloat mixBuyTipsLabelX = _mixBuyBgView.fWidth - mixBuyTipsLabelW;
        if (mixBuyTipsLabelX < 0.f) {
            mixBuyTipsLabelX = 0.f;
        }
        
        JKAutoFitsWidthLabel *fixedLabel = [[JKAutoFitsWidthLabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, 21.f)];
        fixedLabel.centerY = _infoIcon.centerY;
        fixedLabel.font = FONT_HEL(11.f);
        fixedLabel.textColor = THEMECOLOR;
        fixedLabel.text = @"更多混批商品";
        [_mixBuyBgView addSubview:fixedLabel];
        fixedLabel.orgX = _infoIcon.orgX - fixedLabel.fWidth - 10.f;
        
        _mixBuyTipsLabel = [[JKLabel alloc] initWithFrame:CGRectMake(mixBuyTipsLabelX, fixedLabel.maxY, mixBuyTipsLabelW , 21.f)];
        _mixBuyTipsLabel.textAlignment = NSTextAlignmentRight;
        _mixBuyTipsLabel.font = FONT_HEL(11.f);
        _mixBuyTipsLabel.textColor = THEMECOLOR;
        [_mixBuyBgView addSubview:_mixBuyTipsLabel];
        
        CGFloat seeMoreMixGoodsButtonW = _infoIcon.orgX - mixBuyTipsLabelX - 10.f;
        JKButton *seeMoreMixGoodsButton = [JKButton buttonWithType:UIButtonTypeCustom];
        [seeMoreMixGoodsButton setFrame:CGRectMake(mixBuyTipsLabelX, 0.f, seeMoreMixGoodsButtonW, cellContentH - spH)];
        [_mixBuyBgView addSubview:seeMoreMixGoodsButton];
        [seeMoreMixGoodsButton addTarget:self action:@selector(seeMoreMixGoodsButton) forControlEvents:UIControlEventTouchUpInside];

        //分割线,8pixels
        JKView *sp = [[JKView alloc] initWithFrame:CGRectMake(0.f, cellContentH - spH, SCREEN_WIDTH, spH)];
        sp.backgroundColor = RGBGRAY(245.f);
        [self addSubview:sp];
        
        self.fHeight = sp.maxY;
    }
    return self;
}

#pragma mark - Touch events

- (void)minusBtn:(id)sender {
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(goodsCountCellContentOpration:)]) {
        [_delegate goodsCountCellContentOpration:1];
    }
}

- (void)plusBtn:(id)sender {
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(goodsCountCellContentOpration:)]) {
        [_delegate goodsCountCellContentOpration:2];
    }
}

//
- (void)infoButton {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(goodsCountCellContentShowInfo)]) {
        [_delegate goodsCountCellContentShowInfo];
    }
}

- (void)seeMoreMixGoodsButton {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(goodsCountCellContentSeeMoreMixGoods)]) {
        [_delegate goodsCountCellContentSeeMoreMixGoods];
    }
}

//完成编辑
- (void)resignItem {
    [_countTextField resignFirstResponder];
}

#pragma mark - setters

- (void)setCount:(NSInteger)count {
    
    _countTextField.text = [NSString stringWithFormat:@"%zd",count];
}

- (void)setIsMixBuy:(BOOL)isMinBuy mixBuyDesc:(NSString *)mixBuyDesc {
    
    if (isMinBuy) {
        _mixBuyBgView.hidden = NO;
        _mixBuyTipsLabel.text = mixBuyDesc;
    }else {
        _mixBuyBgView.hidden = YES;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(activeTextFieldBottomPoint:)]) {
        
        CGPoint origin = _countTextField.frame.origin;
        [_delegate activeTextFieldBottomPoint:origin];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (string.length != 0) {
        
        
        NSArray *numArray = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
        if ([numArray containsObject:string]) {
            
            NSString *text = textField.text;
            if (text ) {
                
            }
            
            return YES;
        }
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSString *text = textField.text;
    
    NSInteger count = 0;
    
    if (text == nil || text.length == 0) {
        count = -1;//无输入，不修改商品数量，维持原值
    }else if ([text hasPrefix:@"0"]){
        //以0开头
        count = 1;
    }else {
        count = [text integerValue];
    }
    
    if (count < 1 && count != -1) {
        count = 1;
    }
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(setGoodsCountByTextField:)]) {
        [_delegate setGoodsCountByTextField:count];
    }
}

@end
