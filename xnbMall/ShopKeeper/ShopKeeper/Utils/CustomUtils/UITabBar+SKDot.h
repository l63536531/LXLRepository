//
//  UITabBar+SKDot.h
//  ShopKeeper
//
//  Created by XNB2 on 17/5/4.
//  Copyright © 2017年 Frechai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (SKDot)


/*!
 * @brief   显示小红点
 * @param   index 将要显示小红点的tabbarItem的索引(第一个item的索引为0)
 * @return
 */
- (void)showBadgeOnItmIndex:(NSInteger)index;

/*!
 * @brief   隐藏小红点
 * @param   index 将要隐藏小红点的tabbarItem的索引(第一个item的索引为0)
 * @return
 */
- (void)hideBadgeOnItemIndex:(NSInteger)index;

@end
