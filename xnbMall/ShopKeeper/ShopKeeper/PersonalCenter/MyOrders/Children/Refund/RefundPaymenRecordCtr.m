//
//  RefundPaymenRecordCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/6/21.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "RefundPaymenRecordCtr.h"
#import "SelectTextview.h"
#import "AFHTTPSessionManager+Util.h"
#import "NSString+Utils.h"
#import "Utils.h"
@interface RefundPaymenRecordCtr (){

    UILabel * labwhy;

}
@property (nonatomic) NSMutableArray *imglist;
@property (nonatomic) NSMutableArray *imgidlist;
@property (nonatomic) NSInteger ieditindex;

@end

@implementation RefundPaymenRecordCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"退款"];
    
    _imglist = [NSMutableArray new];
    _imgidlist = [NSMutableArray new];
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
    
    [self createFootview];
    //    UITapGestureRecognizer* singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClickEvent:)];
    //    singleFingerOne.numberOfTouchesRequired = 1;
    //    singleFingerOne.numberOfTapsRequired = 1;
    //    singleFingerOne.delegate = self;
    //    [mianTableView addGestureRecognizer:singleFingerOne];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
    
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(indexPath.row == 0){
        
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:[self makeCellOneView]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
        
        
        
    }else{
        
        
        UITableViewCell * cell = [[UITableViewCell alloc] init];
 
      
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
        
    }
    
    
    
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 200;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)closeClickEvent:(UITapGestureRecognizer *)sender{
    //    NSInteger index = sender.view.tag;
    
    NSLog(@"输出");
    
    
}

#pragma mark 键盘缩回

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
//    if (![messagetextview isExclusiveTouch]) {
//        [messagetextview resignFirstResponder];
//    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
    
}
-(void)textChangeAction:(UITextField*)textField{
    
    NSLog(@"wrwer ==  %d",textField.tag);
    
    
    
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    
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
    
    //    CGRect currentFrame = _maintableview.frame;
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    //    currentFrame.origin.y = currentFrame.size.height - change ;
    CGRect rect = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height  - change);
    
    mianTableView.frame = rect;
    
    
}

-(void)keyboardWillDisappear:(NSNotification *)notification

{
    
    
    CGRect rect = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    
    mianTableView.frame = rect;
    
    
}





-(UIView*)makeCellOneView{
    
    CGFloat leftX = 15;
    CGFloat bgviewH = 220;
    CGFloat labH = 50;
    
    UIView * bgview =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, bgviewH)];
    [bgview setBackgroundColor:[UIColor clearColor]];
    
    
    UIView * bgwhiteView = [[UIView alloc] initWithFrame:CGRectMake(leftX, leftX, SCREEN_WIDTH - leftX*2 , bgviewH - leftX*2)];
    [bgwhiteView setBackgroundColor:[UIColor whiteColor]];
    [bgview addSubview:bgwhiteView];
    
    for (int i = 0 ; i<2; i++) {
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, labH+labH*i -1 , SCREEN_WIDTH -leftX*2 , 1)];
        [line setBackgroundColor:ColorFromRGB(240, 240, 240)];
        [bgwhiteView addSubview:line];
    }
    
    UILabel * lab_0 = [[UILabel alloc] init];
    lab_0.frame = CGRectMake(leftX, 0, 60 , labH);
    [lab_0 setFont:[UIFont systemFontOfSize:15]];
    [lab_0 setTextColor:[UIColor grayColor]];
    [lab_0 setNumberOfLines:0];
    [lab_0 setTextAlignment:NSTextAlignmentLeft];
    [bgwhiteView addSubview:lab_0];
    
    NSString* labtext0 =@"*原因" ;
    NSMutableAttributedString *typeStr0 = [[NSMutableAttributedString alloc] initWithString:labtext0];
    [typeStr0 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
    //    [typeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12]range:NSMakeRange(0, 6)];
    lab_0.attributedText=typeStr0;
    
    
    labwhy = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, SCREEN_WIDTH - leftX*3-75, labH)];
    [labwhy setFont:[UIFont systemFontOfSize:15]];
    [labwhy setTextColor:[UIColor grayColor]];
    [labwhy setNumberOfLines:0];
    [labwhy setAdjustsFontSizeToFitWidth: YES];
    [labwhy setBackgroundColor:[UIColor clearColor]];
    [labwhy setText:@"其他原因"];
    [labwhy setTextAlignment:NSTextAlignmentRight];
    [bgwhiteView addSubview:labwhy];

   
    
    UILabel * lab_1 = [[UILabel alloc] init];
    lab_1.frame = CGRectMake(leftX, labH, SCREEN_WIDTH/3 , labH);
    [lab_1 setFont:[UIFont systemFontOfSize:16]];
    [lab_1 setText:@"*退款金额（最多82.00元）"];
    [lab_1 setTextColor:[UIColor blackColor]];
    [lab_1 setNumberOfLines:0];
    [lab_1 setTextAlignment:NSTextAlignmentLeft];
    [bgwhiteView addSubview:lab_1];
    
    NSString* labtext1 =[NSString stringWithFormat:@"*退款金额（最多%@元）",@"82.00"];
    NSMutableAttributedString *typeStr1 = [[NSMutableAttributedString alloc] initWithString:labtext1];
    [typeStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
    lab_1.attributedText=typeStr1;
    
    
    
    
    UILabel * lab_2 = [[UILabel alloc] init];
    lab_2.frame = CGRectMake(SCREEN_WIDTH - leftX*3 - 30, labH, 30 , labH);
    [lab_2 setFont:[UIFont systemFontOfSize:16]];
    [lab_2 setText:@"元"];
    [lab_2 setTextColor:[UIColor grayColor]];
    [lab_2 setNumberOfLines:0];
    [lab_2 setTextAlignment:NSTextAlignmentRight];
    [lab_2 setBackgroundColor:[UIColor clearColor]];
    [bgwhiteView addSubview:lab_2];
    
    
    moneyTextField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/3 - 70 , labH, SCREEN_WIDTH/3 , labH)];
    [moneyTextField setPlaceholder:@"请输入金额"];
    [moneyTextField setFont:[UIFont boldSystemFontOfSize:16]];
    [moneyTextField setContentVerticalAlignment : UIControlContentVerticalAlignmentCenter];
    [moneyTextField setTextAlignment:NSTextAlignmentRight];
    [moneyTextField setTextColor:[UIColor grayColor]];
    [moneyTextField setBackgroundColor:[UIColor clearColor]];
    [moneyTextField setKeyboardType:UIKeyboardTypeDefault];
    [moneyTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [moneyTextField setAutocorrectionType:UITextAutocorrectionTypeNo];//不要纠错提醒
    [moneyTextField setClearButtonMode:UITextFieldViewModeNever];//输入时显示清除按钮
    [moneyTextField setSecureTextEntry:NO];//密文输入
    [moneyTextField setReturnKeyType:UIReturnKeyNext];
    [moneyTextField setEnabled:NO];
    [moneyTextField setDelegate:self];
    moneyTextField.adjustsFontSizeToFitWidth = YES;
    [bgwhiteView addSubview:moneyTextField];
    
    
    
    
    
    noteTextview = [[UITextView alloc] initWithFrame:CGRectMake(leftX, labH*2+5, SCREEN_WIDTH - leftX*4, 80)]; //初始化大小并自动释放
    
    noteTextview.textColor = KFontColor(@"#646464");//设置textview里面的字体颜色
    
    noteTextview.font = [UIFont fontWithName:@"Arial" size:14.0];//设置字体名字和字体大小
    
    noteTextview.delegate = self;//设置它的委托方法
    
    noteTextview.backgroundColor = [UIColor clearColor];//设置它的背景颜色
    
    noteTextview.text = @"备注";//设置它显示的内容
    
    noteTextview.returnKeyType = UIReturnKeyDefault;//返回键的类型
    
    noteTextview.keyboardType = UIKeyboardTypeDefault;//键盘类型
    
    noteTextview.scrollEnabled = YES;//是否可以拖动
    
    noteTextview.editable = NO;
    
    noteTextview.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    
    
    [bgwhiteView addSubview:noteTextview];
    
    
    return bgview;
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

-(void)createFootview{
    
    
    UIView* bgview = [[UIView alloc] init];
    [bgview setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [bgview setBackgroundColor: [UIColor clearColor]];
    
    mianTableView.tableFooterView = bgview;
    
    UIColor *color = HEXCOLOR(0xEE2C2Cff);
    
    UIButton* loginout = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginout setBackgroundColor:color];
    [loginout setFrame:CGRectMake(15,30, SCREEN_WIDTH - 30, 40)];
    [loginout setTitle:@"提交申请" forState:UIControlStateNormal];
    [loginout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginout.layer setCornerRadius:5.];
    
    [loginout addTarget:self action:@selector(loginoutclick:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:loginout];
    
    
    
    
    
    
    
    
}

-(void)loginoutclick:(id)sender{
    
    [moneyTextField resignFirstResponder];
    [noteTextview resignFirstResponder];
    
    
    
}

@end
