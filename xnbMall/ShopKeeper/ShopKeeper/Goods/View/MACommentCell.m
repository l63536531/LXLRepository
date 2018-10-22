/**
 * MACommentCell.m 16/11/24
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MACommentCell.h"

#import "JKViews.h"
#import "CWStarRateView.h"
#import "JKTool.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MACommentCell () {
    
    JKImageView *_icon;             //头像
    JKLabel *_phoneLabel;
    CWStarRateView *_starBoard;     //星级
    JKAutoFitsHeightWithLineSpacingLabel *_commentLabel;         //评价内容
    JKLabel *_specLabel;            //规格，忘了，还有时间，也放这里吧
    
    NSMutableArray *_mImageViewArray;
}

@end

@implementation MACommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        
        _mImageViewArray = [[NSMutableArray alloc] init];
        
        CGFloat leading = 8.f;
        
        CGFloat iconD = 21.f;
        _icon = [[JKImageView alloc] initWithFrame:CGRectMake(leading, 5.f, iconD, iconD)];
        [_icon setImage:[UIImage imageNamed:@"male79"]];
        [self.contentView addSubview:_icon];
        
        _phoneLabel = [[JKLabel alloc] initWithFrame:CGRectMake(_icon.maxX + 5.f, 0.f, 100.f, 21.f)];
        _phoneLabel.centerY = _icon.centerY;
        _phoneLabel.font = FONT_HEL(12.f);
        _phoneLabel.textColor = RGBGRAY(100.f);
        [self.contentView addSubview:_phoneLabel];
        
        CGFloat startX = _phoneLabel.maxX + 5.f;
        CGFloat starY = _icon.orgY + 1.5f;
        _starBoard = [[CWStarRateView alloc] initWithFrame:CGRectMake(startX, starY, 100, 18)];
        _starBoard.allowChange = NO;
        [self.contentView addSubview:_starBoard];
        
        CGFloat commentY = [MACommentCell commentLabelY];
        CGFloat commentW = SCREEN_WIDTH - leading * 2.f;
        _commentLabel = [[JKAutoFitsHeightWithLineSpacingLabel alloc] initWithFrame:CGRectMake(leading, commentY, commentW, 0.f) lineSpacing:3.f];
        _commentLabel.font = [MACommentCell commentFont];
        _commentLabel.textColor = RGBGRAY(100.f);
        [self.contentView addSubview:_commentLabel];
        
        CGFloat imageViewW = 60.f;
        CGFloat imageViewH = [MACommentCell imageViewH];
        CGFloat imageViewX = leading;
        CGFloat imageViewY = _commentLabel.maxY + 5.f;
        CGFloat imageViewSpacing = 8.f;
        
        for (int i = 0; i < 3; i++) {
            
            imageViewX = leading + (imageViewW + imageViewSpacing) * i;
            
            JKImageView *imageView = [[JKImageView alloc] initWithFrame:CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)];
            imageView.hidden = YES;
            imageView.tag = i;
            [self.contentView addSubview:imageView];
            
            [_mImageViewArray addObject:imageView];
        }
        
        _specLabel = [[JKLabel alloc] initWithFrame:CGRectMake(leading, imageViewY + imageViewH + 5.f, commentW, 21.f)];
        _specLabel.font = FONT_HEL(12.f);
        _specLabel.textColor = RGBGRAY(200.f);
        [self.contentView addSubview:_specLabel];
        
    }
    return self;
}

- (void)setCommentDic:(NSDictionary *)commentDic {
    
    _phoneLabel.text = commentDic[@"createUserPhone"];
    _starBoard.scorePercent = [commentDic[@"starnum"] integerValue]/5.f;
    _commentLabel.text = commentDic[@"content"];
    
    NSString *imagesUrls = commentDic[@"imagesUrl"];
    NSArray *imageUrlArray = [JKTool getArrayFromComponentStr:imagesUrls];
    
    CGFloat imageViewY = 0.f;
    imageViewY = _commentLabel.maxY + [MACommentCell imageViewTop];
    
    for (JKImageView *imageView in _mImageViewArray) {
        imageView.hidden = YES;
        imageView.orgY = imageViewY;
    }
    
    CGFloat imageViewH = [MACommentCell imageViewH];
    
    BOOL hasImage = NO;
    if (imageUrlArray != nil && imageUrlArray.count > 0) {
        hasImage = YES;
        for (int i = 0; i < 3; i++) {
            if (i < imageUrlArray.count) {
                
                JKImageView *imageView = _mImageViewArray[i];
                imageView.hidden = NO;
                
                NSString *urlStr = imageUrlArray[i];
                NSURL *imgUrl = [NSURL URLWithString:urlStr];
                [imageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"commonPlaceHolderIcon"]];
            }
        }
    }
    
    if (hasImage) {
        _specLabel.orgY = imageViewY + imageViewH + 5.f;
    }else {
        _specLabel.orgY = _commentLabel.maxY + 5.f;
    }
    
    NSString *dateStr = commentDic[@"createTime"];
    NSString *trucatedDateStr = dateStr;
    if (trucatedDateStr.length > 10) {
        trucatedDateStr = [dateStr substringToIndex:10];
    }
    
    NSString *spedStr = [JKTool NoNilStringForString:commentDic[@"goodsSpecName"]];
    _specLabel.text = [NSString stringWithFormat:@"%@   %@",trucatedDateStr,spedStr];
}

+ (CGFloat)cellHeightForCommentDic:(NSDictionary *)commentDic {
    
    CGFloat commentLabelY = [self commentLabelY];
    
    NSString *contentStr = commentDic[@"content"];
    
    CGFloat leading = 8.f;
    CGFloat commentW = SCREEN_WIDTH - leading * 2.f;
    CGFloat contentH = [JKAutoFitsHeightWithLineSpacingLabel heightForLabelText:contentStr width:commentW lineSpacing:3.f font:[MACommentCell commentFont]];
    
    NSString *imagesUrls = commentDic[@"imagesUrl"];
    NSArray *imageUrlArray = [JKTool getArrayFromComponentStr:imagesUrls];
    
    CGFloat cellH = commentLabelY + contentH;
    CGFloat imageViewH = [MACommentCell imageViewH];
    
    if (imageUrlArray != nil && imageUrlArray.count > 0) {
        cellH = cellH + [MACommentCell imageViewTop] + imageViewH + 5.f;
    }else {
        cellH = cellH + 5.f;
    }
    
    cellH = cellH + 26.f;//_specLabel + 5
    
    return cellH;
}

+ (UIFont *)commentFont {
    return FONT_HEL(12.f);
}

+ (CGFloat)commentLabelY {
    
    return 30.f;
}

+ (CGFloat)imageViewH {
    
    return 60.f;
}

+ (CGFloat)imageViewTop {
    
    return 5.f;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
