/**
 * UIDragButton.h 16/12/8
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol UIDragButtonDelegate <NSObject>

-(void)dragButtonClicked:(UIButton*)sender;

@end

@interface UIDragButton : UIButton

/**
 *  悬浮窗所依赖的根视图
 */
@property(nonatomic,strong)UIView *rootView;

/**
 *  UIDragButton的点击事件代理
 */
@property(nonatomic,weak)id <UIDragButtonDelegate> btnDelegate;

@end
