//
//  LoginViewController.m
//  InnWaiter
//
//  Created by oracle on 16/5/10.
//  Copyright © 2016年 51xnb. All rights reserved.
//

#import "LoginViewController.h"
#import "BlocksKit.h"
#import "BlocksKit+UIKit.h"
#import "TransDataProxy2.h"
#import "AppDelegate.h"
#import "ForgetPasswordViewCtrl.h"
#import "NSString+Utils.h"
#import "ShareUnity.h"
#import "UserInfo.h"
#import "TransDataProxyCenter.h"
#import "ImageSelectingview.h"
#import "RegisterViewController.h"
#import "ViewController.h"

#import "JKViews.h"
#import "UIButton+WebCache.h"

#import "JKURLSession.h"

#define CELL_HEIGHT 50
#define INPUT_X 110
#define BTN_GET_RADOM_WIDTH 80
#define WAIT_TIME 60

@interface LoginViewController () {
    UITextField* textPhone, *textPwd;
    MBProgressHUD* HUD;
    
    UIButton* btnRadom;
    
    NSTimer *getcodetime;
    NSInteger timeback;
    
    NSArray* imageArray;
    NSInteger getimagetag;
    
    NSString* verifyCodeType;
    NSInteger isfirsttime;

    JKView *_vfImageBoard;
    JKView *_vcImageBtnFrameMask;
 
}

/** 用户从图片中搜寻的文本串  */
@property(nonatomic, copy)NSString* codeText;
/** 验证码图片的参数列表  */
@property(nonatomic, strong)  NSDictionary* getdic;
/** 图片验证交互的唯一标识  */
@property(nonatomic, copy)NSString * getkey;

@end

@implementation LoginViewController

#pragma mark - LifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]];
    //选中的图片验证码tag值
    getimagetag = 100;

    [self setTitle:@"用户登录"];
    
    self.navigationController.navigationBar.barTintColor = HEXCOLOR(0xEE2C2Cff);    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    UIView* inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, FRAME_WIDTH, CELL_HEIGHT * 2)];
    [inputView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:inputView];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT - 0.5, FRAME_WIDTH, 1)];
    [line setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]];
    [inputView addSubview:line];
    
    UILabel* labelPhone = [self createLabel:CGRectMake(VIEW_INTER, 0, INPUT_X - VIEW_INTER*2, CELL_HEIGHT)];
    [labelPhone setText:@"手机号"];
    [inputView addSubview:labelPhone];
    
    textPhone = [self createTextField:CGRectMake(INPUT_X, 0, self.view.frame.size.width - INPUT_X, CELL_HEIGHT)];
    [textPhone setPlaceholder:@"请输入手机号"];
    [textPhone setKeyboardType:UIKeyboardTypeNumberPad];
    [inputView addSubview:textPhone];

    CGFloat btnX = FRAME_WIDTH - VIEW_INTER - BTN_GET_RADOM_WIDTH;
    btnRadom = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRadom setTag:0];//短信
    [btnRadom setFrame:CGRectMake(btnX, CELL_HEIGHT + 10, BTN_GET_RADOM_WIDTH, CELL_HEIGHT - 20)];
    [btnRadom setBackgroundColor:[UIColor clearColor]];
    [btnRadom.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [btnRadom setTitle:@"获取随机密码" forState:UIControlStateNormal];
    [btnRadom setTitleColor:ColorFromHex(0xec584e) forState:UIControlStateNormal];
    btnRadom.layer.borderWidth = 1;
    btnRadom.layer.borderColor = ColorFromHex(0xec584e).CGColor;
    btnRadom.layer.cornerRadius = 3;
    btnRadom.layer.masksToBounds = YES;
    
    [btnRadom addTarget:self action:@selector(getRandomCode:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:btnRadom];
    
    
    
    UILabel* labelPwd = [self createLabel:CGRectMake(VIEW_INTER, CELL_HEIGHT, INPUT_X - VIEW_INTER*2, CELL_HEIGHT)];
    [labelPwd setText:@"密码"];
    [inputView addSubview:labelPwd];
    
    textPwd = [self createTextField:CGRectMake(INPUT_X, CELL_HEIGHT, self.view.frame.size.width - INPUT_X - BTN_GET_RADOM_WIDTH - VIEW_INTER, CELL_HEIGHT)];
    [textPwd setPlaceholder:@"请输入密码"];
    [textPwd setKeyboardType:UIKeyboardTypeNumberPad];
    [textPwd setSecureTextEntry:YES];
    [inputView addSubview:textPwd];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(VIEW_INTER, inputView.frame.origin.y + inputView.frame.size.height + 10, FRAME_WIDTH - VIEW_INTER * 2, 40)];
    [btn setBackgroundColor:[MyUtile getSystemMainColor]];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:COMMON_VIEW_ALPHA] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(loginBtn) forControlEvents:UIControlEventTouchUpInside];
    
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
    
    CGFloat btnWidth = 80;
    CGFloat x = FRAME_WIDTH - btnWidth - VIEW_INTER;
    
    UIButton* btnregister = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnregister setFrame:CGRectMake(0, btn.frame.origin.y + btn.frame.size.height + 10, btnWidth, 30)];
    [btnregister setBackgroundColor:[UIColor clearColor]];
    [btnregister setTitle:@"注册" forState:UIControlStateNormal];
    [btnregister setTitleColor:[UIColor colorWithRed:110.0/255.0 green:110.0/255.0 blue:110.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btnregister addTarget:self action:@selector(registerBtn) forControlEvents:UIControlEventTouchUpInside];
    btnregister.titleLabel.font = FONT_HEL(14.f);
    
    [self.view addSubview:btnregister];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtn)];
    
    UIButton* btnForget = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnForget setFrame:CGRectMake(x, btn.frame.origin.y + btn.frame.size.height + 10, btnWidth, 30)];
    [btnForget setBackgroundColor:[UIColor clearColor]];
    [btnForget setTitle:@"忘记密码" forState:UIControlStateNormal];
    [btnForget setTitleColor:[UIColor colorWithRed:110.0/255.0 green:110.0/255.0 blue:110.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btnForget addTarget:self action:@selector(forgetPswdBtn) forControlEvents:UIControlEventTouchUpInside];
    btnForget.titleLabel.font = FONT_HEL(14.f);
    
    [self.view addSubview:btnForget];
    
    NSString* phone = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_PHONE];
    if(phone != nil && phone.length > 0){
        [textPhone setText:phone];
    }
    
    //图片验证码弹出框
    [self createVfImageBoard];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *sysConfig = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [sysConfig objectForKey:@"CFBundleVersion"];
    
    NSString *getversion = [MyUtile getStringFromUserDefault:@"Version" key:@"version"];
    if (getversion == nil || ![getversion isEqualToString:version]) {
        
    }else{
        [textPhone becomeFirstResponder];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
    
}

#pragma mark - CreateUI
// 图片验证码弹出框
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


#pragma mark - Touch events

-(void)cancelBtn{
    
    [textPhone resignFirstResponder];
    [textPwd resignFirstResponder];

    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}

//获取验证码点击
- (void)getRandomCode:(id)sender {
    [textPhone resignFirstResponder];
    [textPwd resignFirstResponder];
    NSString * mobilephone = textPhone.text;
   
    if (![NSString valiMobile:mobilephone]) {
          [MBProgressHUD showWarn:@"请输入正确的手机号!" ToView:self.view];
        return;
    }
    //获取图片验证码
    [self requestRandomCode:mobilephone];
}

- (void)loginBtn {
    
    if(![NSString valiMobile:textPhone.text]){
         [MBProgressHUD showWarn:@"请输入正确的手机号!" ToView:self.view];
        return;
      }
    
   if(textPwd.text == nil && textPwd.text.length < 6){

         [MBProgressHUD showWarn:@"请输入密码!" ToView:self.view];
        return;
    }
   
    [self.view endEditing:YES];
    
    [self requestLogin];
}

- (void)registerBtn {
    RegisterViewController* vc = [[RegisterViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)forgetPswdBtn {
    ForgetPasswordViewCtrl* vc = [[ForgetPasswordViewCtrl alloc]init];
    vc.title = @"找回密码";
    //[self.navigationController pushViewController:vc animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Custom task

- (UILabel*) createLabel:(CGRect)rect{
    UILabel* label = [[UILabel alloc] initWithFrame:rect];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setFont:[UIFont systemFontOfSize:16]];
    
    return label;
}

- (UITextField*) createTextField:(CGRect)rect{
    UITextField* textField = [[UITextField alloc]initWithFrame:rect];
    [textField setBackgroundColor:[UIColor clearColor]];
    [textField setTextAlignment:NSTextAlignmentLeft];
    [textField setTextColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0]];
    [textField setValue:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [textField setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [textField setReturnKeyType:UIReturnKeyNext];
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];//输入时显示清除按钮
    [textField setDelegate:nil];
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    return  textField;
}

-(void)countdown{
    timeback--;
    [btnRadom setTitle:[NSString stringWithFormat:@"%ds",(int)timeback] forState:UIControlStateNormal];
    
    if(timeback== 0 ){
        btnRadom.enabled = YES;
        [btnRadom setTitle:@"获取语音验证码" forState:UIControlStateNormal];
        [btnRadom setTag:1];//语音
        [getcodetime invalidate];
        getcodetime = nil;
        timeback = WAIT_TIME ;
    }
}

#pragma mark -

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == textPhone) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    
    if (textField == textPwd) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}

#pragma mark - Http request
//获取图片验证码
- (void)requestRandomCode:(NSString *)mobilephone {
    
    [MBProgressHUD showMessage:@"请求中...请稍候" ToView:self.view];
    
    NSDictionary *postdata = @{};
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
                    //添加Button
                    
                    [self setVfImageBoardImages];
                    
                    [alertController.view addSubview:_vfImageBoard];
                    
                    [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                        if (imageArray.count>0) {
                            
                            //获取随机验证码
                            [self getVerifyCode:mobilephone];
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


// 登录获取随机密码 login/getVerifyCode.do
- (void)getVerifyCode:(NSString *)mobilephone {

    NSString * getid = imageArray[getimagetag - 100];//getimagetag = [100-105]
    
    if (![NSString valiMobile: mobilephone]) { //验证手机号
    [MBProgressHUD showWarn:@"请输入正确的手机号!" ToView:self.view];
        
        return;
    }
    
    NSString * type = @"1";//获取验证码的类型
    
    NSDictionary *postdata = @{@"verifyCodeType":[NSString stringWithFormat:@"%ld",btnRadom.tag] ,
                               @"phoneNumber":mobilephone,
                               @"appType":type,@"vid":self.getkey,@"cid":getid};
    
    
      [MBProgressHUD showMessage:@"登录中.." ToView:self.view];
  
    [[NetWorkManager shareManager]netWWorkWithReqUrl:@"login/getVerifyCode.do" ReqParam:postdata BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
        [MBProgressHUD hideHUDForView:self.view];
        if(fail_success){ //网络成功
            
            if ([dicStr[@"code"] intValue] == 200) {
                timeback = WAIT_TIME;
                btnRadom.enabled = NO;
                
                if (btnRadom.tag == 0) {
                    [MyUtile showAlertViewByMsg:@"验证码已发送到您的手机，请注意查收" vc:self];
                    
                }else if (btnRadom.tag == 1){
                    [MyUtile showAlertViewByMsg:@"我们正在拨打您的电话，告诉您验证码，请留意" vc:self];
                }
                //开启定时器执行
                [NSTimer bk_scheduledTimerWithTimeInterval:1.0 block:^(NSTimer *timer) {
                    timeback--;
                    [btnRadom setTitle:[NSString stringWithFormat:@"%ds",(int)timeback] forState:UIControlStateNormal];
                    if(timeback== 0 ){
                        btnRadom.enabled = YES;
                        [btnRadom setTitle:@"获取语音验证码" forState:UIControlStateNormal];
                        [btnRadom setTag:1];//语音
                        [timer invalidate];
                    }
                } repeats:YES];
                
                
            }else{
                [MBProgressHUD showWarn:dicStr[@"msg"] ToView:self.view];
            }
        }else{
            
            [MBProgressHUD showError:@"网络加载失败!" ToView:self.view];
        }
    }];
    
}

- (void)requestLogin {
    
    NSDictionary *postdata = @{@"username":textPhone.text,
                               @"password":textPwd.text,
                               @"appType":@"1"};
    
    [JKURLSession taskWithMethod:@"login/login2.do" parameter:postdata token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
         NSString *userId = resultDic[@"data"][@"userid"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [HUD hideAnimated:YES];
            
            if (error == nil) {

                [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:LOGIN_NAME object:userId];
                [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:LOGIN_PHONE object:textPhone.text];
                [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:MALL_IS_LOGIN object:@"这里没有token,token在initshop接口返回，所以不能用token判断是否登录"];
                
                if (_loginResultBlockBeforeDissmiss != nil) {
                    if (_loginResultBlockBeforeDissmiss != nil) {
                        _loginResultBlockBeforeDissmiss(YES);
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController dismissViewControllerAnimated:YES completion:^{ }];
                    });
                }else {
                    [self.navigationController dismissViewControllerAnimated:YES completion:^{
                        
                        if (_loginResultBlock != nil) {
                            _loginResultBlock(YES);
                        }
                    }];
                }
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"USERLOGIN" object:nil];
            }else {
                [MyUtile showAlertViewByMsg:error.localizedDescription vc:self];
            }
        });
    }];
}


@end
