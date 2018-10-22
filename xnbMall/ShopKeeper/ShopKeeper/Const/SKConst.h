/**
 * SKConst.h 16/11/2
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import <UIKit/UIKit.h>

/**
 *  html加载条的在具体加载控制器下的y值
 */
//typedef NS_ENUM(NSUInteger, SKActingloadMaximumY) {
//    SKActingloadMaximumState,   //只有状态栏
//    SKActingloadMaximumNavigation,   //有状态栏 和导航栏
//    SKActingloadMaximumNobar  //无状态栏和 导航栏
//};

typedef enum {
        SKActingloadMaximumState,   //只有状态栏
        SKActingloadMaximumNavigation,   //有状态栏 和导航栏
        SKActingloadMaximumNobar  //无状态栏和 导航栏
}SKActingloadMaximumY;




/**
 *  支付跳转具体控制器
 */
typedef NS_ENUM(NSUInteger, SKPaytypeSkipController) {
    SKRechargeSkipContollerOne,   //充值支付成功返回到充值前界面
    SKShoppingCartContollerTwo,   //购物车支付跳转我的订单界面
    SKChangeOrderControolerShree  //转单支付跳转
};

/**
 * cell中控件的字体大小
 */
typedef enum {
   SKRecipeCellFontSizeTitle = 16,        // 标题
   SKRecipeCellFontSizeDesc = 12,         // 描述
   SKRecipeCellFontSizeFirstTitle = 20,   // 大标题
   SKRecipeCellFontSizeSecondTitle = 14   // 小标题
    
} SKRecipeCellFontSize;

/** JS调OC返回通知 */
UIKIT_EXTERN NSString *const WKScriptMessageDidChangedNotification;


