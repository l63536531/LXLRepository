//
//  AddBankCardViewCtrl.m
//  ShopKeeper
//
//  Created by zhough on 16/5/31.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "AddBankCardViewCtrl.h"

#import "TransDataProxyCenter.h"

@interface AddBankCardViewCtrl ()

@end

@implementation AddBankCardViewCtrl
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"添加银行卡"];
    [self.view setBackgroundColor:ColorFromRGB(240, 240, 240)];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"　"
                                                                             style:(UIBarButtonItemStylePlain)
                                                                            target:nil
                                                                            action:nil];
    
    CGRect rect = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT);
    
    mianTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    mianTableView.scrollEnabled = YES;
    mianTableView.bounces = NO;
    mianTableView.delegate = (id<UITableViewDelegate>)self;
    mianTableView.dataSource = (id<UITableViewDataSource>)self;
    [mianTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    mianTableView.allowsSelection = YES;
    mianTableView.showsVerticalScrollIndicator = NO;
    [mianTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:mianTableView];
    
    mianTableView.tableFooterView = [self makefootview];
    
    
    UITapGestureRecognizer* singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClickEvent:)];
    singleFingerOne.numberOfTouchesRequired = 1;
    singleFingerOne.numberOfTapsRequired = 1;
    singleFingerOne.delegate = self;
    [mianTableView addGestureRecognizer:singleFingerOne];

}





#pragma mark -- 添加银行卡

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
    
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}



- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    
    UITableViewCell* cell = [[UITableViewCell alloc]init];
    
    
    CGFloat leftw = 15;
    CGFloat labw = 100;
    
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
    [line setBackgroundColor:ColorFromRGB(240, 240, 240)];
    [cell.contentView addSubview:line];
    
    NSArray * titlearray = @[@"银行卡号",@"开户行",@"开户名",@"身份证号",@"确认身份证号"];
    UILabel * titlename = [[UILabel alloc] init];
    [titlename setFrame:CGRectMake(leftw, 0, labw, 50)];
    [titlename setBackgroundColor:[UIColor clearColor]];
    [titlename setTextColor:KFontColor(@"#646464")];
    [titlename setTextAlignment:NSTextAlignmentLeft];
    [titlename setFont:[UIFont systemFontOfSize:16]];
    [titlename setText:[titlearray objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:titlename];
    
    NSArray* placeholderarray = @[@"请输入您的银行卡号",@"请输入开户行",@"请输入开户名",@"请输入您的身份证号",@"请确认身份证号"];
    switch (indexPath.row) {
        case BANK_CARD:
            
        {
            bankcardtext = [self createTextField:CGRectMake(labw+20, 0, SCREEN_WIDTH - 30 - labw, 50) placeholder:[placeholderarray objectAtIndex:indexPath.row] SecureTextEntry:NO];
            [cell.contentView addSubview:bankcardtext];
        
        }
            
            break;
            
        case BANK_NAME:
        {
            banktext = [self createTextField:CGRectMake(labw+20, 0, SCREEN_WIDTH - 30 - labw, 50) placeholder:[placeholderarray objectAtIndex:indexPath.row] SecureTextEntry:NO];
            [cell.contentView addSubview:banktext];
            
        }
            break;
        case CARD_NAME:
        {
            nametext = [self createTextField:CGRectMake(labw+20, 0, SCREEN_WIDTH - 30 - labw, 50) placeholder:[placeholderarray objectAtIndex:indexPath.row] SecureTextEntry:NO];
            [cell.contentView addSubview:nametext];
            
        }
            break;
        case NAME_IDONE:
        {
            Idcardone = [self createTextField:CGRectMake(labw+20, 0, SCREEN_WIDTH - 30 - labw, 50) placeholder:[placeholderarray objectAtIndex:indexPath.row] SecureTextEntry:NO];
            [cell.contentView addSubview:Idcardone];
            
        }
            break;
        case NAME_IDTWO:
        {
            Idcardtwo = [self createTextField:CGRectMake(labw+20, 0, SCREEN_WIDTH - 30 - labw, 50) placeholder:[placeholderarray objectAtIndex:indexPath.row] SecureTextEntry:NO];
            [cell.contentView addSubview:Idcardtwo];
            
        }
            break;
            
        default:
            break;
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;

    
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"cell");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(UITextField*)createTextField:(CGRect)rect placeholder:(NSString*)holderstring SecureTextEntry:(BOOL)entrybool {

    
    UITextField*  textfield = [[UITextField alloc] initWithFrame:rect];
    [textfield setPlaceholder:holderstring];
    [textfield setFont:[UIFont boldSystemFontOfSize:16]];
    [textfield setContentVerticalAlignment : UIControlContentVerticalAlignmentCenter];
    [textfield setTextColor:[UIColor grayColor]];
    [textfield setBackgroundColor:[UIColor clearColor]];
    [textfield setKeyboardType:UIKeyboardTypeDefault];
    [textfield setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [textfield setAutocorrectionType:UITextAutocorrectionTypeNo];//不要纠错提醒
    [textfield setClearButtonMode:UITextFieldViewModeWhileEditing];//输入时显示清除按钮
    [textfield setSecureTextEntry:entrybool];//密文输入
    [textfield setReturnKeyType:UIReturnKeyNext];
    [textfield setDelegate:self];
    textfield.adjustsFontSizeToFitWidth = YES;
    return textfield;
}

-(UIView*)makefootview{

    UIView * bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    [bgview setBackgroundColor:[UIColor clearColor]];
    
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(SCREEN_WIDTH/4 , 30, SCREEN_WIDTH/2, 40)];
    btn.backgroundColor = KBackColor(@"#ec584c");
    [btn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.layer setCornerRadius:5];
    [bgview addSubview:btn];


    return bgview;

}


#pragma mark UITextFieldDelegate
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (![bankcardtext isExclusiveTouch]) {
        [bankcardtext resignFirstResponder];
    }else if (![banktext isExclusiveTouch]) {
        [banktext resignFirstResponder];
    }else if (![nametext isExclusiveTouch]) {
        [nametext resignFirstResponder];
    }else if (![Idcardone isExclusiveTouch]) {
        [Idcardone resignFirstResponder];
    }else if (![Idcardtwo isExclusiveTouch]) {
        [Idcardtwo resignFirstResponder];
    }

    
}

-(void)closekeyboard{

        [bankcardtext resignFirstResponder];
        [banktext resignFirstResponder];
        [nametext resignFirstResponder];
        [Idcardone resignFirstResponder];
        [Idcardtwo resignFirstResponder];
    


}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == bankcardtext) {
        [banktext becomeFirstResponder];
        return YES;
    }else if (textField == banktext) {
        [nametext becomeFirstResponder];
        return YES;
    }else if (textField == nametext) {
        [Idcardone becomeFirstResponder];
        return YES;
    }else if (textField == Idcardone) {
        [Idcardtwo becomeFirstResponder];
        return YES;
    }else if (textField == Idcardtwo) {
        [Idcardtwo resignFirstResponder];
        return YES;
    }
    
    
    
    return YES;
}
#pragma mark --  点击事件
- (void)closeClickEvent:(UITapGestureRecognizer *)sender{
    //    NSInteger index = sender.view.tag;
    NSLog(@"输出");
    [self closekeyboard];

    
}
-(void)buttonclick:(id)sender{

    [self closekeyboard];
    
       
    
    NSString* bankcardstring = bankcardtext.text;
    NSString* bankstring = banktext.text;
    NSString* namestring = nametext.text;
    NSString* idcardonestring = Idcardone.text;
    NSString* idcardtwostring = Idcardtwo.text;
    
    
    if (![bankcardstring isEqualToString:@""]||[bankcardstring length] != 0) {
    
    
        if (![bankstring isEqualToString:@""]||[bankstring length] != 0) {
            
            
            if (![namestring isEqualToString:@""]||[namestring length] != 0) {
                
                if (![idcardonestring isEqualToString:@""]||[idcardonestring length] != 0) {
                    
                    
                    if (![idcardtwostring isEqualToString:@""]||[idcardtwostring length] != 0) {
                        
                        if ([idcardonestring isEqualToString:idcardtwostring]) {
                            
                            
                            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                            [SVProgressHUD showWithStatus:@"提交中..."];
//                            NSString* userid = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_NAME];

                            [[TransDataProxyCenter shareController] queryBindcard:_getid bankNO:bankcardstring bankName:bankstring bankUserName:namestring IDCardNO:idcardtwostring block:^(NSDictionary *dic, NSError *error) {
                                
                                NSNumber * code = dic[@"code"];
                                NSLog(@"%d",[code intValue]);
                                NSString* msg = dic[@"msg"];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (dic ) {
                                        if ([code intValue] == 200 ) {
                                            [SVProgressHUD dismiss];
                                            
                                            [self.navigationController popViewControllerAnimated:YES];
                                            
                                        }else{
                                            
                                            
                                            [SVProgressHUD dismiss];
                                            [self alertTitle:nil message:msg];
                                            
                                        }

                                    }else{
                                        [SVProgressHUD dismiss];
                                        [self alertTitle:nil message:@"请检查网络"];

                                    
                                    }
                                    

                                });
                                
                                
                                
                            }];

                            
                            
                            
                            
                        }else{
                          
                            [self alertTitle:@"两次输入的身份证号不一样" message:@"请重新输入身份证号"];

                        }
                        
                        
                        
                    }else{
                        
                        [self alertTitle:nil message:@"请再次输入身份证号"];

                    }

                    
                    
                }else{
                    
                    [self alertTitle:nil message:@"请输入身份证号"];

                }

                
                
                
            }else{
                
                [self alertTitle:nil message:@"请输入开户名"];

            }

            
            
        }else{
            [self alertTitle:nil message:@"请输入开户银"];
            
        }

        
    
    }else{
    
        [self alertTitle:nil message:@"请输入您的银行卡号"];
    }
    
    
    
    
    
    
    
    
    
    
    
}


-(void)alertTitle:(NSString*)title message:(NSString*)message {
    
    
    
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title                                                                            message:message  preferredStyle:UIAlertControllerStyleAlert];
    //添加Button
    [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated: YES completion: nil];
    
}


@end
