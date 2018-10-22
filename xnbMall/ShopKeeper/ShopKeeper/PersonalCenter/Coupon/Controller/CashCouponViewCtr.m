//
//  CashCouponViewCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/6/1.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "CashCouponViewCtr.h"
#import "AppDelegate.h"
#import "TransDataProxyCenter.h"

@interface CashCouponViewCtr ()<UIApplicationDelegate>
@property (nonatomic,assign)CGFloat tableOffset;
    
@property (nonatomic,assign)NSInteger indexPathRow;
@property (nonatomic,assign)BOOL could_change_frame;



@end

@implementation CashCouponViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"激活现金券"];
    [self.view setBackgroundColor:ColorFromRGB(240, 240, 240)];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"　"
                                                                             style:(UIBarButtonItemStylePlain)
                                                                            target:nil
                                                                            action:nil];
    
    
    
    
    CGRect rect = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT );
    
    
    
    
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    


    
}

- (void)keyboardWillShow:(NSNotification *)notification
{//UITableViewCell 1
   // cashcoupontext
    
    NSIndexPath  *indexPaths =[NSIndexPath indexPathForRow:1 inSection:0];
    
    UITableViewCell *cell =(UITableViewCell*)[mianTableView cellForRowAtIndexPath:indexPaths];
    CGRect bound  =[cashcoupontext convertRect:cell.bounds toView:cell.superview];
    CGRect rect =  [self.view convertRect:bound fromView:mianTableView];
    NSLog(@"%@+++",NSStringFromCGRect(rect));
    self.tableOffset= rect.origin.y+rect.size.height;
    //获取键盘高度
    CGFloat keyboardHeigh = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat offset = self.tableOffset-(SCREEN_HEIGHT-keyboardHeigh)+64;
    if (offset>0) {
        
        [UIView animateWithDuration:duration animations:^{
            mianTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeigh-40, 0);
            
        }];
        self.could_change_frame =YES;
        
    }
    
    
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    
   
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (self.could_change_frame) {
        [UIView animateWithDuration:duration animations:^{
           
            mianTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }];
        
        self.could_change_frame =NO;
        
    }
    
}

#pragma mark -- 添加银行卡

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
    
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}



- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    UITableViewCell* cell = [[UITableViewCell alloc]init];
    
    
    
    
    UIView * line = [[UIView alloc] init];
    [line setBackgroundColor:ColorFromRGB(240, 240, 240)];
//    [cell.contentView addSubview:line];
    
    
    
    
   
    switch (indexPath.row) {
        case 0:
            
        {
            UIImageView* lowimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0,SCREEN_WIDTH,SCREEN_WIDTH/9*6)];
            [lowimageView setContentMode:UIViewContentModeScaleToFill];
            [lowimageView setClipsToBounds:YES];
            [lowimageView setImage:[UIImage imageNamed:@"gift"]];
            [lowimageView setBackgroundColor:ColorFromRGB(240, 240, 240)];
            [cell addSubview:lowimageView];
 
//            line.frame = CGRectMake(0, SCREEN_WIDTH/4*3 - 1, SCREEN_WIDTH, 1);

        }
            
            break;
        case 1:
            
        {
            cashcoupontext = [self createTextField:CGRectMake(0, 0, SCREEN_WIDTH  , 50) placeholder:@"请输入您的现金券激活码" SecureTextEntry:NO];
            [cashcoupontext setKeyboardType:UIKeyboardTypeNumberPad];
            [cashcoupontext setTextAlignment:NSTextAlignmentCenter];
            [cell.contentView addSubview:cashcoupontext];
//            line.frame = CGRectMake(0, 49, SCREEN_WIDTH, 1);

        }
            
            break;
            
            
        default:
            break;
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
    
    
    
    
    
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return SCREEN_WIDTH/9*6;
    }
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
    
    UIView * bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    [bgview setBackgroundColor:[UIColor clearColor]];
    UILabel * titlename = [[UILabel alloc] init];
    
    
    [titlename setFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 50)];
    [titlename setBackgroundColor:[UIColor clearColor]];
    [titlename setTextColor:[UIColor blackColor]];
    [titlename setTextAlignment:NSTextAlignmentCenter];
    [titlename setFont:[UIFont systemFontOfSize:14]];
    [titlename setNumberOfLines:0];
    [titlename setText:@"备注：激活成功后，现金券金额将累加到您的不可提现余额中，请到我的钱包中查看"];
    [bgview addSubview:titlename];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(SCREEN_WIDTH/4, 60, SCREEN_WIDTH/2, 40)];
    btn.backgroundColor = ColorFromHex(0xec584c);
    [btn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"激活" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.layer setCornerRadius:5];
    [bgview addSubview:btn];
    
    
    return bgview;
    
}

-(void)buttonclick:(id)sender{
    [cashcoupontext resignFirstResponder];

    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"请求数据中..."];
    
    
    NSString * textstring = cashcoupontext.text;
    
    if (textstring.length>0) {
        [[TransDataProxyCenter shareController] cashcouponActivate:textstring block:^(NSDictionary *dic, NSError *error) {
            
            NSNumber * code = dic[@"code"];
            NSString * msg = dic[@"msg"];
            if ([code intValue]==200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showWithStatus:msg];
                    
                    [SVProgressHUD dismissWithDelay:1];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showWithStatus:msg];
                    
                    [SVProgressHUD dismissWithDelay:1];
                    
                });
                
                
            }
            
            
            
        }];
        
    }else{
        
        [SVProgressHUD showWithStatus:@"请输入您的礼券激活码"];
        
        [SVProgressHUD dismissWithDelay:1];
    }
    
    
    

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    
    return YES;
    
}
#pragma mark UITextFieldDelegate
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (![cashcoupontext isExclusiveTouch]) {
        [cashcoupontext resignFirstResponder];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == cashcoupontext) {
        [cashcoupontext resignFirstResponder];
        return YES;
    }
    
    
    return YES;
}
#pragma mark --  点击事件
- (void)closeClickEvent:(UITapGestureRecognizer *)sender{
    //    NSInteger index = sender.view.tag;
    NSLog(@"输出");
    [cashcoupontext resignFirstResponder];
    
  
    
    
}

@end
