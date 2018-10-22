//
//  VPImageCropperViewController.h
//  KongZi
//
//  Created by wen su on 15/3/5.
//  Copyright (c) 2015年 www.gzspark.net. All rights reserved.
//

#import "MABaseViewController.h"

@class VPImageCropperViewController;

@protocol VPImageCropperDelegate <NSObject>


- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController;//委托

@end


@interface VPImageCropperViewController : MABaseViewController<UIGestureRecognizerDelegate>{
//    UIImage* smallImage;
    UIButton *confirmBtn;
}
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<VPImageCropperDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;
@property (nonatomic, assign)CGFloat lastRotation;
- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;


@end
