/**
 * MAShoppingCartCell.m 16/11/14
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MAShoppingCartCell.h"

#import "JKViews.h"
#import <UIImageView+WebCache.h>

@interface MAShoppingCartCell ()<UITextFieldDelegate> {
    
    JKButton *_checkBtn;                    //勾选按钮
    JKImageView *_customImageView;          //主图片
    
    JKLabel *_customTitleLabel;              //标题
    JKLabel *_specificationDescLabel;       //规格
    JKLabel *_priceLabel;                   //价格
    
    JKTextField *_countTextField;           //件数
}

@end

@implementation MAShoppingCartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        
        CGFloat separatorH = [MAShoppingCartCell cellSeparatorHeight];
        CGFloat cellContentH = [MAShoppingCartCell cellHeight] - separatorH;
        
        //勾选按钮
        CGFloat checkBtnW = 30.f;
        _checkBtn =  [JKButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setFrame:CGRectMake(5.f, 0.f, checkBtnW, checkBtnW)];
        _checkBtn.centerY = cellContentH / 2.f;
        [_checkBtn setImage:[UIImage imageNamed:@"uncheckedCircle"] forState:UIControlStateNormal];
        [_checkBtn setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateSelected];
        [_checkBtn addTarget:self action:@selector(checkBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_checkBtn];
        
        CGFloat imageViewH = 80.f;
        _customImageView = [[JKImageView alloc] initWithFrame:CGRectMake(_checkBtn.maxX + 4.f, 0.f, imageViewH, imageViewH)];
        _customImageView.centerY = cellContentH / 2.f;
        [self.contentView addSubview:_customImageView];
        
        CGFloat customTitleLabelX = _customImageView.maxX + 4.f;
        CGFloat customTitleLabelW = SCREEN_WIDTH - customTitleLabelX - 4.f;
        CGFloat customTitleLabelH = 50.f * 0.667f;//3行=50.f
        _customTitleLabel = [[JKLabel alloc] initWithFrame:CGRectMake(customTitleLabelX, _customImageView.orgY, customTitleLabelW , customTitleLabelH)];
        _customTitleLabel.font = FONT_HEL(12.f);
        _customTitleLabel.textColor = RGBGRAY(100.f);
        _customTitleLabel.numberOfLines = 2;
        [self.contentView addSubview:_customTitleLabel];
        
        _specificationDescLabel = [[JKLabel alloc] initWithFrame:CGRectMake(customTitleLabelX, _customTitleLabel.maxY, customTitleLabelW , 16.f)];
        _specificationDescLabel.font = FONT_HEL(12.f);
        _specificationDescLabel.textColor = RGBGRAY(100.f);
        [self.contentView addSubview:_specificationDescLabel];
        
        CGFloat countLbW = 30.f;       // '+','-'按钮的字
        CGFloat countLbH = countLbW;
        CGFloat countTextFieldW = 40.f;
        CGFloat countLbY = cellContentH - countLbH - 4.f;
        
        CGFloat minusLbX = SCREEN_WIDTH - 10.f - countLbW - countTextFieldW - countLbW;
        
        CGColorRef layerColor = RGBGRAY(240.f).CGColor;
        // '+','-'按钮的字（响应的区域和显示的 内容区域 不同，所以不能用一个button实现）
        JKLabel *minusLb = [[JKLabel alloc] initWithFrame:CGRectMake(minusLbX, countLbY, countLbW , countLbH)];
        minusLb.font = FONT_HEL(24.f);
        minusLb.textAlignment = NSTextAlignmentCenter;
        minusLb.textColor = THEMECOLOR;
//        minusLb.text = @"-";//原来是 用text，现改为minusIcon，但保留边框*************************
        [self.contentView addSubview:minusLb];
        minusLb.layer.borderColor = layerColor;
        minusLb.layer.borderWidth = 1.f;
        
        CGFloat countIconD = 7.f;
        //"-","+"号
        JKImageView *minusIcon = [[JKImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, countIconD, countIconD)];
        [minusIcon setImage:[UIImage imageNamed:@"minusIcon"]];
        minusIcon.centerX = minusLb.fWidth / 2.f;
        minusIcon.centerY = minusLb.fHeight / 2.f;
        [minusLb addSubview:minusIcon];
        
        _countTextField = [[JKTextField alloc] initWithFrame:CGRectMake(minusLb.maxX, countLbY, countTextFieldW, countLbH)];
        _countTextField.font = FONT_HEL(12.f);
        _countTextField.textAlignment = NSTextAlignmentCenter;
        _countTextField.textColor = RGBGRAY(100.f);
        _countTextField.text = @"0";
        _countTextField.delegate = self;
        _countTextField.keyboardType = UIKeyboardTypeNumberPad;
        [self.contentView addSubview:_countTextField];
        _countTextField.layer.borderColor = layerColor;
        _countTextField.layer.borderWidth = 1.f;
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 30.f)];
        UIBarButtonItem *flexibleSpacingItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        UIBarButtonItem *resignItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(resignItem)];
        toolbar.items = @[flexibleSpacingItem,resignItem];
        _countTextField.inputAccessoryView = toolbar;
        
        JKLabel *plusLb = [[JKLabel alloc] initWithFrame:CGRectMake(_countTextField.maxX, countLbY, countLbW , countLbH)];
        plusLb.font = FONT_HEL(22.f);
        plusLb.textAlignment = NSTextAlignmentCenter;
        plusLb.textColor = THEMECOLOR;
//        plusLb.text = @"+";//原来是 用text，现改为minusIcon，但保留边框*************************
        [self.contentView addSubview:plusLb];
        plusLb.layer.borderColor = layerColor;
        plusLb.layer.borderWidth = 1.f;
        //
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
        [self.contentView addSubview:minusBtn];
        
        JKButton *plusBtn = [JKButton buttonWithType:UIButtonTypeCustom];
        [plusBtn setFrame:CGRectMake(plusLb.orgX, 0.f, countBtnW, countBtnH)];
        plusBtn.centerY = minusLb.centerY;
        [plusBtn addTarget:self action:@selector(plusBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:plusBtn];
        
        _priceLabel = [[JKLabel alloc] initWithFrame:CGRectMake(customTitleLabelX, 0.f, customTitleLabelW , customTitleLabelH)];
        _priceLabel.centerY = minusBtn.centerY;
        _priceLabel.font = FONT_HEL(12.f);
        _priceLabel.textColor = THEMECOLOR;
        [self.contentView addSubview:_priceLabel];
        //分割线,8pixels
        JKView *sp = [[JKView alloc] initWithFrame:CGRectMake(0.f, cellContentH, SCREEN_WIDTH, separatorH)];
        sp.backgroundColor = RGBGRAY(245.f);
        [self.contentView addSubview:sp];
    }
    return self;
}

#pragma mark - Touch events

- (void)checkBtn:(JKButton *)btn {
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(shoppingCartCellOpration:atIndexPath:)]) {
        [_delegate shoppingCartCellOpration:1 atIndexPath:_indexPath];
    }
}

- (void)minusBtn:(id)sender {
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(shoppingCartCellOpration:atIndexPath:)]) {
        [_delegate shoppingCartCellOpration:2 atIndexPath:_indexPath];
    }
}

- (void)plusBtn:(id)sender {
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(shoppingCartCellOpration:atIndexPath:)]) {
        [_delegate shoppingCartCellOpration:3 atIndexPath:_indexPath];
    }
}

//完成编辑
- (void)resignItem {
    [_countTextField resignFirstResponder];
}

#pragma mark - setters

- (void)setIsChecked:(BOOL)isChecked {
    
    _checkBtn.selected = isChecked;
}

- (void)setCount:(NSInteger)count {
    
    _countTextField.text = [NSString stringWithFormat:@"%zd",count];
}

- (void)setPrice:(CGFloat)price {
    
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
}

- (void)setTitleStr:(NSString *)titleStr {
    _customTitleLabel.text = titleStr;
}

- (void)setGoodsSpecificationDesc:(NSString *)goodsSpecificationDesc {
    
    _specificationDescLabel.text = goodsSpecificationDesc;
}

- (void)setImageUrlStr:(NSString *)imageUrlStr {
    
    if (imageUrlStr != nil) {
        NSURL *url = [NSURL URLWithString:imageUrlStr];
        [_customImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"commonPlaceHolderIcon"]];
    }else {
        [_customImageView setImage:[UIImage imageNamed:@"commonPlaceHolderIcon"]];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(activeTextFieldBottomPoint:forCell:)]) {
        
        CGPoint origin = _countTextField.frame.origin;
        [_delegate activeTextFieldBottomPoint:origin forCell:self];
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
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(setGoodsCountByTextField:atIndexPath:)]) {
        [_delegate setGoodsCountByTextField:count atIndexPath:_indexPath];
    }
}

#pragma mark - 

+ (CGFloat)cellHeight {
    
    return 90.f + [self cellSeparatorHeight];//
}

+ (CGFloat)cellSeparatorHeight {
    return 1.f;
}

@end
