//
//  JKAutoFitsHeightWithLineSpacingLabel.h
//  LifeTelling
//
//  Created by IOS－001 on 15/6/1.
//  Copyright (c) 2015年 E-Techco Information Technologies Co., LTD. All rights reserved.
//

#import "JKLabel.h"

@interface JKAutoFitsHeightWithLineSpacingLabel : JKLabel

/**
 *  高度可以为任意值
 */
-(instancetype)initWithFrame:(CGRect)frame lineSpacing:(CGFloat)lineSpacing;

/**
 *  指定行数，超出部分文字将被截断(高度是固定的)
 *
 *  @param text      内容字符串
 *  @param lineCount 期望的行数
 */
-(void)setText:(NSString *)text fixedLines:(NSInteger)lineCount;

/**
 *  指定最大行数，超出部分文字将被截断；如果实际行数少于maxLines，则自动取实际行数（高度根据内容变化，最多不高于maxLines行）
 *
 *  @param text      内容字符串
 *  @param lineCount 期望的行数
 */
-(void)setText:(NSString *)text maxLines:(NSInteger)maxLines;

/**
 *  计算label高度（纯自适应，内容需要多高就多高）
 *
 *  @param text          内容字符串
 *  @param width         label的宽度
 *  @param lineSpacing   两行字间的行距
 *  @param font          字体
 *  @param lineBreakMode lineBreakMode
 *
 *  @return label 高度
 */

+(CGFloat)heightForLabelText:(NSString *)text width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing font:(UIFont *)font;

/**
 *  指定期待的行数，计算在此行数下label的高度（(行高+行距)*lineCount）
 *
 *  @param lineCount   行数
 *  @param lineSpacing 行间距
 *  @param font        字体
 *
 *  @return label 高度
 */

+(CGFloat)heightForLines:(NSInteger)lineCount lineSpacing:(CGFloat)lineSpacing font:(UIFont *)font;

/**
 *  给定text，width 以及最大允许行数maxLines，计算实际高度
 *
 *  @param text        文本
 *  @param width       label的宽度
 *  @param maxLines    最大允许行数（假设maxLines = 2，若实际行数 = 1，则返回[1行]的高度，实际行数为 10，则只返回[2行]的高度）
 *  @param lineSpacing 两行字间的行距
 *  @param font        字体
 *
 *  @return label 高度
 */
+(CGFloat)heightForLabelText:(NSString *)text width:(CGFloat)width maxLines:(NSInteger)maxLines lineSpacing:(CGFloat)lineSpacing font:(UIFont *)font;

/**
 *  一个label，行高确定后，行数固定为2，计算合适的行间距
 *
 *  @param font   字体
 *  @param height label高度
 *
 *  @return 行间距
 */

+(CGFloat)lineSpacingWithFont:(UIFont *)font heightForTwoLines:(CGFloat)height;

@end
