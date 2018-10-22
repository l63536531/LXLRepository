/**
 * MASpecificationView.h 16/11/19
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "JKView.h"

/**
 *  @author 黎国基, 16-11-19 09:11
 *
 *  商品详情--规格
 */

@protocol MASpecificationViewDelegate <NSObject>

- (void)specificationViewDidChangeSpecification:(NSString *)specId;

@end

@interface MASpecificationView : JKView

@property (nonatomic, unsafe_unretained) id<MASpecificationViewDelegate>delegate;

/**
 *  @author 黎国基, 16-11-19 09:11
 *
 *  所有规格，如鞋子规格有  尺码（38，39，40，41，42）、颜色（蓝黑红白黄）
 *  警告：这个属性只能set一次，否则会重复生成button!
 */
@property (nonatomic, strong) NSDictionary *specTypeMapDic;

/**
 *  @author 黎国基, 16-11-19 09:11
 *
 *  所有规格的允许组合，如  41码鞋子 只能 选 黑色；40码可选 蓝色、黑色、红色。
 */
@property (nonatomic, strong) NSDictionary *specDescMapDic;

@property (nonatomic, readonly) NSDictionary *specIdDic;

- (void)setSpecId:(NSString *)specId;//有默认的规格id，因为商品详情的价格需要规格id，所以一定要有默认的规格

@end
