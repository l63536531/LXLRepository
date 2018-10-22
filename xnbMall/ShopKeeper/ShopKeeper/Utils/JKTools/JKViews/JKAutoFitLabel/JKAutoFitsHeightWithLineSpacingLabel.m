//
//  JKAutoFitsHeightWithLineSpacingLabel.m
//  LifeTelling
//
//  Created by IOS－001 on 15/6/1.
//  Copyright (c) 2015年 E-Techco Information Technologies Co., LTD. All rights reserved.
//

#import "JKAutoFitsHeightWithLineSpacingLabel.h"

#import "JKTool.h"

@interface JKAutoFitsHeightWithLineSpacingLabel ()
{
    CGFloat _lineSpacing;
}
@end

@implementation JKAutoFitsHeightWithLineSpacingLabel

/**
 *  高度可以为任意值
 */
-(instancetype)initWithFrame:(CGRect)frame lineSpacing:(CGFloat)lineSpacing
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineSpacing = lineSpacing;
        
        self.numberOfLines = 0;
    }
    return self;
}

/**
 *  必须先设置font，后设置text
 *  此处 text并非真正的 text，而是attributedText
 */
-(void)setText:(NSString *)text
{
    if (!text) {
        text = @"";
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    //注意，每一行的行间距分两部分，topSpacing和bottomSpacing。
    [paragraphStyle setLineSpacing:_lineSpacing];//调整行间距
//    [paragraphStyle setParagraphSpacing:_lineSpacing/2.f];
//    [paragraphStyle setFirstLineHeadIndent:0.f];
//    [paragraphStyle setHeadIndent:0.f];
//    [paragraphStyle setTailIndent:0.f];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    self.attributedText = attributedString;//ios 6
    
    CGSize size = [self sizeThatFits:CGSizeMake(self.fWidth, MAXFLOAT)];
    self.fHeight = size.height;
}

-(void)setAttributedText:(NSAttributedString *)attributedText
{
    NSMutableAttributedString *mAttrStr = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //注意，每一行的行间距分两部分，topSpacing和bottomSpacing。
    [paragraphStyle setLineSpacing:_lineSpacing];//调整行间距
    
    [mAttrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, mAttrStr.length)];
    
    super.attributedText = mAttrStr;//ios 6
    
    CGSize size = [self sizeThatFits:CGSizeMake(self.fWidth, MAXFLOAT)];
    self.fHeight = size.height;
}

-(void)setText:(NSString *)text fixedLines:(NSInteger)lineCount
{
    if (!text) {
        text = @"";
    }
    
    NSArray *lines = [JKTool getSeparatedLinesFromLabelText:text Width:self.fWidth font:self.font];
    NSString *finalStr = [JKTool fitedStringForStringArray:lines lineCount:lineCount];
    
    self.fHeight = [JKAutoFitsHeightWithLineSpacingLabel heightForLines:lineCount lineSpacing:_lineSpacing font:self.font];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:finalStr];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    //注意，每一行的行间距分两部分，topSpacing和bottomSpacing。
    [paragraphStyle setLineSpacing:_lineSpacing];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, finalStr.length)];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, finalStr.length)];
    
    self.attributedText = attributedString;//ios 6
}

-(void)setText:(NSString *)text maxLines:(NSInteger)maxLines
{
    if (!text) {
        text = @"";
    }
    
    NSArray *lines = [JKTool getSeparatedLinesFromLabelText:text Width:self.fWidth font:self.font];
    NSString *finalStr = [JKTool trucatedStringForStringArray:lines lineCount:maxLines];
    
    if (lines.count < maxLines)
    {
        self.fHeight = [JKAutoFitsHeightWithLineSpacingLabel heightForLines:lines.count lineSpacing:_lineSpacing font:self.font];
    }else
    {
        CGFloat height = [JKAutoFitsHeightWithLineSpacingLabel heightForLines:maxLines lineSpacing:_lineSpacing font:self.font];
        self.fHeight = height;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:finalStr];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    //注意，每一行的行间距分两部分，topSpacing和bottomSpacing。
    [paragraphStyle setLineSpacing:_lineSpacing];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, finalStr.length)];
    
    self.attributedText = attributedString;//ios 6
}



+(CGFloat)heightForLabelText:(NSString *)text width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing font:(UIFont *)font
{
    JKAutoFitsHeightWithLineSpacingLabel *tempLabel = [[JKAutoFitsHeightWithLineSpacingLabel alloc]initWithFrame:CGRectMake(0.f, 0.f, width, 0.f) lineSpacing:lineSpacing];
    tempLabel.font = font;
    tempLabel.text = text;
    return tempLabel.fHeight;
    
//    //不生成view，效率应该更高，iOS9下计算高度出现了误差！
//    NSArray *lines = [JKTool getSeparatedLinesFromLabelText:text Width:width font:font];
//    
//    CGFloat height = [JKAutoFitsHeightWithLineSpacingLabel heightForLines:lines.count lineSpacing:lineSpacing font:font];
//    return height;
}

+(CGFloat)heightForLines:(NSInteger)lineCount lineSpacing:(CGFloat)lineSpacing font:(UIFont *)font
{
    NSString *astr = @"随意（汉字？）字符串";
    
    CGSize strSize;
    strSize = [astr sizeWithAttributes:@{NSFontAttributeName:font}];
    
    //当fontSize = 13.f是，行高是15.f,而不是13.f！！！！
    CGFloat height = (strSize.height+lineSpacing)*lineCount;
    
    return height;
}

//最多允许 maxLineCount 行文字。行数多出maxLineCount时，也只取maxLineCount行，少于则取实际行数
+(CGFloat)heightForLabelText:(NSString *)text width:(CGFloat)width maxLines:(NSInteger)maxLines lineSpacing:(CGFloat)lineSpacing font:(UIFont *)font
{
    
    NSArray *lines = [JKTool getSeparatedLinesFromLabelText:text Width:width font:font];
    
    //当fontSize = 13.f是，行高是15.f,而不是13.f！！！！
    CGFloat height = 0.f;
    
    if (lines.count < maxLines)
    {
        height = [JKAutoFitsHeightWithLineSpacingLabel heightForLines:lines.count lineSpacing:lineSpacing font:font];
    }else
    {
        height = [JKAutoFitsHeightWithLineSpacingLabel heightForLines:maxLines lineSpacing:lineSpacing font:font];
    }
    return height;
}

+(CGFloat)lineSpacingWithFont:(UIFont *)font heightForTwoLines:(CGFloat)height
{
    NSString *astr = @"随意（汉字？）字符串";
    CGSize strSize;
    if ([JKTool iOSVersion] >= 7.0f) {
        strSize = [astr sizeWithAttributes:@{NSFontAttributeName:font}];
    }else
    {
        strSize = [astr sizeWithFont:font];
    }
    CGFloat lineSpacing = (height-strSize.height)/2.f;
    return lineSpacing;
}


@end
