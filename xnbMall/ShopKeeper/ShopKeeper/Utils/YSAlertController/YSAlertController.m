//
//  YSAlertController.m
//  YSAlertView
//
//  Created by NQ on 16/3/27.
//  Copyright © 2016年 NQ. All rights reserved.
//

#import "YSAlertController.h"
#import <objc/runtime.h>

typedef void (^YSAlertActionClickHandler)(YSAlertAction* action);

@interface YSAlertAction()
/**
 *  按钮标题(重写属性)
 */
@property (nonatomic, copy) NSString *title;
/**
 *  按钮样式(重写属性)
 */
@property (nonatomic, assign) YSAlertActionStyle style;
/**
 *  按钮点击的回调方法
 */
@property (nonatomic, copy) YSAlertActionClickHandler handler;

@end

@implementation YSAlertAction

/**
 *  初始化按钮
 *
 *  @param title   标题
 *  @param style   样式
 *  @param handler 点击后的回调
 */
+ (instancetype)ys_actionWithTitle:(NSString*)title style:(YSAlertActionStyle)style handler:(void (^)(YSAlertAction *action))handler{
    // 初始化
    YSAlertAction* alertAction = [[YSAlertAction alloc]init];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        alertAction = (YSAlertAction*)[UIAlertAction actionWithTitle:title style:(NSInteger)style handler:(void (^ __nullable)(UIAlertAction *))handler];
    }
    
    alertAction.title   = title;
    alertAction.style   = style;
    alertAction.handler = handler;
    
    return alertAction;
}

@end



@implementation UIViewController (YSAlertController)

static NSString *ysalertControllerKey = @"ysalertControllerKey";

- (void)setYsalertController:(UIViewController *)ysalertController{
    objc_setAssociatedObject(self, &ysalertControllerKey, ysalertController, OBJC_ASSOCIATION_RETAIN);
}

- (UIViewController*)ysalertController{
    return objc_getAssociatedObject(self, &ysalertControllerKey);
}

@end



@interface YSAlertController ()<UIActionSheetDelegate,UIAlertViewDelegate>
/**
 *  标题(重写属性)
 */
@property (nonatomic, copy) NSString *alertControllerTitle;
/**
 *  信息(重写属性)
 */
@property (nonatomic, copy) NSString *alertControllerMessage;
/**
 *  类型(重写属性)
 */
@property (nonatomic,assign)YSAlertControllerStyle style;
/**
 *  UIActionSheet Or UIAlertView
 */
@property (nullable,nonatomic,strong)UIView* adaptiveView;
/**
 *  UIAlertController
 */
@property (nullable,nonatomic,strong)UIAlertController* adaptiveController;

@end

@implementation YSAlertController

#pragma mark - Init
- (instancetype)init{
    if(self = [super init]){
        // 初始化属性
        _actions = [NSMutableArray array];
    }
    return self;
}

#pragma mark - PublicMehtod
/**
 *  初始化一个YSAlertController
 *
 *  @param title   标题
 *  @param message 信息
 *  @param style   风格
 */
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message style:(YSAlertControllerStyle)style{
    // 初始化
    YSAlertController* alertController = [[YSAlertController alloc]init];
    alertController.style = style;
    alertController.alertControllerTitle = title;
    alertController.alertControllerMessage = message;

    // 判断版本号
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        // UIAlertController
        alertController.adaptiveController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(NSInteger)style];
    }else{
//        #if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
        // UIActionSheet Or UIAlertView
        if(style == YSAlertControllerStyleActionSheet){
            alertController.adaptiveView = [[UIActionSheet alloc]initWithTitle:title delegate:alertController cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];;
        }else if (style == YSAlertControllerStyleAlert){
            alertController.adaptiveView = [[UIAlertView alloc]initWithTitle:title message:message delegate:alertController cancelButtonTitle:nil otherButtonTitles:nil, nil];
        }
//        #endif
    }
    return alertController;
}

/**
 *  显示YSAlertController
 *
 *  @param viewController 从哪个控制器显示
 *  @param flag           是否需要动画
 *  @param completion     显示完成后的回调
 */
- (void)presentYSAlertControllerFromController:(UIViewController*)viewController animated: (BOOL)flag completion:(void (^)(void))completion{
    // 判断系统版本号
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        // UIAlertController
        [viewController presentViewController:self.adaptiveController animated:YES completion:completion];
    }else{
//        #if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
        // 强属性引用
        viewController.ysalertController = self;
        
        // UIActionSheet Or UIAlertView
        if([self.adaptiveView isKindOfClass:[UIActionSheet class]]){
            [(UIActionSheet*)self.adaptiveView showInView:viewController.view];
        }else if ([self.adaptiveView isKindOfClass:[UIAlertView class]]){
            [(UIAlertView*)self.adaptiveView show];
        }
//        #endif
    }
}

/**
 *  添加按钮
 */
- (void)addAction:(YSAlertAction *)action{
    // 1.看里面是否存在取消按钮
    if(action.style == YSAlertActionStyleCancel){
        // 先遍历一边看是否有取消按钮
        for (YSAlertAction* existsAction in self.actions){
            if(existsAction.style == YSAlertActionStyleCancel){
                return;
            }
        }
    }
    
    // 2.看里面是否存在销毁按钮
    if(action.style == YSAlertActionStyleDestructive){
        // 判断系统版本号
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            // 先遍历一边看是否有销毁按钮
            for (YSAlertAction* existsAction in self.actions){
                if(existsAction.style == YSAlertActionStyleDestructive){
                    return;
                }
            }
        }else{
            return;
        }
    }
    
    // 判断系统版本号
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [self.adaptiveController addAction:(UIAlertAction *)action];
    }else{
//        #if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
        if(self.style == YSAlertControllerStyleActionSheet){
            UIActionSheet* actionSheet = (UIActionSheet*)self.adaptiveView;
            NSInteger index = [actionSheet addButtonWithTitle:action.title];
            switch (action.style) {
                case YSAlertActionStyleDefault:
                    break;
                case YSAlertActionStyleCancel:
                    [actionSheet setCancelButtonIndex:index];
                    break;
                case YSAlertActionStyleDestructive:
                    [actionSheet setDestructiveButtonIndex:index];
                    break;
                default:
                    break;
            }
        }else if (self.style == YSAlertControllerStyleAlert){
            UIAlertView* alertView = (UIAlertView*)self.adaptiveView;
            NSInteger index = [alertView addButtonWithTitle:action.title];
            switch (action.style) {
                case YSAlertActionStyleDefault:
                    
                    break;
                case YSAlertActionStyleCancel:
                    [alertView setCancelButtonIndex:index];
                    break;
                case YSAlertActionStyleDestructive:
                    // 不进行
                    break;
                default:
                    break;
            }
        }
//        #endif
    }

    // 添加按钮
    [self.actions addObject:action];
}

//#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0

#pragma - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   // __weak typeof(self)weakSelf = self;
    typeof(self)weakSelf = self;
    if (self.actions[buttonIndex].handler) {
        weakSelf.actions[buttonIndex].handler(weakSelf.actions[buttonIndex]);
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.ysalertController = nil;
}

#pragma - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
   // __weak typeof(self)weakSelf = self;
    typeof(self)weakSelf = self;
    
    if (self.actions[buttonIndex].handler) {
        weakSelf.actions[buttonIndex].handler(weakSelf.actions[buttonIndex]);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    self.ysalertController = nil;
}

//#endif

/**
 * ///////////////////////////////////使用实例//////////////////////////////////////////////////////////////////
 */
/**
 
 - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
 YSAlertController* alertController = [YSAlertController alertControllerWithTitle:@"提示" message:@"弹出消息" style:YSAlertControllerStyleActionSheet];
 
 YSAlertAction* action1 = [YSAlertAction ys_actionWithTitle:@"确定" style:YSAlertActionStyleDefault handler:^(YSAlertAction *action) {
 NSLog(@"%@",action.title);
 }];
 
 YSAlertAction* action2 = [YSAlertAction ys_actionWithTitle:@"取消" style:YSAlertActionStyleCancel handler:^(YSAlertAction *action) {
 NSLog(@"%@",action.title);
 }];
 
 YSAlertAction* action3 = [YSAlertAction ys_actionWithTitle:@"销毁" style:YSAlertActionStyleDestructive handler:^(YSAlertAction *action) {
 NSLog(@"%@",action.title);
 }];
 
 [alertController addAction:action1];
 [alertController addAction:action2];
 [alertController addAction:action2];
 [alertController addAction:action3];
 [alertController addAction:action3];
 
 [alertController presentYSAlertControllerFromController:self animated:YES completion:^{
 NSLog(@"完成");
 }];
 }
 *////////////////////////////////////////////////////////////////////////
@end
