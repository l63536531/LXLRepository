/**
 * MAGoodsCommentCell.m 16/11/26
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MAGoodsCommentCell.h"

#import "JKViews.h"
#import "JKTool.h"
#import "CWStarRateView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>

@interface MAGoodsCommentCell ()<CWStarRateViewDelegate, UITextViewDelegate> {
    
    JKView *_goodsInfoSection;                  //
    JKImageView *_imageView;                    //商品图片
    JKLabel *_titleLabel;
    CWStarRateView *_starBoard;
    //是否展示 评价 标签、图片、留言
    JKView *_popView;                           //方便是否隐藏||显示以下内容
    
    
    JKView *_satisfactionSection;               //满意度，评价
    JKLabel *_askLabel;
    JKView *_satisfactionBoard;                 //标签
    UITextView *_messageTextView;                                       //留言。待评价的留言
    JKAutoFitsHeightWithLineSpacingLabel *_messageLabel;                    //留言。已经评价了的留言
    
    JKView *_imageSection;                      //图片
    
    JKView *_bottomSeparator;
    //
    NSArray *_niceKeysArray;                    //好评
    NSArray *_niceDescArray;
    
    NSArray *_badKeysArray;                     //差评
    NSArray *_badDescArray;
    
    NSDictionary *_commentInfoDic;
    NSDictionary *_userLocalDataDic;
}

@end


@implementation MAGoodsCommentCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        /*注mark值表：
        {1，质量不错；2，价格优惠；3，物流快；4，服务态度不错；5，包装好；
          6，质量不好；7，价格不合理；8，物流太慢；9，服务态度不好；10，包装破损}*/
        _niceKeysArray = @[@"qualityGood",@"priceGood",@"logisticeGood",@"serviceGood",@"packGood"];
        _niceDescArray = @[@"质量不错",@"价格优惠",@"物流快",@"服务态度不错",@"包装好"];
        
        _badKeysArray = @[@"qualityBad",@"priceBad",@"logisticeBad",@"serviceBad",@"packBad"];
        _badDescArray = @[@"质量不好",@"价格不合理",@"物流太慢",@"服务态度不好",@"包装破损"];
        
        
        CGFloat leading = [MAGoodsCommentCell leading];
        CGFloat contentW = SCREEN_WIDTH - leading * 2.f;
        
        //_goodsInfoSection
        CGFloat goodsImageW = 60.f;
        CGFloat goodsImageH = 60.f;
        
        CGFloat goodsInfoSectionHeight = [MAGoodsCommentCell goodsInfoSectionHeight];
        _goodsInfoSection = [[JKView alloc] initWithFrame:CGRectMake(leading, 0.f, contentW, goodsInfoSectionHeight)];
        [self.contentView addSubview:_goodsInfoSection];
        
        _imageView = [[JKImageView alloc] initWithFrame:CGRectMake(0.f, leading, goodsImageW, goodsImageH)];
        [_imageView setImage:[UIImage imageNamed:@"commonPlaceHolderIcon"]];
        [_goodsInfoSection addSubview:_imageView];
        
        _titleLabel = [[JKLabel alloc] initWithFrame:CGRectMake(_imageView.maxX + 5.f, _goodsInfoSection.orgY, contentW - _imageView.maxX - 10.f, goodsImageH)];
        _titleLabel.font = FONT_HEL(13.f);
        _titleLabel.textColor = RGBGRAY(100.f);
        _titleLabel.numberOfLines = 0;
        [_goodsInfoSection addSubview:_titleLabel];
        
        CGFloat starBoardW = 120.f;
        CGFloat starBoardH = 30.f;
        CGFloat starBoardX = (contentW - starBoardW) / 2.f;
        
        _starBoard = [[CWStarRateView alloc] initWithFrame:CGRectMake(starBoardX, _titleLabel.maxY + 5.f, starBoardW, starBoardH)];
        _starBoard.allowChange = YES;
        _starBoard.delegate = self;
        [_goodsInfoSection addSubview:_starBoard];
        _starBoard.scorePercent = 0;
//_popView
        _popView = [[JKView alloc] initWithFrame:CGRectMake(0.f, _goodsInfoSection.maxY, SCREEN_WIDTH, 240.f)];
        _popView.clipsToBounds = YES;
        [self.contentView addSubview:_popView];
        _popView.hidden = YES;
        
        //_satisfactionSection
        _satisfactionSection = [[JKView alloc] initWithFrame:CGRectMake(leading, 0.f, contentW, 135.f)];
        
        _askLabel = [[JKLabel alloc] initWithFrame:CGRectMake(0.f, 0.f, contentW, 21.f)];
        _askLabel.textAlignment = NSTextAlignmentCenter;
        _askLabel.font = FONT_HEL(13.f);
        _askLabel.textColor = RGBGRAY(100.f);
        _askLabel.text = @"您满意的地方？";
        [_satisfactionSection addSubview:_askLabel];//
        [self createSatisfactionBtns];
        self.isSatisfied = NO;
        self.isSatisfied = YES;
        
        CGFloat messgeW = contentW - leading * 2.f;
        CGFloat messageViewY = [MAGoodsCommentCell messageViewY];
        
        CGFloat messageTextViewHeight = [MAGoodsCommentCell messageTextViewHeight];
        _messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(leading, messageViewY, messgeW, messageTextViewHeight)];
        _messageTextView.delegate = self;
        _messageTextView.layer.borderWidth = 1.f;
        _messageTextView.layer.borderColor = RGBGRAY(240.f).CGColor;
        _messageTextView.font = FONT_HEL(12.f);
        [_satisfactionSection addSubview:_messageTextView];
        
        UIFont *messageLabelFont = [MAGoodsCommentCell messageLabelFont];
        _messageLabel = [[JKAutoFitsHeightWithLineSpacingLabel alloc] initWithFrame:CGRectMake(leading, messageViewY, messgeW, 0.f) lineSpacing:3.f];
        _messageLabel.font = messageLabelFont;
        _messageLabel.textColor = RGBGRAY(100.f);
        [_satisfactionSection addSubview:_messageLabel];
        _messageLabel.hidden = YES;
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 30.f)];
        UIBarButtonItem *spacingItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneItem)];
        toolBar.items = @[spacingItem,doneItem];
        _messageTextView.inputAccessoryView = toolBar;
        
        [_popView addSubview:_satisfactionSection];
        //
        CGFloat imageSectionHeight = [MAGoodsCommentCell imageSectionHeight];
        _imageSection = [[JKView alloc] initWithFrame:CGRectMake(leading, _satisfactionSection.maxY, contentW, imageSectionHeight)];
        [self createImageBtns];
        [_popView addSubview:_imageSection];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        JKView *bottomSeparator = [[JKView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 1.f)];
        bottomSeparator.backgroundColor = RGBGRAY(240.f);
        [self.contentView addSubview:bottomSeparator];
        _bottomSeparator = bottomSeparator;
    }
    return self;
}

/**
 *  @author 黎国基, 16-11-26 13:11
 *
 *  用户评价的标签btn
 */
- (void)createSatisfactionBtns {
    
    CGFloat sBtnX = 0.f;
    CGFloat sBtnY = _askLabel.maxY + 5.f;
    CGFloat sBtnW = 80.f;
    CGFloat sBtnH = 28.f;
    CGFloat sBtnSpacing = 4.f;
    
    UIImage *normalImage = [JKTool imageWithColor:RGBGRAY(245.f)];
    UIImage *selectedImage = [JKTool imageWithColor:THEMECOLOR];
    
    for (int i = 0; i < 5; i++) {
        
        if (i == 3) {
            sBtnX = 0;
            sBtnY = sBtnY + sBtnH + sBtnSpacing;
        }
        
        JKButton *sBtn = [JKButton buttonWithType:UIButtonTypeCustom];
        [sBtn setFrame:CGRectMake(sBtnX, sBtnY, sBtnW, sBtnH)];
        [sBtn setBackgroundImage:normalImage forState:UIControlStateNormal];
        [sBtn setBackgroundImage:selectedImage forState:UIControlStateSelected];
        
        [sBtn setTitleColor:RGBGRAY(100.f) forState:UIControlStateNormal];
        [sBtn setTitleColor:RGBGRAY(255.f) forState:UIControlStateSelected];
        sBtn.titleLabel.font = FONT_HEL(12.f);
        
        sBtn.layer.cornerRadius = 4.f;
        sBtn.clipsToBounds = YES;
        sBtn.tag = 100 + i;
        [sBtn addTarget:self action:@selector(satisfactionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_satisfactionSection addSubview:sBtn];
        
        sBtnX = sBtnX + (sBtnW + sBtnSpacing);
    }
}

/**
 *  @author 黎国基, 16-11-26 13:11
 *
 *  用户上传的图片
 */
- (void)createImageBtns {
    
    CGFloat imageBtnX = 0.f;
    CGFloat imageBtnY = 5.f;
    CGFloat imageBtnW = 50.f;
    CGFloat imageBtnH = imageBtnW;
    CGFloat imageBtnSpacing = 4.f;
    
    for (int i = 0; i < 3; i++) {
        JKButton *imageBtn = [JKButton buttonWithType:UIButtonTypeCustom];
        [imageBtn setFrame:CGRectMake(imageBtnX, imageBtnY, imageBtnW, imageBtnH)];
        imageBtn.tag = 100 + i;

        [imageBtn setBackgroundImage:[UIImage imageNamed:@"shangchuan"] forState:UIControlStateNormal];
        [imageBtn addTarget:self action:@selector(imageBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_imageSection addSubview:imageBtn];
        
        imageBtnX = imageBtnX + (imageBtnW + imageBtnSpacing);
    }
}

#pragma mark -

#pragma mark - Touch events

- (void)satisfactionBtn:(JKButton *)btn {
    
    if ([MAGoodsCommentCell isAlreadyCommented:_commentInfoDic]) {
        //已评价
        
    }else {
        //未评价
        btn.selected = !btn.selected;
        
        NSInteger op = 0;//删除
        if (btn.selected) {
            //添加
            op = 1;
        }
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(starViewDidSetMark:opration:atRow:)]) {
            [_delegate starViewDidSetMark:btn.tag - 100 opration:op atRow:_row];
        }
    }
}

/**
 *  @author 黎国基, 16-11-26 21:11
 *
 *  图片
 *
 *  @param btn tag:[100-102]
 */
- (void)imageBtn:(JKButton *)btn {
    
    
    if ([MAGoodsCommentCell isAlreadyCommented:_commentInfoDic]) {
        //已评价
    }else {
        //未评价
        NSDictionary *imagesDic = _userLocalDataDic[@"userImages"];
        NSArray *imageIds = [imagesDic allKeys];
        NSInteger clickIndex = btn.tag - 100;
        
        if (clickIndex < imageIds.count) {
            //图片 删除图片
            if (_delegate != nil && [_delegate respondsToSelector:@selector(removeImageByImageId:atRow:)]) {
                
                [_delegate removeImageByImageId:imageIds[clickIndex] atRow:_row];
            }
        }else if (clickIndex == imageIds.count) {
            //@"+"
            if (_delegate != nil && [_delegate respondsToSelector:@selector(addImageAtRow:)]) {
                
                [_delegate addImageAtRow:_row];
            }
        }else {
            //隐藏的，不可能点击的
        }
    }
}

- (void)doneItem {
    
    [_messageTextView resignFirstResponder];
}

#pragma mark - Custom tasks

- (void)setIsSatisfied:(BOOL)isSatisfied {
    
    if (_isSatisfied == isSatisfied) {
        return;
    }
    
    _isSatisfied = isSatisfied;
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(starViewRemoveMarkIndexsAtRow:)]) {
        
        [_delegate starViewRemoveMarkIndexsAtRow:_row];
    }
    
    NSArray *apropriateArray = nil;
    if (isSatisfied) {
        _askLabel.text = @"您满意的地方？";
        apropriateArray = _niceDescArray;
    }else {
        _askLabel.text = @"您想吐槽的地方？";
        apropriateArray = _badDescArray;
    }
    
    for (int i = 0; i < 5; i++) {
        JKButton *sBtn = (JKButton *)[_satisfactionSection viewWithTag:100 + i];
        [sBtn setTitle:apropriateArray[i] forState:UIControlStateNormal];
        
        sBtn.selected = NO;
    }
}

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
    
    NSInteger index = -1;
    
    for (NSInteger i = 0; i < _niceKeysArray.count; i++) {
        if ([key isEqualToString:_niceKeysArray[i]]) {
            index = i;
            break;
        }
    }
    
    if (index != -1) {
        return _niceDescArray[index];
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
    
    NSInteger index = -1;
    
    for (NSInteger i = 0; i < _badKeysArray.count; i++) {
        if ([key isEqualToString:_badKeysArray[i]]) {
            index = i;
            break;
        }
    }
    
    if (index != -1) {
        return _badDescArray[index];
    }
    
    return nil;
}

//评价信息
- (void)setCommentInfoDic:(NSDictionary *)commentInfoDic isPopOut:(BOOL)isPopOut userLocalData:(NSDictionary *)userLocalDataDic{
    _commentInfoDic = commentInfoDic;
    _userLocalDataDic = userLocalDataDic;
    
    BOOL localOpen = [MAGoodsCommentCell isAlreadyCommented:commentInfoDic];
    
    if (!localOpen) {
        localOpen = isPopOut;//如果还没评价，则根据传入的值 决定是否展开。已经评论的则必然展开
    }
    
    if (localOpen) {
        _popView.hidden = NO;
        
        if ([MAGoodsCommentCell isAlreadyCommented:commentInfoDic]) {
            //已评价 用commentInfoDic初始化
            
            //初始化 星级
            _starBoard.allowChange = NO;
            _starBoard.scorePercent = [commentInfoDic[@"starnum"] integerValue] / 5.f;
            
            //初始化 btn
            NSString *marks = commentInfoDic[@"mark"];
            [self setRemoteMarks:marks];
            //初始化 留言
            NSString *message = commentInfoDic[@"content"];
            if (message != nil && message.length > 0) {
                _messageLabel.hidden = NO;
                _messageLabel.text = message;
            }else {
                _messageLabel.hidden = YES;
            }
            _messageTextView.hidden = YES;
            
            _satisfactionSection.fHeight = [MAGoodsCommentCell flexibleSatisfactionSectioHeightWithMessage:message];
            //初始化图片
            NSString *images = commentInfoDic [@"imagesUrl"];
            [self setRemoteImages:images];
        }else {
            _starBoard.allowChange = YES;
            _starBoard.scorePercent = [userLocalDataDic[@"starnum"] integerValue] / 5.f;
            
            //未评价 用userLocalDataDic初始化
            _messageLabel.hidden = YES;
            _messageTextView.hidden = NO;
            
            _satisfactionSection.fHeight = [MAGoodsCommentCell fixedSatisfactionSectioHeight];
            
            //初始化 图片
            _imageSection.orgY = _satisfactionSection.maxY;
            _popView.fHeight = _imageSection.maxY;
            //初始化message
            NSString *message = userLocalDataDic[@"message"];
            _messageTextView.text = message;//留言,默认无留言
            //初始化 评价标签
            NSDictionary *userMarks = userLocalDataDic[@"markIndexs"];
            NSArray *markKeys = [userMarks allKeys];//[0-4]
            
            for (NSString *key in markKeys) {
                NSNumber *number = userMarks[key];
                JKButton *sBtn = (JKButton *)[_satisfactionSection viewWithTag:100 + [key integerValue]];//key[0-4]
                sBtn.selected = [number integerValue] == 1;
            }
            //图片dic格式  {imageId:image,..}   @"userImages"
            
            NSDictionary *imagesDic = userLocalDataDic[@"userImages"];
            [self setLocalUserImages:imagesDic];
        }
        
        _bottomSeparator.orgY = _popView.maxY;
    }else {
        _popView.hidden = YES;
        _bottomSeparator.orgY = _goodsInfoSection.maxY;
        //未展开的一定是 本地的数据。
        _starBoard.allowChange = YES;
        _starBoard.scorePercent = [userLocalDataDic[@"starnum"] integerValue] / 5.f;
    }
}

//服务器数据
- (void)setRemoteMarks:(NSString *)marks {
    //用户已评价的 标签
    if ([marks hasSuffix:@","]) {
        marks = [marks substringToIndex:marks.length - 1];
    }
    /*注mark值表： {1，质量不错；2，价格优惠；3，物流快；4，服务态度不错；5，包装好；
     6，质量不好；7，价格不合理；8，物流太慢；9，服务态度不好；10，包装破损} */
    NSArray *markArray = [JKTool getArrayFromComponentStr:marks];
    
    for (int i = 0; i < 5; i++) {
        JKButton *sBtn = (JKButton *)[_satisfactionSection viewWithTag:100 + i];
        sBtn.selected = NO;
    }
    
    for (NSString *mark in markArray) {
        
        if (mark.length > 0) {
            JKButton *sBtn = (JKButton *)[_satisfactionSection viewWithTag:100 + [mark integerValue] - 1];
            sBtn.selected = YES;
        }
    }
}

//服务器数据
- (void)setRemoteImages:(NSString *)images {
    
    NSArray *imagesArray = [JKTool getArrayFromComponentStr:images];
    
    if (imagesArray != nil && imagesArray.count > 0) {
        //有图片
        _imageSection.orgY = _satisfactionSection.maxY;
        _popView.fHeight = _imageSection.maxY;
        
        for (int i = 0; i < 3; i++) {
            
            JKButton *imageBtn = (JKButton *)[_imageSection viewWithTag:100 + i];
            if (i < imagesArray.count) {
                imageBtn.hidden = NO;
                NSString *urlStr = imagesArray[i];
                NSURL *url = [NSURL URLWithString:urlStr];
                [imageBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"commonPlaceHolderIcon"]];
            }else {
                imageBtn.hidden = YES;
            }
        }
    }else {
        //无图片
        _popView.fHeight = _satisfactionSection.maxY;//_popView clipToBounds
    }
}

//本地数据
- (void)setLocalUserImages:(NSDictionary *)imagesDic {
    //imagesArray是一个mutableDic
    //图片dic格式  {imageId:image,..}
    
    NSArray *imageIds = [imagesDic allKeys];
    for (int i = 0; i < 3; i++) {
        
        JKButton *imageBtn = (JKButton *)[_imageSection viewWithTag:100 + i];
        imageBtn.hidden = NO;
        
        if (i < imageIds.count) {
            NSString *imageId = imageIds[i];
            UIImage *image = imagesDic[imageId];
            [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
        }else if (i == imageIds.count) {
            [imageBtn setBackgroundImage:[UIImage imageNamed:@"shangchuan"] forState:UIControlStateNormal];//"+"
        }else {
            imageBtn.hidden = YES;
        }
    }
}

#pragma mark - setters

- (void)setImageUrlStr:(NSString *)imageUrlStr {
    _imageUrlStr = imageUrlStr;
    if (imageUrlStr != nil) {
        NSURL *url = [NSURL URLWithString:imageUrlStr];
        [_imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"commonPlaceHolderIcon"]];
    }
}

- (void)setTitleStr:(NSString *)titleStr {
    
    _titleStr = titleStr;
    
    _titleLabel.text = titleStr;
}

- (void)setStarCount:(NSInteger)starCount {
    _starCount = starCount;
    _starBoard.scorePercent = starCount / 5.f;
    
    if (starCount < 3) {
        self.isSatisfied = NO;
    }else {
        self.isSatisfied = YES;
    }
}

#pragma mark -

+ (CGFloat)cellHeightForCommentInfoDic:(NSDictionary *)commentInfoDic isPopOut:(BOOL)isPopOut{
    
    CGFloat goodsInfoSectionHeight = [self goodsInfoSectionHeight];
    
    if (!isPopOut) {
        //未展开
        return goodsInfoSectionHeight + 1.f;// //底部分割线 + 1
    }
    
    CGFloat imageSectionHeight = [self imageSectionHeight];
    
    CGFloat satisfactionSectionHeight = 0.f;
    
    
    if (commentInfoDic != nil && commentInfoDic[@"starnum"] != nil) {
        //已有评价
        NSString *message = commentInfoDic[@"content"];
        satisfactionSectionHeight = [self flexibleSatisfactionSectioHeightWithMessage:message];
        
        NSString *images = commentInfoDic [@"imagesUrl"];
        NSArray *imagesArray = [JKTool getArrayFromComponentStr:images];
        
        if (imagesArray != nil && imagesArray.count > 0) {
            //有图片
            
        }else {
            //无图片
            imageSectionHeight = 0.f;
        }
    }else {
        //未评价
        satisfactionSectionHeight = [self fixedSatisfactionSectioHeight];
    }
    
    CGFloat cellHeight = goodsInfoSectionHeight + satisfactionSectionHeight + imageSectionHeight + 1.f;//底部分割线 + 1
    
    return cellHeight;
}

+ (CGFloat)goodsInfoSectionHeight {
    return 122.f;
}

+ (CGFloat)messageTextViewHeight {
    return 60.f;
}

+ (UIFont *)messageLabelFont {
    return FONT_HEL(12.f);
}

+ (CGFloat)leading {
    
    return 8.f;
}

/**
 *  @author 黎国基, 16-11-26 15:11
 *
 *  未评价的 _satisfactionSection高度 ，固定
 *
 *  @return
 */
+ (CGFloat)fixedSatisfactionSectioHeight {
    
    CGFloat messageViewY = [MAGoodsCommentCell messageViewY];
    CGFloat messageTextViewHeight = [MAGoodsCommentCell messageTextViewHeight];
    
    return messageViewY + messageTextViewHeight + 5.f;
}

/**
 *  @author 黎国基, 16-11-26 15:11
 *
 *  已评价的 _satisfactionSection高度，根据内容变化高度
 *
 *  @param message 评价的 留言
 *
 *  @return
 */
+ (CGFloat)flexibleSatisfactionSectioHeightWithMessage:(NSString *)message {
    
    CGFloat messageViewY = [MAGoodsCommentCell messageViewY];
    
    if (message == nil) {
        return messageViewY;
    }
    
    CGFloat leading = [self leading];
    CGFloat contentW = SCREEN_WIDTH - leading * 2.f;
    CGFloat messgeW = contentW - leading * 2.f;
    UIFont *messageLabelFont = [self messageLabelFont];
    
    
    CGFloat labelH = [JKAutoFitsHeightWithLineSpacingLabel heightForLabelText:message width:messgeW lineSpacing:3.f font:messageLabelFont];
    
    return messageViewY + labelH + 5.f;
}


+ (CGFloat)messageViewY {
    return 95.f;
}

+ (CGFloat)imageSectionHeight {
    return 65.f;
}

+ (BOOL)isAlreadyCommented:(NSDictionary *)commentInfoDic {
    
    if (commentInfoDic != nil && commentInfoDic[@"starnum"] != nil) {
        return YES;
    }else {
        //未评价
        return NO;
    }
}

#pragma mark - CWStarRateViewDelegate

- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent {
    
    _popView.hidden = (newScorePercent == 0);
    
    if (newScorePercent * 5.f < 3.f) {
        self.isSatisfied = NO;
    }else {
        self.isSatisfied = YES;
    }
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(starViewDidSetStarCount:atRow:)]) {
        
        NSInteger starCount = _starBoard.scorePercent * 5.f;
        if (starCount > 5) {
            starCount = 5;
        }
        [_delegate starViewDidSetStarCount:starCount atRow:_row];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextViewDelegate 

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(starViewDidSetMessage:atRow:)]) {
        
        [_delegate starViewDidSetMessage:_messageTextView.text atRow:_row];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(activeTextViewBottomPoint:forCell:)]) {
        
        CGPoint origin = textView.frame.origin;
        CGPoint bottom = origin;
        bottom.y = origin.y + textView.frame.size.height;
        
        bottom.y = bottom.y + [MAGoodsCommentCell goodsInfoSectionHeight];
        
        [_delegate activeTextViewBottomPoint:bottom forCell:self];
    }
    return YES;
}


@end






























