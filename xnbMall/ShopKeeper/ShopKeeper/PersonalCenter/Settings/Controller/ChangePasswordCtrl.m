//
//  ChangePasswordCtrl.m
//  ShopKeeper
//
//  Created by zhough on 16/5/28.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "ChangePasswordCtrl.h"
#import "ImageSelectingview.h"
#import "TransDataProxyCenter.h"

#import "JKViews.h"
#import "UIButton+WebCache.h"

@interface ChangePasswordCtrl () {
    
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

@implementation ChangePasswordCtrl

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
    [self setTitle:@"变更手机号"];
    
    
    [self.view addSubview:[self viewforheader]];
    
    verifyCodeType =@"0" ;
    isfirsttime = 0 ;
    getimagetag = 100;
    
    //图片验证码弹出选择框
    [self createVfImageBoard];
   
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [textPwdnow becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];



}

-(UIView*)viewforheader {
    
    CGFloat lineh = 45;
    CGFloat leftw = 20;
    
    CGFloat labw = 70;

    UIView* headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 123)];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    
    NSArray * titlearray = @[@"手机号",@"验证码",@"新密码"];

    for (int i = 0; i<2; i++) {
        UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, lineh*(i+1), SCREEN_WIDTH , 1)];
        [viewLine setBackgroundColor:ColorFromRGB(230, 230, 230)];
        [headerview addSubview:viewLine];
        
        
        UILabel * lab = [[UILabel alloc] init];
        lab.frame = CGRectMake(leftw, lineh*i, labw, lineh);
        [lab setFont:[UIFont systemFontOfSize:12]];
        [lab setText:titlearray[i]];
        [lab setTextColor:ColorFromHex(0x646464)];
        [lab setTextAlignment:NSTextAlignmentLeft];
        [headerview addSubview:lab];

    }

    {
        textPwdnow = [[UITextField alloc] initWithFrame:CGRectMake(leftw+2+labw,0,SCREEN_WIDTH-labw - leftw*2,lineh)];
        [textPwdnow setPlaceholder:@"请输入更换后的手机号"];
        [textPwdnow setFont:[UIFont boldSystemFontOfSize:14]];
        [textPwdnow setContentVerticalAlignment : UIControlContentVerticalAlignmentCenter];
        [textPwdnow setTextColor:ColorFromHex(0x646464)];
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
    }
    
    {
        textPwdnew = [[UITextField alloc] initWithFrame:CGRectMake(leftw+2+labw,lineh,SCREEN_WIDTH*2 /3-labw - leftw*2,lineh)];
        [textPwdnew setPlaceholder:@"请输入验证码"];
        [textPwdnew setFont:[UIFont boldSystemFontOfSize:14]];
        [textPwdnew setContentVerticalAlignment : UIControlContentVerticalAlignmentCenter];
        [textPwdnew setTextColor:ColorFromHex(0x646464)];
        [textPwdnew setBackgroundColor:[UIColor clearColor]];
        [textPwdnew setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [textPwdnew setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [textPwdnew setAutocorrectionType:UITextAutocorrectionTypeNo];//不要纠错提醒
        [textPwdnew setClearButtonMode:UITextFieldViewModeWhileEditing];//输入时显示清除按钮
        [textPwdnew setSecureTextEntry:NO];//密文输入
        [textPwdnew setReturnKeyType:UIReturnKeyNext];
        [textPwdnew setDelegate:self];
        [textPwdnew addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        [headerview addSubview:textPwdnew];
        
        btncode = [UIButton buttonWithType:UIButtonTypeCustom];
        btncode.frame = CGRectMake(SCREEN_WIDTH*2/3 ,lineh +7,SCREEN_WIDTH/4+leftw,30);
        btncode.backgroundColor = [UIColor whiteColor];
        [btncode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [btncode setTitleColor:ColorFromHex(0xec584e) forState:UIControlStateNormal];
        btncode.titleLabel.font = [UIFont systemFontOfSize:13];
        [btncode.layer setCornerRadius:5];
        [btncode.layer setBorderWidth:1];
        [btncode.layer setBorderColor:ColorFromHex(0xec584e).CGColor];
        [btncode addTarget:self action:@selector(getcodeclick:) forControlEvents:UIControlEventTouchUpInside];
        [headerview addSubview:btncode];

    }
    
    {
        
        UIColor *color = ColorFromHex(0xec584e);

        UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        Btn.frame = CGRectMake(SCREEN_WIDTH/4, 150, SCREEN_WIDTH/2,40);
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





#pragma mark - Button event

-(void)BtnClicked:(id)sender{
     
    [self textfieldresign];
    NSString *phone = textPwdnow.text ;//手机号
    NSString *newPwd = textPwdnew.text ;//
    
    
    if (newPwd.length < 4) {
        
        [MBProgressHUD showWarn:@"请输入4位数验证码" ToView:self.view];
        return;
    }
    if (![NSString valiMobile:phone]) {
        
        [MBProgressHUD showWarn:@"请输入正确的手机号!" ToView:self.view];
        return;
    }
    
    [MBProgressHUD showMessage:@"请求中.." ToView:self.view];
    NSDictionary *postdata =@{
                              @"phoneNumber":phone,
                              @"verifyCode":newPwd
                              };
      
    [[NetWorkManager shareManager]netWWorkWithReqUrl:@"user/resetphonenumber.do" ReqParam:postdata BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
        [MBProgressHUD hideHUDForView:self.view];
        if(fail_success){ //网络成功
            
            if ([dicStr[@"code"] intValue] == 200) {
                
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:dicStr[@"msg"]  preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
                    
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



-(void)delayMethod{
    [self.navigationController popViewControllerAnimated:YES];


}


 //1.8.0 获取验证码图片参数
-(void)getcodeclick:(id)sender{
 
     NSString * phone = textPwdnow.text;
    
    if (![NSString valiMobile:phone]) {
        [MBProgressHUD showWarn:@"请输入正确的手机号!" ToView:self.view];
        return;
    }
    
    [MBProgressHUD showMessage:@"请求中.." ToView:self.view];
    
    NSDictionary *postdata = @{};
   
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
     
     
//8.2.2 变更手机号时获取验证码 2016-11-26替换为: getVerifyCodeForChangePhone.do
- (void)getVerifyCode:(NSString *)mobilephone {
         
         NSString * getid = imageArray[getimagetag - 100];//getimagetag = [100-105]
         
         if (![NSString valiMobile: mobilephone]) { //验证手机号
             [MBProgressHUD showWarn:@"请输入正确的手机号!" ToView:self.view];
             
             return;
         }
         
         //获取验证码的终端类型 0，文本；1，语音
          //vid :        图片验证码参数包的key
          //cid :        用户选中的验证码图片id
          
         NSDictionary *postdata = @{@"verifyCodeType":verifyCodeType ,
                                    @"phoneNumber":mobilephone,
                                    @"vid":self.getkey,@"cid":getid};
         
         [MBProgressHUD showMessage:@"请求中.." ToView:self.view];
         [[NetWorkManager shareManager]netWWorkWithReqUrl:@"user/getVerifyCodeForChangePhone.do" ReqParam:postdata BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
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
                     
                     [MyUtile showAlertViewByMsg:dicStr[@"msg"] vc:self];
                 }
                 
             }else{
                 
                 [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
             }
         }];
}
     
     
- (void)CountAction:(id)sender{
    _minute--;
    [btncode setEnabled:NO];
    [btncode setTitle:[NSString stringWithFormat:@"正在发送(%ds)",(int)_minute] forState:UIControlStateNormal];
    if (_minute == 0) {
        
        btncode.enabled = YES;
        //        btncode.backgroundColor = [UIColor colorWithRed:4 /255.0 green:139 /255.0 blue:220 /255.0 alpha:1.0];
        [btncode setTitle:@"获取语音验证码" forState:UIControlStateNormal];
        [_TimeTravel invalidate];
        _TimeTravel = nil;
        _minute = 60;
    }
}

#pragma  mark - UITextFieldDelegate

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == textPwdnow) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    
    if (textField == textPwdnew) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (![textPwdnew isExclusiveTouch]) {
        [textPwdnew resignFirstResponder];
    }
    
    if (![textPwdnow isExclusiveTouch]) {
        [textPwdnow resignFirstResponder];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
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
    
}







@end
