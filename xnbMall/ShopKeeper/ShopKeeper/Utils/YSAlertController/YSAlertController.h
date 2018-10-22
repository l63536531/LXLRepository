

#import "MABaseViewController.h"


typedef NS_ENUM(NSInteger, YSAlertActionStyle) {
    YSAlertActionStyleDefault = 0,
    YSAlertActionStyleCancel,
    YSAlertActionStyleDestructive// IOS8以下的UIAlertView没有此属性。
};

@interface YSAlertAction : NSObject
/**
 *  按钮标题
 */
@property (nonatomic, readonly) NSString *title;
/**
 *  按钮样式
 */
@property (nonatomic, readonly) YSAlertActionStyle style;

/**
 *  初始化按钮
 *
 *  @param title   标题
 *  @param style   样式
 *  @param handler 点击后的回调
 */
+ (instancetype)ys_actionWithTitle:(NSString*)title style:(YSAlertActionStyle)style handler:(void (^)(YSAlertAction *action))handler;

@end



@interface UIViewController (YSAlertController)

@property (nonatomic, weak) UIViewController *ysalertController;

@end



typedef NS_ENUM(NSUInteger,YSAlertControllerStyle){
    YSAlertControllerStyleActionSheet = 0,
    YSAlertControllerStyleAlert
};

@interface YSAlertController : MABaseViewController

/**
 *  类型
 */
@property (nonatomic,readonly) YSAlertControllerStyle style;
/**
 *  按钮数组
 */
@property (nonatomic, readonly) NSMutableArray<YSAlertAction *> *actions;
/**
 *  标题
 */
@property (nonatomic, readonly) NSString *alertControllerTitle;
/**
 *  信息
 */
@property (nonatomic, readonly) NSString *alertControllerMessage;

/**
 *  初始化一个YSAlertController
 *
 *  @param title   标题
 *  @param message 信息
 *  @param style   风格
 */
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message style:(YSAlertControllerStyle)style;

/**
 *  添加按钮
 */
- (void)addAction:(YSAlertAction *)action;

/**
 *  显示YSAlertController
 *
 *  @param viewController 从哪个控制器显示
 *  @param flag           是否需要动画
 *  @param completion     显示完成后的回调(IOS8以下传空即可)
 */
- (void)presentYSAlertControllerFromController:(UIViewController*)viewController animated: (BOOL)flag completion:(void (^)(void))completion;

@end
