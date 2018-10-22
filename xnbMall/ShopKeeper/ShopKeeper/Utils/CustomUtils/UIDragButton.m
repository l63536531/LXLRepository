/**
 * UIDragButton.m 16/12/8
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */


#import "UIDragButton.h"

@interface UIDragButton()

@property(nonatomic,assign)CGPoint startPos;

@end

@implementation UIDragButton

// 枚举四个吸附方向
typedef enum {
    LEFT,
    RIGHT,
    TOP,
    BOTTOM
}Dir;

/**
 *  开始触摸，记录触点位置用于判断是拖动还是点击
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    _startPos = [touch locationInView:_rootView];
}

/**
 *  手指按住移动过程,通过悬浮按钮的拖动事件来拖动整个悬浮窗口
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:_rootView];
    // 移动按钮到当前触摸位置
    self.superview.center = curPoint;
}

/**
 *  拖动结束后使悬浮窗口吸附在最近的屏幕边缘
 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:_rootView];
    // 通知代理,如果结束触点和起始触点极近则认为是点击事件
    if (pow((_startPos.x - curPoint.x),2) + pow((_startPos.y - curPoint.y),2) < 1) {
        [self.btnDelegate dragButtonClicked:self];
        // 点击后不吸附
        return;
    }

    CGFloat left = curPoint.x;
    CGFloat right = SCREEN_WIDTH - curPoint.x;
    CGFloat top = curPoint.y;
    CGFloat bottom = SCREEN_HEIGHT - curPoint.y;
    // 计算四个距离最小的吸附方向
    Dir minDir = LEFT;
    CGFloat minDistance = left;
    if (right < minDistance) {
        minDistance = right;
        minDir = RIGHT;
    }
    if (top < minDistance) {
        minDistance = top;
        minDir = TOP;
    }
    if (bottom < minDistance) {
        minDir = BOTTOM;
    }
    
    // 开始吸附
    switch (minDir) {
        case LEFT:
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.superview.center = CGPointMake(self.superview.frame.size.width/2, self.superview.center.y);
            }];
            break;
        }
        case RIGHT:
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.superview.center = CGPointMake(SCREEN_WIDTH - self.superview.frame.size.width/2, self.superview.center.y);
            }];
            break;
        }
        case TOP:
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.superview.center = CGPointMake(self.superview.center.x , self.superview.frame.size.height/2);
            }];
            break;
        }
        case BOTTOM:
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.superview.center = CGPointMake(self.superview.center.x, SCREEN_HEIGHT - self.superview.frame.size.height/2);
            }];
            break;
        }
        default:
            break;
    }
}

@end
