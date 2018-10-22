/**
 * MALogisticsView.m 16/11/18
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MALogisticsView.h"

#import "JKViews.h"

@interface MALogisticsView () {
    
    JKLabel *_addressLabel;
    JKLabel *_companyLabel;
    JKLabel *_dateLabel;
}

@end

@implementation MALogisticsView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 0.f)];
    if (self != nil) {
        
        CGFloat cellW = SCREEN_WIDTH;
        CGFloat leading = 8.f;
        CGFloat lbaelW = cellW - leading * 2.f;
        
        CGFloat labelH = 21.f;
        
        JKAutoFitsWidthLabel *preAddressLabel = [[JKAutoFitsWidthLabel alloc] initWithFrame:CGRectMake(leading, 8.f, 0.f, labelH)];
        preAddressLabel.font = FONT_HEL(14.f);
        preAddressLabel.textColor = RGBGRAY(100.f);
        preAddressLabel.text = @"发货地址：";
        [self addSubview:preAddressLabel];
        
        _addressLabel = [[JKLabel alloc] initWithFrame:CGRectMake(preAddressLabel.maxX, preAddressLabel.orgY, lbaelW - preAddressLabel.fWidth, labelH)];
        _addressLabel.font = FONT_HEL(14.f);
        _addressLabel.textColor = RGBGRAY(100.f);
        [self addSubview:_addressLabel];
        
        _companyLabel = [[JKLabel alloc] initWithFrame:CGRectMake(leading, preAddressLabel.maxY + 4.f, lbaelW, labelH)];
        _companyLabel.font = FONT_HEL(11.f);
        _companyLabel.textColor = RGBGRAY(100.f);
        [self addSubview:_companyLabel];
        
        JKAutoFitsWidthLabel *preDateLabel = [[JKAutoFitsWidthLabel alloc] initWithFrame:CGRectMake(leading, _companyLabel.maxY + 4.f, 0.f, labelH)];
        preDateLabel.font = FONT_HEL(14.f);
        preDateLabel.textColor = RGBGRAY(100.f);
        preDateLabel.text = @"预计发货时间：";
        [self addSubview:preDateLabel];
        
        _dateLabel = [[JKLabel alloc] initWithFrame:CGRectMake(preDateLabel.maxX, preDateLabel.orgY, lbaelW - preDateLabel.fWidth, labelH)];
        _dateLabel.font = FONT_HEL(14.f);
        _dateLabel.textColor = THEMECOLOR;
        [self addSubview:_dateLabel];
        _dateLabel.text = @"";
        
        JKView *separator = [[JKView alloc] initWithFrame:CGRectMake(0.f, preDateLabel.maxY + 8.f, SCREEN_WIDTH, 10.f)];
        separator.backgroundColor = RGBGRAY(240.f);
        [self addSubview:separator];
        
        self.fHeight = separator.maxY;
    }
    return self;
}

#pragma mark - setters

- (void)setAddress:(NSString *)address {
    _addressLabel.text = address;
}

- (void)setCompany:(NSString *)company {
    
    NSString *companyStr = company;
    if (companyStr == nil) {
        companyStr = @"  ";
    }
    
    NSString *preStr = @"本商品由 ";
    NSString *suffixStr = @" 销售并提供服务。";
    NSString *combinedStr = [NSString stringWithFormat:@"%@%@%@",preStr,company,suffixStr];
    
    UIColor *grayColor = RGBGRAY(200.f);
    
    
    NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc] initWithString:combinedStr];
    [mAttr setAttributes:@{NSForegroundColorAttributeName:grayColor} range:NSMakeRange(0, preStr.length)];
    [mAttr setAttributes:@{NSForegroundColorAttributeName:THEMECOLOR} range:NSMakeRange(preStr.length, company.length)];
    [mAttr setAttributes:@{NSForegroundColorAttributeName:grayColor} range:NSMakeRange(preStr.length + company.length, suffixStr.length)];
    
    _companyLabel.attributedText = mAttr;
}

- (void)setDateStr:(NSString *)dateStr {
    _dateLabel.text = dateStr;
}


@end