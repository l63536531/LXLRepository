/**
 * MASpecBtn.h 16/11/19
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "JKButton.h"

/**
 *  @author 黎国基, 16-11-19 10:11
 *
 *  商品详情--规格选择 按钮，有3种状态--不可选、可选、选中
 */
@interface MASpecBtn : JKButton

/**
 *  @author 黎国基, 16-11-19 10:11
 *
 *  有3种状态--不可选 0、可选 1、选中 2
 */
@property (nonatomic, assign) NSInteger specState;

@property (nonatomic, strong) NSString *specType;

@property (nonatomic, strong) NSString *specValue;

@end
