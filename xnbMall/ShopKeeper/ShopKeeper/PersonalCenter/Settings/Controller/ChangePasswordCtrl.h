//
//  ChangePasswordCtrl.h
//  ShopKeeper
//
//  Created by zhough on 16/5/28.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface ChangePasswordCtrl : MABaseViewController<UITextFieldDelegate>{
    
    
    UITextField* textPwdnow;//当前密码
    UITextField* textPwdnew;//密码
    
    UIButton * btncode;//获取认证码

    NSArray* imageArray;
    NSInteger getimagetag;
    
    NSString* verifyCodeType;
    NSInteger isfirsttime;
    
}


@end
