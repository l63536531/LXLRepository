//
//  GetAddressViewCtr.h
//  ShopKeeper
//
//  Created by zhough on 16/6/3.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface GetAddressViewCtr : MABaseViewController<UIGestureRecognizerDelegate,UIPopoverPresentationControllerDelegate>{

    UILabel* lab;
}

@property(nonatomic ,strong) NSString * textstring;
@end
