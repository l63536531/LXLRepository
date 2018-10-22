//
//  NicknameChangeCtrl.h
//  ShopKeeper
//
//  Created by zhough on 16/5/28.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface NicknameChangeCtrl : MABaseViewController<UITextFieldDelegate>{

    UITextField* textnickName;//昵称

}

@property (nonatomic) UIButton *finishBtn;
@property (nonatomic , copy) NSString* nickname;


@end
