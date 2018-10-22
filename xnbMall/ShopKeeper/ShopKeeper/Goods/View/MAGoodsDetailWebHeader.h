/**
 * MAGoodsDetailWebHeader.h 16/11/19
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
 *  @author 黎国基, 16-11-19 21:11
 *
 *  商品详情  tableView header，用于webview所在section
 */

@protocol MAGoodsDetailWebHeaderDelegate <NSObject>

- (void)goodsDetailsWebHeaderBtnClicked:(NSInteger)btnTag;

@end

@interface MAGoodsDetailWebHeader : JKView

@property (nonatomic, unsafe_unretained) id<MAGoodsDetailWebHeaderDelegate>delegate;

@end
