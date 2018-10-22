/**
 * MABrandCell.m 16/11/12
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MABrandCell.h"

@interface MABrandCell () {
    
    UILabel *_brandNameLabel;               //商品title
}
@end

@implementation MABrandCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self != nil) {
        
        CGFloat labelW = frame.size.width;
        CGFloat labelH = frame.size.height;
        
        _brandNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, labelW, labelH)];
        _brandNameLabel.textAlignment = NSTextAlignmentCenter;
        _brandNameLabel.font = FONT_HEL(12.f);
        _brandNameLabel.textColor = RGBGRAY(100.f);
        [self addSubview:_brandNameLabel];

        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setBrandName:(NSString *)brandName {
    _brandNameLabel.text = brandName;
}

@end
