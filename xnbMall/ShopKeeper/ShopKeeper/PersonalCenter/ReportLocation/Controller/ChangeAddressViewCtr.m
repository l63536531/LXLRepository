//
//  ChangeAddressViewCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/6/1.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "ChangeAddressViewCtr.h"
#import "TransDataProxyCenter.h"
#import "LocationView.h"
#import "ShipingAdderssModel.h"


#define NAME_TAG 101
#define PHONE_TAG 102
#define EARWDETAIL_TAG 103

@interface ChangeAddressViewCtr (){
    
    LocationView * lacationVC;
    
    
}

@property (nonatomic) NSString *proNameStr;
@property (nonatomic) NSString *cityNameStr;
@property (nonatomic) NSString *areaNameStr;
@property (nonatomic) NSString *streetNameStr;

@property (nonatomic) NSString *proIdStr;
@property (nonatomic) NSString *cityIdStr;
@property (nonatomic) NSString *areaIdStr;
@property (nonatomic) NSString *streetIdStr;


@end

@implementation ChangeAddressViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"　"
                                                                             style:(UIBarButtonItemStylePlain)
                                                                            target:nil
                                                                            action:nil];
    
    geteareArray = [NSMutableArray new];
    
    [self InitializeData];
    
    
    NSLog(@"%d",(int)geteareArray.count);
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
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(getLocationData) name:@"determineLocation" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
}



//获取定位的信息
-(void)getLocationData{
    
    
    
    _proNameStr = lacationVC.proNameStr;
    _cityNameStr = lacationVC.cityNameStr;
    _areaNameStr= lacationVC.areaNameStr;
    _streetNameStr = lacationVC.streetNameStr;
    
    _proIdStr = lacationVC.proIdStr;
    _cityIdStr = lacationVC.cityIdStr;
    _areaIdStr = lacationVC.areaIdStr;
    _streetIdStr = lacationVC.streetIdStr;
    
    
    
    
    
    [geteareArray removeAllObjects];
    if (_proNameStr != nil&&_proNameStr.length>0) {
        [geteareArray addObject:_proNameStr];
        
        if (_cityNameStr != nil&&_cityNameStr.length>0) {
            [geteareArray addObject:_cityNameStr];
            if (_areaNameStr != nil&&_areaNameStr.length>0) {
                
                [geteareArray addObject:_areaNameStr];
                
                if (_streetNameStr != nil&&_streetNameStr.length>0) {
                    [geteareArray addObject:_streetNameStr];
                }
            }
        }
    }else{
        
        
        geteareArray = [@[@"",@"",@"",@""] mutableCopy];
        
    }
    
    
    
    [mianTableView reloadData];
    
    
}


#pragma mark 初始化数据
-(void)InitializeData{
    ShipingAdderssModel* getmodel = [ShipingAdderssModel create:_getAreaDic];
    if (getmodel) {
        
        _proNameStr = getmodel.provincename;
        _cityNameStr = getmodel.cityname;
        _areaNameStr= getmodel.countyname;
        _streetNameStr = getmodel.streetname;
        
        _proIdStr = getmodel.provinceid;
        _cityIdStr = getmodel.cityid;
        _areaIdStr = getmodel.countyid;
        _streetIdStr = getmodel.streetid;
        
        
        _getphonestring = getmodel.contactPhone;
        _getnamestring = getmodel.contactName;
        _ridstring = getmodel.idD;
        _detailearestring = getmodel.address;
        _isDefault = getmodel.isDefault;
        
        
        
    }
    
    
    [geteareArray removeAllObjects];
    if (_proNameStr != nil&&_proNameStr.length>0) {
        [geteareArray addObject:_proNameStr];
        
        if (_cityNameStr != nil&&_cityNameStr.length>0) {
            [geteareArray addObject:_cityNameStr];
            if (_areaNameStr != nil&&_areaNameStr.length>0) {
                
                [geteareArray addObject:_areaNameStr];
                
                if (_streetNameStr != nil&&_streetNameStr.length>0) {
                    [geteareArray addObject:_streetNameStr];
                }
            }
        }
    }else{
        
        
        geteareArray = [@[@"",@"",@"",@""] mutableCopy];
        
    }
    
    
    NSLog(@"初始化 == %@",_proNameStr);
    
    [mianTableView reloadData];
    
    
    
    
    
    
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
    
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}



- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    UITableViewCell* cell = [[UITableViewCell alloc]init];
    
    
    CGFloat leftw = 15;
    CGFloat labw = 80;
    
    
    UIView * line = [[UIView alloc] init];
    if (indexPath.row == 2) {
        [line setFrame:CGRectMake(0, 199, SCREEN_WIDTH, 1)];
        
    }else if (indexPath.row == 3){
        [line setFrame:CGRectMake(0, 99, SCREEN_WIDTH, 1)];
        
        
    }
    
    else{
        
        [line setFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
        
    }
    [line setBackgroundColor:ColorFromRGB(230, 230, 230)];
    [cell.contentView addSubview:line];
    
    NSArray * titlearray = @[@"收货人",@"手机号码",@"所在地区",@"详细地址"];
    UILabel * titlename = [[UILabel alloc] init];
    [titlename setFrame:CGRectMake(12, 0, labw, 50)];
    [titlename setBackgroundColor:[UIColor clearColor]];
    [titlename setTextColor:ColorFromHex(0x646464)];
    [titlename setTextAlignment:NSTextAlignmentLeft];
    [titlename setFont:[UIFont systemFontOfSize:16]];
    [titlename setText:[titlearray objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:titlename];
    
    NSArray* placeholderarray = @[@"请填写收件人姓名",@"请填写手机号码",@"请输入开户名",@"请填写详细地址"];
    switch (indexPath.row) {
        case 0:
            
        {
            _nametext = [self createTextField:CGRectMake(labw+20, 0, SCREEN_WIDTH - 30 - labw, 50) placeholder:[placeholderarray objectAtIndex:indexPath.row] SecureTextEntry:NO];
            _nametext.text = _getnamestring;
            _nametext.tag = NAME_TAG;
            [_nametext addTarget:self action:@selector(textChangeAction:)
                forControlEvents:UIControlEventEditingChanged];
            [cell.contentView addSubview:_nametext];
            
        }
            
            break;
            
        case 1:
        {
            _phonetext = [self createTextField:CGRectMake(labw+20, 0, SCREEN_WIDTH - 30 - labw, 50) placeholder:[placeholderarray objectAtIndex:indexPath.row] SecureTextEntry:NO];
            _phonetext.text = _getphonestring;
            _phonetext.tag = PHONE_TAG;
            [_phonetext addTarget:self action:@selector(textChangeAction:)
                 forControlEvents:UIControlEventEditingChanged];
            [cell.contentView addSubview:_phonetext];
            
        }
            break;
        case 2:
        {
            
            
            NSArray * cityarray =@[@"省",@"市",@"区",@"街"];
            for (int i = 0; i < geteareArray.count; i++) {
                _eareText = [self createTextField:CGRectMake(labw+20, 10+50*i, SCREEN_WIDTH - 50 - labw, 30) placeholder:cityarray[i] SecureTextEntry:NO];
                [_eareText setClearButtonMode:UITextFieldViewModeNever];//输入时显示清除按钮
                [_eareText setText:geteareArray[i]];
                [_eareText.layer setBorderColor:ColorFromRGB(230, 230, 230).CGColor];
                [_eareText.layer setBorderWidth:.5];
                _eareText.tag = i;
                _eareText.rightViewMode = UITextFieldViewModeAlways;
                [_eareText setEnabled:NO];
                //                [_eareText addTarget:self action:@selector(textChangeAction:)
                //                         forControlEvents:UIControlEventEditingChanged];
                UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(SCREEN_WIDTH - 60 , 10+50*i, 30, 30)];
                btn.backgroundColor = [UIColor clearColor];
                btn.tag = i;
                [btn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setImage:[UIImage imageNamed:@"tick1"] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn.layer setCornerRadius:5];
                //                _eareText.rightView = btn;
                [cell.contentView addSubview:_eareText];
                [cell.contentView addSubview:btn];
                
                
                
                
            }
            
            
            
            
            
            
            
            
            
            
        }
            break;
        case 3:
        {
            
            
            
            
            
            _Idcardone = [[UITextView alloc] initWithFrame:CGRectMake(labw+20, 10, SCREEN_WIDTH  - labw*2, 28)]; //初始化大小并自动释放
            
            _Idcardone.textColor = ColorFromHex(0x646464);//设置textview里面的字体颜色
            _Idcardone.font = [UIFont fontWithName:@"Arial" size:14.0];//设置字体名字和字体大小
            
            _Idcardone.delegate = self;//设置它的委托方法
            
            _Idcardone.backgroundColor = [UIColor clearColor];//设置它的背景颜色
            
            _Idcardone.text = _detailearestring;//设置它显示的内容
            [_Idcardone.layer setBorderColor:ColorFromRGB(230, 230, 230).CGColor];
            [_Idcardone.layer setBorderWidth:.5];
            
            _Idcardone.returnKeyType = UIReturnKeyDefault;//返回键的类型
            
            _Idcardone.keyboardType = UIKeyboardTypeDefault;//键盘类型
            
            _Idcardone.scrollEnabled = YES;//是否可以拖动
            _Idcardone.tag = EARWDETAIL_TAG;
            
            
            
            _Idcardone.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
            
            
            [cell.contentView addSubview:_Idcardone];
            
        }
            break;
            
        default:
            break;
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
    
    
    
    
    
    
}
//下面这段搞定键盘关闭。点return 果断关闭键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    NSLog(@"%@ , %d",textView.text,(int)textView.tag);
    
    
}

#pragma mark 输入监控
-(void)textChangeAction:(id)sender{
    
    UITextField* getField = sender;
    NSLog(@"%@ , %d",getField.text,(int)getField.tag);
    
    if (getField.tag == 0) {
        if ( getField.text.length >0 ) {
            geteareArray[0] = getField.text;
            
        }else{
            geteareArray[0] = @"";
            
        }
        
    }else if (getField.tag == 1){
        if ( getField.text.length >0 ) {
            geteareArray[1] = getField.text;
            
        }else{
            geteareArray[1] = @"";
            
        }
        
    }else if (getField.tag == 2){
        if ( getField.text.length >0 ) {
            geteareArray[2] = getField.text;
            
        }else{
            geteareArray[2] = @"";
            
        }
        
    }else if (getField.tag == 3){
        
        if ( getField.text.length >0 ) {
            geteareArray[3] = getField.text;
            
        }else{
            geteareArray[3] = @"";
            
        }
    }else if (getField.tag == PHONE_TAG){
        
        if ( getField.text.length >0 ) {
            _getphonestring =  _phonetext.text ;
            
        }else{
            _getphonestring = @"";
            
        }
    }else if (getField.tag == NAME_TAG){
        
        if ( getField.text.length >0 ) {
            _getnamestring= _nametext.text ;
            
        }else{
            _getnamestring = @"";
            
        }
    }
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
        return 200;
    }else if (indexPath.row == 3){
        
        return 100;
    }else
        return 50;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"dgsfd");
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(UITextField*)createTextField:(CGRect)rect placeholder:(NSString*)holderstring SecureTextEntry:(BOOL)entrybool {
    
    
    UITextField*  textfield = [[UITextField alloc] initWithFrame:rect];
    [textfield setPlaceholder:holderstring];
    [textfield setFont:[UIFont systemFontOfSize:14]];
    [textfield setContentVerticalAlignment : UIControlContentVerticalAlignmentCenter];
    [textfield setTextColor:ColorFromHex(0x646464)];
    [textfield setBackgroundColor:[UIColor clearColor]];
    //    [textfield setKeyboardType:UIKeyboardTypeDefault];
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
    
    UIView * bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [bgview setBackgroundColor:[UIColor clearColor]];
    
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(20 , 30, SCREEN_WIDTH - 40, 30)];
    btn.backgroundColor = ColorFromHex(0xec584e);
    [btn addTarget:self action:@selector(querydate) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.layer setCornerRadius:5];
    [bgview addSubview:btn];
    
    
    return bgview;
    
}
#pragma mark 定位
-(void)buttonclick:(id)sender{
    UIButton * btn = sender;
    
    lacationVC = [[LocationView alloc] init];
    
    lacationVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    lacationVC.preferredContentSize = CGSizeMake(300, 300);
    lacationVC.popoverPresentationController.sourceView = btn;//self.button;
    lacationVC.popoverPresentationController.sourceRect = btn.bounds;
    
    UIPopoverPresentationController *pop = lacationVC.popoverPresentationController;
    pop.delegate = self;
    pop.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    [self presentViewController:lacationVC animated:YES completion:nil];
    NSLog(@"点击%d",(int)btn.tag);
    
    
}



-(void)querydate{
    
    
    
    NSString* name = _nametext.text;
    NSString* phone = _phonetext.text;
    NSString* idcard = _Idcardone.text;
    
    if (name.length == 0 || name == nil) {
        [UIAlertView showWithMessage:@"请填写收件人姓名!" cancelButtonTitle:@"确定"];
        return;
    }else if (phone.length == 0 || phone == nil) {
        [UIAlertView showWithMessage:@"请完善收件人手机号!" cancelButtonTitle:@"确定"];
        
        return;
    }
    
    // NSString* aerestring =@"广东省_广州市_天河区_林和西路";
    
    if (_isDefault == nil) {
        _isDefault = @"0";
        
    }
    
    
    NSString * getaereId = nil;
    
    
    
    if (_proIdStr != nil&&_proIdStr.length>0) {
        
        NSLog(@"getsadfs  =  %@",_proIdStr);
        
        getaereId = _proIdStr;
        
        
        if (_cityIdStr != nil&&_cityIdStr.length>0) {
            getaereId = _cityIdStr;
            if (_areaIdStr != nil&&_areaIdStr.length>0) {
                
                getaereId = _areaIdStr;
                
                if (_streetIdStr != nil&&_streetIdStr.length>0) {
                    getaereId =  _streetIdStr;
                }
            }
        }
    }
    
    NSLog(@"getsadfs  =  %@",getaereId);
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"请求中..."];
    
    [[TransDataProxyCenter shareController] queryAddaddress:_ridstring contactName:name contactPhone:phone areaId:getaereId address:idcard isDefault:_isDefault block:^(NSDictionary *dic, NSError *error) {
        NSNumber* code = dic[@"code"];
        NSString* msg = [error localizedDescription];
        if ([code intValue]  == 200) {
            NSLog(@"成功");
            
            
            
            
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil                                                                            message:@"提交成功"  preferredStyle:UIAlertControllerStyleAlert];
                //添加Button
                
                //                [alertController addAction: [UIAlertAction actionWithTitle: @"男" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //
                //                }]];
                
                [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                    if(_delegate != nil){
                        [_delegate GetNewDefultAddress];
                    }
                    
                    
                }]];
                
                [self presentViewController: alertController animated: YES completion: nil];
                
                
                
            });
            
            
        }else{
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD showWithStatus:msg];
                
                [SVProgressHUD dismissWithDelay:1];
                
            });
            
        }
        
        
        
        [SVProgressHUD dismiss];
        
        
        
    }];
    
    
    
    
    
    [mianTableView.mj_header endRefreshing];
    
    
    
    
    
}




-(void)alertTitle:(NSString*)title message:(NSString*)message {
    
    
    
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title                                                                            message:message  preferredStyle:UIAlertControllerStyleAlert];
    //添加Button
    [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated: YES completion: nil];
    
}







#pragma mark 键盘收缩处理
- (void)closeClickEvent:(UITapGestureRecognizer *)sender{
    //    NSInteger index = sender.view.tag;
    
    [_nametext resignFirstResponder];
    [_phonetext resignFirstResponder];
    NSLog(@"输出");
    [_Idcardone resignFirstResponder];
    [_eareText resignFirstResponder];
    
    
}

#pragma mark UITextFieldDelegate
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (![_nametext isExclusiveTouch]) {
        [_nametext resignFirstResponder];
    }else if (![_phonetext isExclusiveTouch]) {
        [_phonetext resignFirstResponder];
    }else if (![_eareText isExclusiveTouch]) {
        [_eareText resignFirstResponder];
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    
    if (textField == _nametext) {
        
        [_phonetext becomeFirstResponder];
        return YES;
    }else if (textField == _phonetext) {
        [_phonetext resignFirstResponder];
        return YES;
    }else if (textField == _Idcardone) {
        [_Idcardone resignFirstResponder];
        return YES;
    }else  {
        [textField resignFirstResponder];
        return YES;
    }
    
    
    return YES;
}
#pragma mark keyboard  appear

-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo//计算键盘的高度
{
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    
    return keyboardEndingFrame.size.height;
    
}

-(void)keyboardWillAppear:(NSNotification *)notification

{
    
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    
    CGRect currentFrame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT -change);;
    
    mianTableView.frame = currentFrame;
}

-(void)keyboardWillDisappear:(NSNotification *)notification

{
    
    CGRect rect = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT);
    
    mianTableView.frame = rect;
}
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"determineLocation" object:nil];
    
}


@end
