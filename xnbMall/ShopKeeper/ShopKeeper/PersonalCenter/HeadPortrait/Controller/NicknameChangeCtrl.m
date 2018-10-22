//
//  NicknameChangeCtrl.m
//  ShopKeeper
//
//  Created by zhough on 16/5/28.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "NicknameChangeCtrl.h"
#import "TransDataProxyCenter.h"

@interface NicknameChangeCtrl ()

@end

@implementation NicknameChangeCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"修改昵称"];
    [self.view setBackgroundColor:ColorFromHex(0xe5e5e5)];
    [self makemianview];


}
-(void)makemianview{

    
    UIView * bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    bgview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgview];
    
    
    textnickName = [[UITextField alloc] initWithFrame:CGRectMake(20,0,SCREEN_WIDTH - 30,45)];
    [textnickName setPlaceholder:@"请输入昵称"];
//    textnickName.text = @"昵称";
    [textnickName setFont:[UIFont systemFontOfSize:12]];
    [textnickName setContentVerticalAlignment : UIControlContentVerticalAlignmentCenter];
    [textnickName setTextColor:[UIColor grayColor]];
    [textnickName setBackgroundColor:[UIColor clearColor]];
    [textnickName setKeyboardType:UIKeyboardTypeDefault];
    [textnickName setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [textnickName setAutocorrectionType:UITextAutocorrectionTypeNo];//不要纠错提醒
    [textnickName setClearButtonMode:UITextFieldViewModeWhileEditing];//输入时显示清除按钮
    [textnickName setSecureTextEntry:NO];//密文输入
    [textnickName setReturnKeyType:UIReturnKeyDone];
    [textnickName setDelegate:self];
    
    [bgview addSubview:textnickName];


    [textnickName becomeFirstResponder];
    
    UIColor *color = ColorFromHex(0xec584e);

    _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_finishBtn setBackgroundColor:color];
    [_finishBtn setFrame:CGRectMake(SCREEN_WIDTH/4,90, SCREEN_WIDTH/2, 40)];
    [_finishBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_finishBtn.layer setCornerRadius:5.];
    [_finishBtn addTarget:self action:@selector(finishclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_finishBtn];


}
-(void)finishclick:(id)sender{
    [textnickName resignFirstResponder];

   __block NSString* getnickname = textnickName.text;
    if (getnickname.length>0) {
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showWithStatus:@"请求修改中..."];

        [[TransDataProxyCenter shareController] queryNickName:getnickname block:^(NSDictionary *dic, NSError *error) {
            
            NSNumber* code = dic[@"code"];
            NSString* msg = [error localizedDescription];
            
            if ([code intValue]  == 200) {
                NSLog(@"成功");
                
                [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:NETWORKNAME object:getnickname];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                });
                
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                    
                    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"提示"                                                                           message:msg  preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleCancel handler:nil]];
                    
                    [self presentViewController: alertController animated: YES completion: nil];
                    
                    
                });
                
            }

            
            
            
        }];

    }else{
    
        [SVProgressHUD dismiss];
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"提示"                                                                           message:@"昵称不能为空"  preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController: alertController animated: YES completion: nil];
    
    }
    
    
   
    
    

}

#pragma mark UITextFieldDelegate
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (![textnickName isExclusiveTouch]) {
        [textnickName resignFirstResponder];
    }
    
    
    
    
    
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == textnickName) {
        [textnickName resignFirstResponder];
        return YES;
    }
    
    
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
