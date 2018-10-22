/**
 * MACommentInfoView.h 16/11/19
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

@protocol MACommentInfoViewDelegate <NSObject>

- (void)seeMoreComments;

@end

@interface MACommentInfoView : JKView

@property (nonatomic, unsafe_unretained) id<MACommentInfoViewDelegate>delegate;

@property (nonatomic, strong) NSDictionary *commentSumDic;

@property (nonatomic, strong) NSDictionary *commentDic;

@end
