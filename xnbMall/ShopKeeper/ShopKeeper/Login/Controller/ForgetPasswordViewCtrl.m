//
//  ForgetPasswordViewCtrl.m
//  ShopKeeper
//
//  Created by zhough on 16/5/28.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "ForgetPasswordViewCtrl.h"
#import "TransDataProxyCenter.h"
#import "ImageSelectingview.h"

#import "JKViews.h"
#import "UIButton+WebCache.h"

@interface ForgetPasswordViewCtrl (){
    
    JKView *_vfImageBoard;
    JKView *_vcImageBtnFrameMask;
}

/** 用户从图片中搜寻的文本串  */
@property(nonatomic, copy)NSString* codeText;
/** 验证码图片的参数列表  */
@property(nonatomic, strong)  NSDictionary* getdic;
/** 图片验证交互的唯一标识  */
@property(nonatomic, copy)NSString * getkey;



@property (nonatomic, assign)NSInteger  minute;
@property (nonatomic,strong)NSTimer *TimeTravel;


@end

@implementation ForgetPasswordViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    verifyCodeType =@"0" ;
    isfirsttime = 0 ;
    //选中的图片验证码tag值
    getimagetag = 100;
    [self.view addSubview:[self viewforheader]];
    
    //图片验证码弹出选择框
    [self createVfImageBoard];
    
    
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_TimeTravel invalidate];
    _TimeTravel = nil;


}


-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [textPhone becomeFirstResponder];
}

-(UIView*)viewforheader {
    
    CGFloat lineh = 45;
    CGFloat leftw = 20;
    CGFloat labw = 70;
    
    UIView* headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, lineh*3+3)];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    
    NSArray * titlearray = @[@"手机号",@"验证码",@"新密码"];
    for (int i = 0; i<3; i++) {
        UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, lineh*(i+1), SCREEN_WIDTH , 1)];
        [viewLine setBackgroundColor:BACKGROUND_COLOR];
        [headerview addSubview:viewLine];
        
        UILabel * lab = [[UILabel alloc] init];
        lab.frame = CGRectMake(leftw, lineh*i, labw, lineh);
        [lab setFont:[UIFont systemFontOfSize:13]];
        [lab setText:titlearray[i]];
        [lab setTextColor:TEXTCURRENT_COLOR];
        [lab setTextAlignment:NSTextAlignmentLeft];
        [headerview addSubview:lab];
    
    }
    
    
    
    
    {
    
    
    
        NSString * userphone = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_PHONE];

        
        textPhone = [[UITextField alloc] initWithFrame:CGRectMake(leftw+2+labw,0,SCREEN_WIDTH  - labw- leftw*2,lineh)];
        [textPhone setPlaceholder:@"请输入手机号"];
        [textPhone setFont:[UIFont systemFontOfSize:13]];
        [textPhone setContentVerticalAlignment : UIControlContentVerticalAlignmentCenter];
        [textPhone setTextColor:TEXTVICE_COLOR];
        [textPhone setBackgroundColor:[UIColor clearColor]];
        [textPhone setKeyboardType:UIKeyboardTypeNumberPad];
        [textPhone setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [textPhone setAutocorrectionType:UITextAutocorrectionTypeNo];//不要纠错提醒
        [textPhone setClearButtonMode:UITextFieldViewModeWhileEditing];//输入时显示清除按钮
        [textPhone setSecureTextEntry:NO];//密文输入
        [textPhone setReturnKeyType:UIReturnKeyNext];
        [textPhone setDelegate:self];
        [textPhone setText:userphone];
        [textPhone addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

        [headerview addSubview:textPhone];
  
    }
 
    
    {
        textPwdnow = [[UITextField alloc] initWithFrame:CGRectMake(leftw+2+labw,lineh,SCREEN_WIDTH*2 /3 -labw- leftw*2,lineh)];
        [textPwdnow setPlaceholder:@"请输入验证码"];
        [textPwdnow setFont:[UIFont systemFontOfSize:13]];
        [textPwdnow setContentVerticalAlignment : UIControlContentVerticalAlignmentCenter];
        [textPwdnow setTextColor:TEXTVICE_COLOR];
        [textPwdnow setBackgroundColor:[UIColor clearColor]];
        [textPwdnow setKeyboardType:UIKeyboardTypeNumberPad];
        [textPwdnow setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [textPwdnow setAutocorrectionType:UITextAutocorrectionTypeNo];//不要纠错提醒
        [textPwdnow setClearButtonMode:UITextFieldViewModeWhileEditing];//输入时显示清除按钮
        [textPwdnow setSecureTextEntry:NO];//密文输入
        [textPwdnow setReturnKeyType:UIReturnKeyNext];
        [textPwdnow setDelegate:self];
        [textPwdnow addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

        [headerview addSubview:textPwdnow];
        
        btncode = [UIButton buttonWithType:UIButtonTypeCustom];
        btncode.frame = CGRectMake(SCREEN_WIDTH*2/3 ,lineh +7,SCREEN_WIDTH/4+leftw,30);
        btncode.backgroundColor = [UIColor whiteColor];
        [btncode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [btncode setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btncode.titleLabel.font = [UIFont systemFontOfSize:13];
        [btncode.layer setCornerRadius:5];
        [btncode.layer setBorderWidth:1];
        [btncode.layer setBorderColor:ColorFromHex(0xec584e).CGColor];
        [btncode addTarget:self action:@selector(getcodeclick:) forControlEvents:UIControlEventTouchUpInside];
        [headerview addSubview:btncode];
        
        
    }
    
    {
        textPwdnew = [[UITextField alloc] initWithFrame:CGRectMake(leftw+2+labw, lineh*2,SCREEN_WIDTH-labw - leftw*2,lineh)];
        [textPwdnew setPlaceholder:@"请输入新密码"];
        [textPwdnew setFont:[UIFont systemFontOfSize:13]];
        [textPwdnew setTextColor:TEXTVICE_COLOR];
        [textPwdnew setContentVerticalAlignment : UIControlContentVerticalAlignmentCenter];
        [textPwdnew setBackgroundColor:[UIColor clearColor]];
        [textPwdnew setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [textPwdnew setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [textPwdnew setAutocorrectionType:UITextAutocorrectionTypeNo];//不要纠错提醒
        [textPwdnew setClearButtonMode:UITextFieldViewModeWhileEditing];//输入时显示清除按钮
        [textPwdnew setSecureTextEntry:YES];//密文输入
        [textPwdnew setReturnKeyType:UIReturnKeyNext];
        [textPwdnew setDelegate:self];
        [headerview addSubview:textPwdnew];
    }
    
    {
        
        UIColor *color = ColorFromHex(0xec584e);
        
        UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        Btn.frame = CGRectMake(20, 30+lineh*3, SCREEN_WIDTH - 40,40);
        [Btn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [Btn setTitle:@"确认" forState:UIControlStateNormal];
        [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        Btn.titleLabel.font = [UIFont systemFontOfSize:18.f];
        [Btn setBackgroundColor:color];
        [Btn.layer setCornerRadius:5];
        [Btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [self.view addSubview:Btn];
        
    }
    
    return headerview;
}

#pragma  - mark 图片验证码弹出框


- (void)createVfImageBoard {
    
    CGFloat boardW =265.f;
    _vfImageBoard = [[JKView alloc] initWithFrame:CGRectMake(2.f, 50, boardW, 80.f)];
    
    CGFloat imageContentViewW = 265.f;
    CGFloat btnX = 0.f;
    CGFloat btnY = 0.f;
    CGFloat btnW = imageContentViewW / 3.f;
    CGFloat btnH = 40.f;
    
    for (NSInteger i = 0; i < 6; i++) {
        
        btnX = (i % 3) * btnW;
        btnY = (i / 3) * btnH;
        
        JKButton *btn = [JKButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(vfImageBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_vfImageBoard addSubview:btn];
    }
    
    _vcImageBtnFrameMask = [[JKView alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
    _vcImageBtnFrameMask.layer.borderColor = [UIColor redColor].CGColor;
    _vcImageBtnFrameMask.layer.borderWidth = 1.f;
    [_vfImageBoard addSubview:_vcImageBtnFrameMask];
}

- (void)setVfImageBoardImages {
    
    if (imageArray != nil && imageArray.count == 6) {
        
        for (NSInteger i = 0; i < 6; i++) {
            
            NSString *key = imageArray[i];
            
            NSString *imageUrlStr = self.getdic[key];
            
            JKButton *btn = (JKButton *)[_vfImageBoard viewWithTag:100 + i];
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageUrlStr] forState:UIControlStateNormal];
        }
    }
}

//验证码输入框设置
- (void)resetVfImageBoardImages {
    for (NSInteger i = 0; i < 6; i++) {
        
        JKButton *btn = (JKButton *)[_vfImageBoard viewWithTag:100 + i];
        [btn setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

- (void)vfImageBtn:(JKButton *)btn {
    
    _vcImageBtnFrameMask.frame = btn.frame;
    
    getimagetag = btn.tag;//[100-105]
}




#pragma mark UITextFieldDelegate
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (![textPhone isExclusiveTouch]) {
        [textPhone resignFirstResponder];
    }
    if (![textPwdnew isExclusiveTouch]) {
        [textPwdnew resignFirstResponder];
    }
    
    if (![textPwdnow isExclusiveTouch]) {
        [textPwdnow resignFirstResponder];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    if (textField == textPhone) {
        [textPwdnow becomeFirstResponder];
        return YES;
    }

    
    if (textField == textPwdnow) {
        [textPwdnew becomeFirstResponder];
        return YES;
    }
    
    if (textField == textPwdnew) {
        
        [textPwdnew resignFirstResponder];
        return YES;
    }
    
    
    return YES;
}

-(void)textfieldresign{
    [textPwdnew resignFirstResponder];
    [textPwdnow resignFirstResponder];
    [textPhone resignFirstResponder];

}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == textPhone) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    
    if (textField == textPwdnow) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}
#pragma mark - Button event
//找回密码
-(void)BtnClicked:(id)sender{
    [self textfieldresign];
    NSString *nowpwd = textPwdnow.text ;//验证码
    NSString *newPwd = textPwdnew.text ;//密码
    
    NSString * phone = textPhone.text;
    
    if (nowpwd.length < 4) {
         [MBProgressHUD showWarn:@"请输入4位数验证码" ToView:self.view];
        return;
    }
    if (!(newPwd.length>0)) {
          [MBProgressHUD showWarn:@"请输入有效密码!" ToView:self.view];
        return;
    }
    
    
   
    NSDictionary *postdata =@{
                              @"phoneNumber":phone,
                              @"verifyCode":nowpwd,
                              @"password":newPwd,
                             // @"appType":@"1"
                              
                              };
    [MBProgressHUD showMessage:@"设置中.." ToView:self.view];
    [[NetWorkManager shareManager]netWWorkWithReqUrl:@"login/findPwd.do" ReqParam:postdata BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
        [MBProgressHUD hideHUDForView:self.view];
        if(fail_success){ //网络成功
            
            if ([dicStr[@"code"] intValue] == 200) {
                
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"成功设置密码!"  preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }]];
                [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
                
                [self presentViewController: alertController animated: YES completion: nil];
                
            }else {
                [MBProgressHUD showWarn:dicStr[@"msg"] ToView:self.view];
                
            }
            
        }else{
            
            [MBProgressHUD showError:@"网络加载失败!" ToView:self.view];
        }
    }];
  
}


//获取图片验证码
-(void)getcodeclick:(id)sender{


    NSString * phone = textPhone.text;

    if (![NSString valiMobile:phone]) {
     [MBProgressHUD showWarn:@"请输入正确的手机号!" ToView:self.view];
        return;
    }

    
    NSDictionary *postdata = @{};
    
     [MBProgressHUD showMessage:@"请求中..请稍候" ToView:self.view];
    //1.8.0 获取验证码图片参数
    [[NetWorkManager shareManager]netWWorkWithReqUrl:@"login/prepareconfusion.do" ReqParam:postdata BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
        
         [MBProgressHUD hideHUDForView:self.view];
        if(fail_success){ //网络成功
            
            if ([dicStr[@"code"] intValue] == 200) {
                self.codeText = dicStr[@"data"][@"codeText"];
                self.getdic = dicStr[@"data"][@"images"];
                self.getkey = dicStr[@"data"][@"key"];
                imageArray = [self.getdic allKeys];
                NSArray * imagelist = [self.getdic allValues];
                
                if (imagelist.count>0) {
                    //布局验证码输入框
                    [self resetVfImageBoardImages];
                    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"选择包含文字：%@的图片",self.codeText] message:@"\n\n\n\n\n"  preferredStyle:UIAlertControllerStyleAlert];
                    //添加图片验证码弹出框
                    [self setVfImageBoardImages];
                    
                    [alertController.view addSubview:_vfImageBoard];
                    
                    [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                        if (imageArray.count>0) {
                            //获取随机验证码
                            [self getVerifyCode:phone];
                        }
                        
                    }]];
                    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController: alertController animated: YES completion: nil];
                }
                
            }else {
                [MBProgressHUD showWarn:dicStr[@"msg"] ToView:self.view];
                
            }
            
        }else{
            
            [MBProgressHUD showError:@"网络加载失败!" ToView:self.view];
        }
    }];
 
}

// 登录获取随机图片密码 login/getVerifyCode.do
- (void)getVerifyCode:(NSString *)mobilephone {

  
    NSString * getid = imageArray[getimagetag - 100];//getimagetag = [100-105]
    
    if (![NSString valiMobile: mobilephone]) { //验证手机号
      [MBProgressHUD showWarn:@"请输入正确的手机号!" ToView:self.view];
        return;
    }

    NSString * type = @"1";//获取验证码的终端类型
    NSDictionary *postdata = @{@"verifyCodeType":verifyCodeType ,
                               @"phoneNumber":mobilephone,
                               @"appType":type,@"vid":self.getkey,@"cid":getid};
    
     [MBProgressHUD showMessage:@"请求中...请稍候" ToView:self.view];
    [[NetWorkManager shareManager]netWWorkWithReqUrl:@"login/getVerifyCode.do" ReqParam:postdata BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
         [MBProgressHUD hideHUDForView:self.view];
        if(fail_success){ //网络成功
            
            if ([dicStr[@"code"] intValue] == 200) {
                if (isfirsttime == 0) {  //是否是图片验证码
                    isfirsttime =1;
                    
                }else{
                    verifyCodeType = @"1";  //语音验证码
                }
                _minute = 60;
                _TimeTravel = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CountAction:) userInfo:nil repeats:YES
                               ];
                
                if ([verifyCodeType isEqualToString:@"0"]) {
                    [MyUtile showAlertViewByMsg:@"验证码已发送到您的手机，请注意查收" vc:self];
                    
                }else if ([verifyCodeType isEqualToString:@"1"]){
                    [MyUtile showAlertViewByMsg:@"我们正在拨打您的电话，告诉您验证码，请留意" vc:self];
                }
                
            }else {
                [MBProgressHUD showWarn:dicStr[@"msg"] ToView:self.view];
                
            }
            
        }else{
            
            [MBProgressHUD showError:@"网络加载失败!" ToView:self.view];
        }
    }];

}


//定时器
- (void)CountAction:(id)sender{
    _minute--;
    [btncode setEnabled:NO];
    [btncode setTitle:[NSString stringWithFormat:@"正在发送(%ds)",(int)_minute] forState:UIControlStateNormal];
    
    if (_minute == 0) {
        
        btncode.enabled = YES;
        [btncode setTitle:@"获取语音验证码" forState:UIControlStateNormal];
        [_TimeTravel invalidate];
        _TimeTravel = nil;
        _minute = 60;
    }
    
    
}


@end
