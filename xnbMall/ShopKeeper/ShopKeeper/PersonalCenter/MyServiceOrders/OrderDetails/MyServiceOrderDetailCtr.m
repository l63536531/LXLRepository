//
//  MyServiceOrderDetailCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/7/6.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MyServiceOrderDetailCtr.h"
#import "OrderDetailCell1.h"
#import "OrderAddressCell.h"
#import "OrderListCell.h"
#import "PaymentCell.h"//支付方式
#import "OrderListBtnCell.h"//有退款按钮

#import "OrderDetailModel.h"
#import "ExpressTablecell.h"//快递公司

#import "RefundApplicationCtr.h"//申请退款
#import "RefundApplicationRecordCtr.h"
#import "RefundPaymenCtr.h"//未支付
#import "RefundPaymenRecordCtr.h"


#import "TransDataProxyCenter.h"
#import "ShareData.h"
#import "OrderTrackingCtr.h"
#import "TransDataProxyCenter.h"
@interface MyServiceOrderDetailCtr ()<OrderDetailCell1delegate,OrderListBtndelegate>{
    
}


@end

@implementation MyServiceOrderDetailCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"订单详情"];
    isTheFirstgetdata = 0;
    getdetailArray = [[NSMutableArray alloc] init];
    
    [self makeFootView];
    [self maketableview];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (isTheFirstgetdata == 1) {
        [self getData];
        
    }
    isTheFirstgetdata = 1;
    
    NSLog(@"viewwillappear");
}

-(void)makeFootView{
    
    
    
    UIImage* image = [UIImage imageNamed:@""];
    UIImageView * iamgeview=[[UIImageView alloc] initWithImage:image];
    [iamgeview setFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:iamgeview];
    
    
    UIView * footview = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50 - 64, SCREEN_WIDTH, 50)];
    [footview setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:footview];
    
    
    _shouldpaylab = [[UILabel alloc] init];
    
    _shouldpaylab.frame = CGRectMake(15, 0, SCREEN_WIDTH - 115 , 50);
    [_shouldpaylab setFont:[UIFont systemFontOfSize:18]];
    
    [_shouldpaylab setTextColor:[UIColor blackColor]];
    [_shouldpaylab setBackgroundColor:[UIColor clearColor]];
    [_shouldpaylab setNumberOfLines:0];
    [_shouldpaylab setAdjustsFontSizeToFitWidth:YES];
    [_shouldpaylab setTextAlignment:NSTextAlignmentLeft];
    [footview addSubview:_shouldpaylab];
    
    
    if (getdetailArray.count>0) {
        OrderDetailModel* model = getdetailArray[0];
        NSString* getstate = [[ShareData shareController] getOrderState:model.orderStatus];
        
        
        
        NSString * getpaystring = nil;
        
        if ([getstate isEqualToString:@"1"]) {//待付款
            
            if (model.activityType == 6) {
                
                getpaystring = [NSString stringWithFormat:@"%@%ld 分",@"应付款：",model.bonus];
                
            }else{
                getpaystring = [NSString stringWithFormat:@"%@%.2f",@"应付款：¥ ",model.amount];
                
            }
            
            
        }else if ([getstate isEqualToString:@"2"]){//待发货
            
            
            if (model.activityType == 6) {
                
                getpaystring = [NSString stringWithFormat:@"%@%ld 分",@"实付款：",model.bonus];
                
            }else{
                getpaystring = [NSString stringWithFormat:@"%@%.2f",@"实付款：¥ ",model.amount];
                
            }
            
        }else if ([getstate isEqualToString:@"3"]){//待签收
            
            if (model.activityType == 6) {
                
                getpaystring = [NSString stringWithFormat:@"%@%ld 分",@"实付款：",model.bonus];
                
            }else{
                getpaystring = [NSString stringWithFormat:@"%@%.2f",@"实付款：¥ ",model.amount];
            }
            
        }else if ([getstate isEqualToString:@"4"]){//已经完成
            
            if (model.activityType == 6) {
                
                getpaystring = [NSString stringWithFormat:@"%@%ld 分",@"实付款：",model.bonus];
                
            }else{
                getpaystring = [NSString stringWithFormat:@"%@%.2f",@"实付款：¥ ",model.amount];
                
            }
        }
        
        if (getpaystring.length>4) {
            NSMutableAttributedString *typeStr = [[NSMutableAttributedString alloc] initWithString:getpaystring];
            [typeStr addAttribute:NSForegroundColorAttributeName value:ColorFromHex(0xec584c) range:NSMakeRange(4, getpaystring.length - 4)];
            
            _shouldpaylab.attributedText=typeStr;
        }
        
    }
    
}


-(void)maketableview{
    
    
    _maintableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height - 64 - 50)];
    _maintableview.dataSource = self;
    _maintableview.bounces = YES;
    _maintableview.delegate = self;
    _maintableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _maintableview.backgroundColor = ColorFromRGB(230, 230, 230);
    
    [self.view addSubview:_maintableview];
    
    _maintableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    //    _maintableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [_maintableview.mj_header beginRefreshing];
    
    
    UITapGestureRecognizer* singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClickEvent:)];
    singleFingerOne.numberOfTouchesRequired = 1;
    singleFingerOne.numberOfTapsRequired = 1;
    singleFingerOne.delegate = self;
    [_maintableview addGestureRecognizer:singleFingerOne];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (getdetailArray.count>0) {
        return 4;
        
    }else return 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    OrderDetailModel* model = nil;
    if (getdetailArray.count>0) {
        
        model = getdetailArray[0];
    }
    
    if (section == 0 ) {
        return 3;
    }else if (section == 1){//产品展示
        if (getdetailArray.count>0) {
            
            return model.orderGoodsList.count;
        }else return 0;
        
    }else if (section == 2){
        if (getdetailArray.count>0) {
            OrderDetailModel* model = getdetailArray[0];
            
            NSString * comments = model.comments;
            if ([comments length]>0) {
                return 1;
            }else return 0;
            
        }
        
        return 0;
    }else if (section == 3){
        
        return 1;
    }
    
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 ) {
        if (indexPath.row== 0) {
            return 85;
        }else if (indexPath.row == 1){
            
            return 70;
        }else if (indexPath.row == 2){
            
            return 40;
        }
    }else if (indexPath.section == 1 ){//订单列表高95 和60
        
        return 60;
        
    }else if (indexPath.section == 2){
        
        return 60;
    }else if (indexPath.section == 3){
        
        return 100;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderDetailModel* model = nil;
    if (getdetailArray.count>0) {
        model = getdetailArray[0];
        
    }
    
    CGFloat leftx = 15;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            OrderDetailCell1 *cell = [[OrderDetailCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ];
            
            NSString * statedec = @"";
            NSString * getdetailstring = @"";
            NSString * getorderNB = @"";
            if (getdetailArray.count>0) {
                NSString* getstate = [[ShareData shareController] getOrderState:model.orderStatus];
                
                getorderNB = model.orderCode;
                if ([getstate isEqualToString:@"1"]) {//待付款
                    statedec = @"待付款";
                    getdetailstring = @"您已经提交订单，请尽快完成付款";
                }else if ([getstate isEqualToString:@"2"]){//待发货
                    
                    statedec = @"待发货";
                    getdetailstring = @"您的订单已付款，请等待卖家发货";
                    
                }else if ([getstate isEqualToString:@"3"]){//待签收
                    statedec = @"待签收";
                    
                    getdetailstring = @"您的商品正火速赶往您的手中";
                    
                }else if ([getstate isEqualToString:@"4"]){//已经完成
                    
                    statedec = @"已完成";
                    getdetailstring = @"感谢光临，欢迎您在新农宝购买商品";
                }
            }
            
            NSArray * titlearray =@[statedec,getorderNB,getdetailstring];
            
            [cell update:titlearray];
            cell.delegate  = self;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
            
        }else if (indexPath.row == 1){
            
            OrderAddressCell *cell = [[OrderAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ];
            NSString * getname = @"";
            NSString * getphone = @"";
            NSString * getadress = @"";
            if (getdetailArray.count>0) {
                
                getname = model.userName;
                getphone = model.phone;
                getadress = model.address;
            }
            
            
            NSArray * titlearray =@[[NSString stringWithFormat:@"%@  %@",getname,getphone],getadress];
            
            [cell update:titlearray];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
            
            
        }else if (indexPath.row == 2){
            
            UITableViewCell* cell = [[UITableViewCell alloc]init];
            
            
            UILabel* labtitle = [[UILabel alloc] init];
            
            labtitle.frame = CGRectMake(15, 0, SCREEN_WIDTH /3  - 10, 40);
            [labtitle setFont:[UIFont systemFontOfSize:14]];
            [labtitle setText:@"商品详情"];
            [labtitle setTextColor:[UIColor grayColor]];
            [labtitle setBackgroundColor:[UIColor clearColor]];
            [labtitle setNumberOfLines:0];
            [labtitle setAdjustsFontSizeToFitWidth:YES];
            [labtitle setTextAlignment:NSTextAlignmentLeft];
            [cell.contentView addSubview:labtitle];
            
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
            [line setBackgroundColor:ColorFromRGB(230, 230, 230)];
            [cell.contentView addSubview:line];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
        }
    }else if (indexPath.section == 1){
        
        NSArray * getarray = model.orderGoodsList;
        NSString* number = @"";
        NSString* price = @"";
        NSString* title = @"";
        NSString* url = @"";
        if (getarray.count>0) {
            NSDictionary * dic = getarray[indexPath.row];
            NSNumber * getnb = dic[@"number"];
            number = [NSString stringWithFormat:@"x%d",[getnb intValue]];
            
            NSNumber * getprice = dic[@"price"];
            price  = [NSString stringWithFormat:@"¥%.2f",[getprice floatValue]];
            NSString* specificationDesc = dic[@"specificationDesc"];
            if (specificationDesc) {
                title =[NSString stringWithFormat:@"%@\n%@", dic[@"title"],specificationDesc];
            }else{
                title =[NSString stringWithFormat:@"%@", dic[@"title"]];
                
            }
            url =[NSString stringWithFormat:@"%@",  dic[@"url"]];
            
        }
        
        
        NSArray * titlearray =@[url,title,price,number,@"68237827317797979797",@"32",@"备注问题"];
        
        if (getdetailArray.count>0) {
            NSString* getstate = [[ShareData shareController] getOrderState:model.orderStatus];
            OrderListCell *cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ];
            [cell update:titlearray];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            
            return cell;
            
            if (model.activityType == 6) {
                
            }else{
                
            }
            
        }
        
    }else if (indexPath.section == 2){
        
        UITableViewCell* cell = [[UITableViewCell alloc]init];
        
        
        UILabel* labtitle = [[UILabel alloc] init];
        
        labtitle.frame = CGRectMake(leftx, 0, SCREEN_WIDTH /3 , 20);
        [labtitle setFont:[UIFont systemFontOfSize:12]];
        [labtitle setText:@"买家留言"];
        [labtitle setTextColor:[UIColor blackColor]];
        [labtitle setBackgroundColor:[UIColor clearColor]];
        [labtitle setNumberOfLines:0];
        [labtitle setAdjustsFontSizeToFitWidth:YES];
        [labtitle setTextAlignment:NSTextAlignmentLeft];
        [cell.contentView addSubview:labtitle];
        
        UILabel* labdec = [[UILabel alloc] init];
        
        labdec.frame = CGRectMake(leftx, 20, SCREEN_WIDTH - leftx*2, 35);
        [labdec setFont:[UIFont systemFontOfSize:12]];
        [labdec setText:model.comments];
        [labdec setTextColor:[UIColor grayColor]];
        [labdec setBackgroundColor:ColorFromRGB(240, 240, 240)];
        [labdec setNumberOfLines:0];
        [labdec setAdjustsFontSizeToFitWidth:YES];
        [labdec setTextAlignment:NSTextAlignmentLeft];
        [cell.contentView addSubview:labdec];
        
        
        textfield = [[UITextField alloc] initWithFrame:CGRectMake(leftx, 20, SCREEN_WIDTH - leftx*2, 35)];
        [textfield setPlaceholder:@" 请输入"];
        [textfield setFont:[UIFont boldSystemFontOfSize:16]];
        [textfield setContentVerticalAlignment : UIControlContentVerticalAlignmentCenter];
        [textfield setTextColor:[UIColor grayColor]];
        [textfield setBackgroundColor:ColorFromRGB(240, 240, 240)];
        [textfield setKeyboardType:UIKeyboardTypeDefault];
        [textfield setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [textfield setAutocorrectionType:UITextAutocorrectionTypeNo];//不要纠错提醒
        [textfield setClearButtonMode:UITextFieldViewModeWhileEditing];//输入时显示清除按钮
        [textfield setSecureTextEntry:NO];//密文输入
        [textfield setReturnKeyType:UIReturnKeyNext];
        [textfield setDelegate:self];
        textfield.adjustsFontSizeToFitWidth = YES;
        //        [cell.contentView addSubview:textfield];
        
        
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
        
    }else if (indexPath.section == 3){
        
        
        PaymentCell *cell = [[PaymentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ];
        
        CGFloat cardCashCoupon = model.cardCashCoupon;
        CGFloat giftCardAmount = model.giftCardAmount;
        CGFloat amount = model.amount;
        
        NSString* getmoney = @"";
        if (model.activityType == 6) {
            getmoney = [NSString stringWithFormat:@"%d分",(int)cardCashCoupon];
        }else{
            
            getmoney = [NSString stringWithFormat:@"¥%.2f",amount];
            
        }
        NSString * getpaystate = model.orderPayMethodDes;
        if (!(getpaystate.length>0)) {
            getpaystate=@"";
        }
        
        
        NSArray * titlearray =@[getpaystate,getmoney,[NSString stringWithFormat:@"¥%.2f",giftCardAmount]];
        
        [cell update:titlearray];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"选择%d",(int)indexPath.row);
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 0;
    }else
        return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

- (void)closeClickEvent:(UITapGestureRecognizer *)sender{
    //    NSInteger index = sender.view.tag;
    
    [textfield resignFirstResponder];
}

#pragma mark 键盘缩回
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textfield resignFirstResponder];
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
    //    CGRect currentFrame = _maintableview.frame;
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    //    currentFrame.origin.y = currentFrame.size.height - change ;
    CGRect rect = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height  - change);
    
    _maintableview.frame = rect;
    
}

-(void)keyboardWillDisappear:(NSNotification *)notification

{
    
    CGRect rect = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height- 50);
    
    _maintableview.frame = rect;
    
}

-(void)getData{
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"请求中..."];
    [[TransDataProxyCenter shareController] querydetailorderId:_getorderId block:^(NSDictionary *dic, NSError *error) {
        if (dic) {
            NSNumber* code = dic[@"code"];
            NSString* msg = dic[@"msg"];
            if ([code intValue]  == 200) {
                
                [getdetailArray removeAllObjects];
                
                OrderDetailModel* model = [OrderDetailModel create:dic[@"data"]];
                
                [getdetailArray addObject:model];
                
                NSLog(@"%d",(int)getdetailArray.count);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    
                    [_maintableview reloadData];
                    [self makeFootView];
                });
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_maintableview reloadData];
                    
                    [SVProgressHUD showWithStatus:msg];
                    
                    [SVProgressHUD dismissWithDelay:1];
                    [self makeFootView];
                });
            }
            
        }else{
            
            [SVProgressHUD showWithStatus:@"请检查网络"];
            
            [SVProgressHUD dismissWithDelay:1];
            
        }
        
    }];
    [SVProgressHUD dismiss];
    
    [_maintableview reloadData];
    [_maintableview.mj_header endRefreshing];
    
    
}

-(void)clickDingDengButton{
    
    NSLog(@"订单追踪");
    
    OrderTrackingCtr * vc = [[OrderTrackingCtr alloc] init];
    
    OrderDetailModel* model = nil;
    if (getdetailArray.count>0) {
        model = getdetailArray[0];
    }
    
    if (getdetailArray.count>0) {
        NSString* getstate = [[ShareData shareController] getOrderState:model.orderStatus];
        
        if ([getstate isEqualToString:@"1"]) {//待付款
            vc.getOrderState = @"待付款";
        }else if ([getstate isEqualToString:@"2"]){//待发货
            
            vc.getOrderState = @"待发货";
            
        }else if ([getstate isEqualToString:@"3"]){//待签收
            vc.getOrderState = @"待签收";
            
            
        }else if ([getstate isEqualToString:@"4"]){//已经完成
            
            vc.getOrderState = @"已完成";
        }
        
    }
    
    vc.getOrderNumber = model.orderCode;
    vc.hidesBottomBarWhenPushed = YES;
    vc.getorderID = model.orderId;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)clickrow:(NSInteger)indexrow{
    
    RefundPaymenCtr* vc = [[RefundPaymenCtr alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
