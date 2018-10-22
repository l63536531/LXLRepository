/**
 * MAGoodsDetailsTitleView.h 16/11/18
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

@protocol MAGoodsDetailsTitleViewDelegate <NSObject>

- (void)titleViewShare;

@end

/**
 *  @author 黎国基, 16-11-19 09:11
 *
 *  商品详情--标题、价格
 */
@interface MAGoodsDetailsTitleView : JKView

@property (nonatomic, unsafe_unretained) id<MAGoodsDetailsTitleViewDelegate>delegate;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *desc;

@property (nonatomic, assign) CGFloat price;

@end
