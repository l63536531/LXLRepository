/**
 * SKOrderMenuBtn.m 16/11/7
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "SKOrderMenuBtn.h"

#import "JKViews.h"
#import "SKMACROs.h"

@interface SKOrderMenuBtn () {
    
    JKLabel *_batNumberLabel;
    
}

@end

@implementation SKOrderMenuBtn

- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)iconName {
    
    self = [super init];
    if (self != nil) {
        CGFloat btnW = SCREEN_WIDTH / 5.f;
        CGFloat btnH = btnW;
        
        [self setFrame:CGRectMake(0.f, 0.f, btnW, btnH)];
        
        
        JKImageView* customImageView = [[JKImageView alloc]initWithFrame:CGRectMake(btnW/3, btnW/4, btnW/3, btnW/3)];
        
        [customImageView setContentMode:UIViewContentModeScaleToFill];
        [customImageView setClipsToBounds:YES];
        [customImageView setBackgroundColor:[UIColor clearColor]];
        
        [customImageView setImage:[UIImage imageNamed:iconName]];
        [self addSubview:customImageView];
        
        JKLabel *customTitleLabel = [[JKLabel alloc] initWithFrame:CGRectMake(0.f, customImageView.maxY, btnW, 16.f)];
        [customTitleLabel setTextColor:ColorFromHex(0x646464)];
        [customTitleLabel setText:title];
        [customTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [customTitleLabel setNumberOfLines:1];
        [customTitleLabel setFont:FONT_HEL(11.f)];
        [self addSubview:customTitleLabel];
        
        CGFloat batNumerLabelW = 20.f;
        CGFloat batNumerLabelH = batNumerLabelW;
        
        _batNumberLabel = [[JKLabel alloc] initWithFrame:CGRectMake(customImageView.maxX - batNumerLabelW / 2.f, customImageView.orgY - batNumerLabelW / 2.f, batNumerLabelW, batNumerLabelH)];
        _batNumberLabel.backgroundColor = ColorFromHex(0xec584c);
        _batNumberLabel.font = FONT_HEL(10.f);
        _batNumberLabel.textColor = [UIColor whiteColor];
        _batNumberLabel.textAlignment = NSTextAlignmentCenter;
        _batNumberLabel.layer.borderColor = ColorFromHex(0xec584c).CGColor;
        _batNumberLabel.layer.cornerRadius = batNumerLabelH / 2.f;
        _batNumberLabel.layer.borderWidth = 1.f;
        
        _batNumberLabel.clipsToBounds = YES;
        _batNumberLabel.text = @"";
        [self addSubview:_batNumberLabel];
        _batNumberLabel.hidden = YES;
    }
    return self;
}

- (void)setBatNumber:(NSInteger)batNumber {
    
    _batNumber = batNumber;
    
    if (_batNumber <= 0) {
        _batNumberLabel.hidden =  YES;
    }else {
        _batNumberLabel.hidden = NO;
        if (_batNumber > 99) {
            _batNumberLabel.text = @"99+";
        }else {
            _batNumberLabel.text = [NSString stringWithFormat:@"%zd",batNumber];
        }

    }

    
    
}

@end
