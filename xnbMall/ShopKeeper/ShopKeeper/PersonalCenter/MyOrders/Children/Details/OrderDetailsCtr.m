//
//  OrderDetailsCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/6/13.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "OrderDetailsCtr.h"
#import "OrderDetailCell1.h"
#import "OrderAddressCell.h"
#import "OrderListCell.h"
#import "PaymentCell.h"//支付方式
#import "OrderListBtnCell.h"//有退款按钮

#import "OrderDetailModel.h"

#import "RefundApplicationCtr.h"//申请退款
#import "RefundApplicationRecordCtr.h"
#import "RefundPaymenCtr.h"//未支付
#import "RefundPaymenRecordCtr.h"


#import "TransDataProxyCenter.h"
#import "ShareData.h"
#import "OrderTrackingCtr.h"
#import "TransDataProxyCenter.h"
#import "MAGoodsCommentViewController.h"
#import "SKYiextremelyPayController.h"  //易极付

#import "MAGoodsDetailsViewController.h"

@interface OrderDetailsCtr ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate, OrderDetailCell1delegate,OrderListBtndelegate>{
    
    NSMutableArray * getdetailArray;
    NSInteger isTheFirstgetdata;
    
    UIButton* paybtn;
}

@property (nonatomic,strong) UITableView* maintableview;
@property (nonatomic , strong) UILabel * shouldpaylab;

@end

@implementation OrderDetailsCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"订单详情"];
    isTheFirstgetdata = 0;
    getdetailArray = [[NSMutableArray alloc] init];
    
    [self makeFootView];
    [self maketableview];
    
    [self getData];
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
    
    [_shouldpaylab setTextColor:ColorFromHex(0x646464)];
    [_shouldpaylab setBackgroundColor:[UIColor clearColor]];
    [_shouldpaylab setNumberOfLines:0];
    [_shouldpaylab setAdjustsFontSizeToFitWidth:YES];
    [_shouldpaylab setTextAlignment:NSTextAlignmentLeft];
    [footview addSubview:_shouldpaylab];
    
    paybtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [paybtn setFrame:CGRectMake(SCREEN_WIDTH-100, 0, 100, 50)];
    [paybtn setBackgroundColor:ColorFromRGB(236, 89, 82)];
    [paybtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [paybtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [paybtn setHidden:YES];
    
    [paybtn addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
    
    [footview addSubview:paybtn];
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (getdetailArray.count>0) {
        return 4;
    }
    
    return 0;
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
    
    
    if (getdetailArray.count>0) {
        OrderDetailModel* model = getdetailArray[0];
        NSString* getstate = [[ShareData shareController] getOrderState:model.orderStatus];
        
        
        NSString * getpaystring = nil;
        
        if ([getstate isEqualToString:@"1"]) {//待付款
            
            if (model.activityType == 6) {
                
                getpaystring = [NSString stringWithFormat:@"%@%ld 分",@"使用积分：",model.bonus];
                //                [_shouldpaylab setText:[NSString stringWithFormat:@"%@%ld 分",@"应付款：",model.bonus]];
                
            }else{
                getpaystring = [NSString stringWithFormat:@"%@%.2f",@"应付款：¥ ",model.amount];
                //                [_shouldpaylab setText:[NSString stringWithFormat:@"%@%.2f",@"应付款：¥ ",model.amount]];
                
            }
            
            [paybtn setTitle:@"付款" forState:UIControlStateNormal];
            [paybtn setHidden:NO];
            
            
        }else if ([getstate isEqualToString:@"2"]){//待发货
            
            
            if (model.activityType == 6) {
                
                getpaystring = [NSString stringWithFormat:@"%@%ld 分",@"使用积分：",model.bonus];
                //                [_shouldpaylab setText:[NSString stringWithFormat:@"%@%ld 分",@"实付款：",model.bonus]];
                
            }else{
                getpaystring = [NSString stringWithFormat:@"%@%.2f",@"实付款：¥ ",model.amount];
                //                [_shouldpaylab setText:[NSString stringWithFormat:@"%@%.2f",@"实付款：¥ ",model.amount]];
                
            }
            
            
            [paybtn setHidden:YES];
            
            
        }else if ([getstate isEqualToString:@"3"]){//待签收
            
            if (model.activityType == 6) {
                
                getpaystring = [NSString stringWithFormat:@"%@%ld 分",@"使用积分：",model.bonus];
                //                [_shouldpaylab setText:[NSString stringWithFormat:@"%@%ld 分",@"实付款：",model.bonus]];
                
            }else{
                getpaystring = [NSString stringWithFormat:@"%@%.2f",@"实付款：¥ ",model.amount];
                //                [_shouldpaylab setText:[NSString stringWithFormat:@"%@%.2f",@"实付款：¥ ",model.amount]];
                
            }
            
            [paybtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [paybtn setHidden:NO];
            
            
            
        }else if ([getstate isEqualToString:@"4"]){//已经完成
            
            if (model.activityType == 6) {
                
                getpaystring = [NSString stringWithFormat:@"%@%ld 分",@"使用积分：",model.bonus];
                //                [_shouldpaylab setText:[NSString stringWithFormat:@"%@%ld 分",@"实付款：",model.bonus]];
                
            }else{
                getpaystring = [NSString stringWithFormat:@"%@%.2f",@"实付款：¥ ",model.amount];
                //                [_shouldpaylab setText:[NSString stringWithFormat:@"%@%.2f",@"实付款：¥ ",model.amount]];
                
            }
            if (model.isComment == 1) {
                [paybtn setHidden:YES];
            }else{
                
                [paybtn setTitle:@"评价" forState:UIControlStateNormal];
                [paybtn setHidden:NO];
            }
        }
        if (getpaystring.length>4) {
            NSMutableAttributedString *typeStr = [[NSMutableAttributedString alloc] initWithString:getpaystring];
            [typeStr addAttribute:NSForegroundColorAttributeName value:ColorFromHex(0xec584c) range:NSMakeRange(4, getpaystring.length - 4)];
            
            _shouldpaylab.attributedText=typeStr;
        }
    }
    
    if (indexPath.section == 0 ) {
        if (indexPath.row== 0) {
            return 85;
        }else if (indexPath.row == 1){
            
            return 70;
        }else if (indexPath.row == 2){
            
            return 40;
        }
    }else if (indexPath.section == 1 ){//订单列表高95 和60
        
        if (getdetailArray.count>0) {
            return 60;
        }
        return 0;
        
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
            
            //            联系客服
            UIButton* _btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            
            [_btn setBackgroundColor:[UIColor clearColor]];
            [_btn setTitle:@" 联系客服" forState:UIControlStateNormal];
            [_btn setImage:[UIImage imageNamed:@"CustomerService"] forState:UIControlStateNormal];
            [_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [_btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [_btn.layer setCornerRadius:5];
            [_btn bk_addEventHandler:^(id sender) {
                NSLog(@"联系客服");
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"请拨打客服热线"                                                                            message:@"4000-456-115"  preferredStyle:UIAlertControllerStyleAlert];
                //添加Button
                [alertController addAction: [UIAlertAction actionWithTitle:@"拨打" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4000-456-115"];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                }]];
                
                [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
                [self presentViewController: alertController animated: YES completion: nil];
            } forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_btn];

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
            if (model.activityType == 6) {
                price  = [NSString stringWithFormat:@"%ld分",model.bonus];
                
            }else{
                
                price  = [NSString stringWithFormat:@"¥%.2f",[getprice floatValue]];
                
            }
            
            NSString* specificationDesc = dic[@"specificationDesc"];
            if (specificationDesc) {
                title =[NSString stringWithFormat:@"%@\n%@", dic[@"title"],specificationDesc];
            }else{
                title =[NSString stringWithFormat:@"%@", dic[@"title"]];
                
            }
            url =[NSString stringWithFormat:@"%@",  dic[@"url"]];
        }
        
        NSArray * titlearray =@[url,title,price,number];
        
        if (getdetailArray.count>0) {
            
            if (model.activityType == 6) {
                OrderListCell *cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ];
                [cell update:titlearray];
                
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                
                return cell;
            }else{
                
                OrderListCell *cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ];
                [cell update:titlearray];
                
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                
                return cell;
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
        
        return cell;
    }else if (indexPath.section == 3){
        
        PaymentCell *cell = [[PaymentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ];
        
        NSInteger bonus = model.bonus;
        CGFloat giftCardAmount = model.giftCardAmount;
        CGFloat amount = model.paidAmount;
        
        NSString* getmoney = @"";
        if (model.activityType == 6) {
            getmoney = [NSString stringWithFormat:@"%ld分",bonus];
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
    if (indexPath.section == 1) {
        OrderDetailModel* model = nil;
        if (getdetailArray.count>0) {
            model = getdetailArray[0];
            
            if (model.activityType != 6) {
                //积分订单不允许查看详情
                NSArray * getarray = model.orderGoodsList;
                NSDictionary * dic = getarray[indexPath.row];
                
                MAGoodsDetailsViewController *vc = [[MAGoodsDetailsViewController alloc] init];
                vc.goodsSpecId = dic[@"goodsSpecificationId"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
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
    //    currentFrame.origin.y = currentFrame.size.height - change ;
    CGRect rect = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height  - change);
    
    _maintableview.frame = rect;
}

-(void)keyboardWillDisappear:(NSNotification *)notification {
    
    CGRect rect = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height- 50);
    _maintableview.frame = rect;
}

-(void)getData{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [JKURLSession taskWithMethod:@"order/detail.do" parameter:@{@"orderId":_getorderId} token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            [_maintableview.mj_header endRefreshing];
            if (error == nil) {
                [getdetailArray removeAllObjects];
                OrderDetailModel* model = [OrderDetailModel create:resultDic[@"data"]];
                [getdetailArray addObject:model];
                
                [_maintableview reloadData];
                [self makeFootView];
            }else {
                [self makeFootView];
                [self showAutoDissmissHud:error.localizedDescription];
            }
        });
    }];
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
    NSLog(@"%d",(int)indexrow);
}

-(void)clickbutton:(id)sender{
    
    UIButton * btn = sender;
    
    NSString * getbtntitle = btn.titleLabel.text;
    
    NSLog(@" --- --  = %@",getbtntitle);
    if ([getbtntitle isEqualToString:@"付款"]) {
        
        if (getdetailArray.count>0) {
            OrderDetailModel* model = getdetailArray[0];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [JKURLSession taskWithMethod:@"order/pay.do" parameter:@{@"orderId":model.orderId} token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                    if (error == nil) {
                        [MobClick event:@"order_details_pay" label:@"订单详情付款"];
                        SKYiextremelyPayController *vc = [[SKYiextremelyPayController alloc]init];
                        vc.payCode =  resultDic[@"data"];
                        vc.orderId = model.orderId;
                        vc.productName = @"新农宝商城";
                        vc.productDescription = @"新农宝商城";
                        [self.navigationController pushViewController:vc animated:YES];
                    }else {
                        [self showAutoDissmissHud:error.localizedDescription];
                    }
                });
            }];
        }
    }else if ([getbtntitle isEqualToString:@"评价"]){
        
        OrderDetailModel* model = getdetailArray[0];
        
        MAGoodsCommentViewController * vc = [[MAGoodsCommentViewController alloc] init];
        vc.orderId = model.orderId;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([getbtntitle isEqualToString:@"确认收货"]){
        
        if (getdetailArray.count>0) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil                                                                             message:@"您确定已经收到货物了吗？"  preferredStyle:UIAlertControllerStyleAlert];
            //添加Button
            
            [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                OrderDetailModel* model = getdetailArray[0];
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [JKURLSession taskWithMethod:@"order/receive.do" parameter:@{@"orderId":model.orderId} token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [hud hideAnimated:YES];
                        if (error == nil) {
                            [self getData];
                        }else {
                            [self showAutoDissmissHud:error.localizedDescription];
                        }
                    });
                }];
            }]];
            [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController: alertController animated: YES completion: nil];
        }
    }
}
@end
