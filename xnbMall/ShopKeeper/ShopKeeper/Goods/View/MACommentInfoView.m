/**
 * MACommentInfoView.m 16/11/19
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MACommentInfoView.h"

#import "CWStarRateView.h"
#import "JKViews.h"

@interface MACommentInfoView () {
    
    JKLabel *_commentCountLabel;        //评价总数
    
    JKView *_sumLabelContentView;       //各类评价数量
    
    JKView *_fakeCommentCell;           //cell
    
    JKButton *_seeMoreCommentsBtn;
    
    JKView *_separator;
    //
    JKLabel *_phoneLabel;
    
    JKAutoFitsHeightWithLineSpacingLabel *_commentLabel;
    
    JKLabel *_specLabel;
    
    CWStarRateView *_rateView;
}

@end

@implementation MACommentInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 0.f)];
    
    if (self != nil) {
        
        CGFloat cellW = SCREEN_WIDTH;
        CGFloat leading = 10.f;
        CGFloat trailing = 8.f;
        CGFloat contentW = cellW - leading - trailing;
        
        _commentCountLabel = [[JKLabel alloc] initWithFrame:CGRectMake(leading, 4.f, contentW, 21.f)];
        _commentCountLabel.font = FONT_HEL(15.f);
        _commentCountLabel.textColor = RGBGRAY(100.f);
        _commentCountLabel.text = @"商品评价（*）";
        [self addSubview:_commentCountLabel];
        
        _sumLabelContentView = [[JKView alloc] initWithFrame:CGRectMake(leading, _commentCountLabel.maxY, contentW, 0.f)];
        [self addSubview:_sumLabelContentView];
        
        [self initFakeCellWithWidth:contentW];
        [self addSubview:_fakeCommentCell];
        
        CGFloat btnW = 120.f;
        CGFloat btnH = 30.f;
        _seeMoreCommentsBtn = [JKButton buttonWithType:UIButtonTypeCustom];
        [_seeMoreCommentsBtn setFrame:CGRectMake(0.f, _fakeCommentCell.maxY, btnW, btnH)];
        _seeMoreCommentsBtn.centerX = cellW / 2.f;
        _seeMoreCommentsBtn.backgroundColor = [UIColor whiteColor];
        [_seeMoreCommentsBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
        [_seeMoreCommentsBtn setTitle:@"查看更多评论" forState:UIControlStateNormal];
        _seeMoreCommentsBtn.titleLabel.font = FONT_HEL(14.f);
        _seeMoreCommentsBtn.layer.cornerRadius = 5.f;
        _seeMoreCommentsBtn.layer.borderColor = THEMECOLOR.CGColor;
        _seeMoreCommentsBtn.layer.borderWidth = 1.f;
        _seeMoreCommentsBtn.clipsToBounds = YES;
        [_seeMoreCommentsBtn addTarget:self action:@selector(seeMoreCommentsBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_seeMoreCommentsBtn];
        
        _separator = [[JKView alloc] initWithFrame:CGRectMake(0.f, _seeMoreCommentsBtn.maxY + 8.f, SCREEN_WIDTH, 10.f)];
        _separator.backgroundColor = RGBGRAY(240.f);
        [self addSubview:_separator];
        
        self.fHeight = _separator.maxY;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -

- (void)initFakeCellWithWidth:(CGFloat)contentW {
    
    CGFloat leading = 10.f;
    _fakeCommentCell = [[JKView alloc] initWithFrame:CGRectMake(leading, _sumLabelContentView.maxY, contentW, 0.f)];
    
    CGFloat iconD = 21.f;
    JKImageView *icon = [[JKImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, iconD, iconD)];
    [icon setImage:[UIImage imageNamed:@"male79"]];
    [_fakeCommentCell addSubview:icon];
    
    CGFloat labelH = 21.f;
    _phoneLabel = [[JKLabel alloc] initWithFrame:CGRectMake(icon.maxX + 5.f, 0.f, 100.f, labelH)];
    _phoneLabel.font = FONT_HEL(12.f);
    _phoneLabel.textColor = RGBGRAY(120.f);
    [_fakeCommentCell addSubview:_phoneLabel];
    //
    CGFloat startW = 100.f;
    CGFloat startX = contentW - startW;
    CGFloat starY = _phoneLabel.orgY + (labelH - 18.f) / 2.f;
    CWStarRateView *rate = [[CWStarRateView alloc] initWithFrame:CGRectMake(startX, starY, 100, 18)];
    rate.allowChange = NO;
    [_fakeCommentCell addSubview:rate];
    _rateView = rate;
    
    
    _commentLabel = [[JKAutoFitsHeightWithLineSpacingLabel alloc] initWithFrame:CGRectMake(0.f, icon.maxY + 5.f, contentW, 21.f) lineSpacing:3.f];
    _commentLabel.font = FONT_HEL(14.f);
    _commentLabel.textColor = RGBGRAY(100.f);
    [_fakeCommentCell addSubview:_commentLabel];
    
    _specLabel = [[JKLabel alloc] initWithFrame:CGRectMake(0.f, _commentLabel.maxY, 200.f, labelH)];
    _specLabel.font = FONT_HEL(12.f);
    _specLabel.textColor = RGBGRAY(200.f);
    [_fakeCommentCell addSubview:_specLabel];
}

- (void)seeMoreCommentsBtn:(id)sender {
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(seeMoreComments)]) {
        [_delegate seeMoreComments];
    }
}

#pragma mark - setters

- (void)setCommentSumDic:(NSDictionary *)commentSumDic {
    
    _commentSumDic = commentSumDic;
    
    if (commentSumDic != nil) {
        _commentCountLabel.text = [NSString stringWithFormat:@"商品评价（%zd）",[commentSumDic[@"allNum"] integerValue]];
        
        NSMutableDictionary *mSumDic = [[NSMutableDictionary alloc] initWithDictionary:commentSumDic];
        [mSumDic removeObjectForKey:@"goodsId"];
        [mSumDic removeObjectForKey:@"allNum"];
        
        if (mSumDic != nil && mSumDic.count > 0) {
            
            CGFloat labelX = 0.f;
            CGFloat labelY = 4.f;
            CGFloat labelH = 24.f;
            
            NSArray *keysArray = [mSumDic allKeys];
            UIFont *labelFont = FONT_HEL(12.f);
            
            for (NSInteger i = 0; i < keysArray.count; i++) {
                
                NSString *key = keysArray[i];
                
                BOOL isGoodComment = NO;        //是否好评
                NSString *desc = [self niceCommentDescWithKey:key];
                if (desc != nil) {
                    isGoodComment = YES;
                }else {
                    desc = [self badCommentDescWithKey:key];
                }
                
                NSInteger count = [mSumDic[key] integerValue];
                NSString *text = [NSString stringWithFormat:@"%@(%zd)", desc, count];
                
                CGFloat labelW = [JKAutoFitsWidthLabel widthForLabelText:text font:labelFont] + 10.f;
                
                if (labelX + labelW > _sumLabelContentView.fWidth) {
                    labelX = 0.f;//这一行放不下这个btn了，移到下一行（不考虑一行放不下一个btn的不合理情况）
                    labelY = labelY + labelH + 4.f;
                }
                
                //eg label.text = @"质量不错(29)";
                JKLabel *label = [[JKLabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
                label.backgroundColor = RGBGRAY(240.f);
                label.textAlignment = NSTextAlignmentCenter;
                label.font = labelFont;
                label.text = text;
                [_sumLabelContentView addSubview:label];
                label.layer.cornerRadius = 4.f;
                label.layer.borderWidth = 1.f;
                label.layer.borderColor = [UIColor clearColor].CGColor;
                label.clipsToBounds = YES;
                
                if (isGoodComment) {
                    //好评 红色
                    label.textColor = THEMECOLOR;
                }else {
                    //差评灰色
                    label.textColor = RGBGRAY(100.f);
                }
                
                
                labelX = label.maxX + 4.f;
            }
            
            _sumLabelContentView.fHeight = labelY + labelH + 4.f;
            //
            _fakeCommentCell.orgY = _sumLabelContentView.maxY;
            
            _seeMoreCommentsBtn.orgY = _fakeCommentCell.maxY;
            
            _separator.orgY = _seeMoreCommentsBtn.maxY + 8.f;
            
            self.fHeight = _separator.maxY;
        }
    }
}


- (void)setCommentDic:(NSDictionary *)commentDic {
    
    _commentDic = commentDic;
    NSString *commentStr = commentDic[@"content"];
    
    _phoneLabel.text = commentDic[@"createUserPhone"];
    [_commentLabel setText:commentStr maxLines:3];
    _specLabel.text = commentDic[@"goodsSpecName"];
    
    _rateView.scorePercent = [commentDic[@"starnum"] integerValue]/5.f;
    
    _specLabel.orgY = _commentLabel.maxY;
    _fakeCommentCell.fHeight = _specLabel.maxY + 5.f;
    
    _seeMoreCommentsBtn.orgY = _fakeCommentCell.maxY;
    
    _separator.orgY = _seeMoreCommentsBtn.maxY + 8.f;
    
    self.fHeight = _separator.maxY;
}

#pragma mark -

/**
 *  @author 黎国基, 16-11-19 17:11
 *
 *  好评 条目
 *
 *  @param key key
 *
 *  @return key转换成对应中文描述
 */
- (NSString *)niceCommentDescWithKey:(NSString *)key {
    
    NSArray *niceKeysArray = @[@"qualityGood",@"priceGood",@"logisticeGood",@"serviceGood",@"packGood"];
    NSArray *niceDescArray = @[@"质量不错",@"价格优惠",@"物流快",@"服务态度不错",@"包装好"];
    
    NSInteger index = -1;
    
    for (NSInteger i = 0; i < niceKeysArray.count; i++) {
        if ([key isEqualToString:niceKeysArray[i]]) {
            index = i;
            break;
        }
    }
    
    if (index != -1) {
        return niceDescArray[index];
    }
    
    return nil;
}

/**
 *  @author 黎国基, 16-11-19 17:11
 *
 *  差评 条目
 *
 *  @param key key
 *
 *  @return key转换成对应中文描述
 */
- (NSString *)badCommentDescWithKey:(NSString *)key {
    
    NSArray *badKeysArray = @[@"qualityBad",@"priceBad",@"logisticeBad",@"serviceBad",@"packBad"];
    NSArray *badDescArray = @[@"质量不好",@"价格不合理",@"物流太慢",@"服务态度不好",@"包装破损"];
    
    NSInteger index = -1;
    
    for (NSInteger i = 0; i < badKeysArray.count; i++) {
        if ([key isEqualToString:badKeysArray[i]]) {
            index = i;
            break;
        }
    }
    
    if (index != -1) {
        return badDescArray[index];
    }
    
    return nil;
}


@end
