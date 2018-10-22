//
//  SKYiextremelyPayController.m
//  ShopKeeper
//
//  Created by XNB2 on 16/10/28.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "SKYiextremelyPayController.h"
#import <YJPaySDK/YJPaySDK.h>
#import <UnionPay/UnionPay.h>
#import <CommonCrypto/CommonCrypto.h>
#import "WXApiObject.h"

#import "MAMyOrdersViewController.h"  //我的订单
#import "SKBankMoneyLimiteVC.h" //查看银行限额

#import "SKPayWayCell.h"  //支付类型的cell
#import "SKPayWallcellmodel.h"



typedef NS_ENUM(NSUInteger, SKPayWay) {
    /** 快捷支付 */
    SKPayWayFast = 1,
    /** 银联支付 */
    SKPayWayYinLian = 2,
    /** 微信支付 */
    SKPayWayWeixin = 3,
};

#pragma mark - 标识符
static NSString *PayWayCell_id = @"PayWayCell_id";

@interface SKYiextremelyPayController ()<UITableViewDelegate,UITableViewDataSource,YJPayDelegate>{
    
    NSString *_memType;      //会员类型:易极付会员、商户会员、
    
    
    MBProgressHUD* HUD;
}
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIView *bottomView;
//支付金额label
@property (nonatomic,strong) UILabel *totalLabel;
//上次选中的按钮
@property (nonatomic, strong) UIButton *selectedBtn;

@property(nonatomic,strong) NSDictionary *data;
@property(nonatomic,strong) NSMutableArray *payMethods;
//实付款
@property(nonatomic,assign) float totalamount;
 //支付方式:
/* 
 YJPayWayNone = 0,                       // 默认支付方式（聚合支付）
 YJPayWayYiji = 1 << 0,                  // 易手富支付
 YJPayWayUPMP = 1 << 1,                  // 银联支付
 YJPayWayWechat = 1 << 2,                // 微信支付
 YJPayWaySuper = 1 << 3,                 // 聚合支付
 YJPayWayUPWAP = 1 << 4,                 // 银联WAP支付
 YJPayWayDefault = YJPayWaySuper,        // 默认支付方式（聚合支付）
 YJPayWayOffline = 1 << 5,               // 离线支付
 */
@property (nonatomic)YJPayWay payWay;


@end

@implementation SKYiextremelyPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付方式";
    
    //把返回文字的标题设置为空字符串
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    _totalamount  = 0.00;
    
    [self paymethod];       //支付类型
    [self setupTableView];  //tableView
    
    [self makeBottomView];  //支付金额
}

#pragma  - mark UI
- (void)setupTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    //取消线条
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO; //不滚动
    self.tableView.scrollsToTop = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    //注册cell
    [self.tableView registerClass:[SKPayWayCell class] forCellReuseIdentifier:PayWayCell_id];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    
}

-(void)makeBottomView{
    
    _bottomView = [[UIView alloc]init];
    [self.view addSubview:_bottomView];
    WS(ws);
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view).offset(0);
        make.right.equalTo(ws.view).offset(0);
        make.bottom.equalTo(ws.view).offset(0);
        make.height.equalTo(@(50)).priorityLow();
    }];
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.2)];
    line.backgroundColor = [UIColor grayColor];
    [_bottomView addSubview:line];
    
    UIButton *btn_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_1 setTitle:@"支付" forState:UIControlStateNormal];
    btn_1.backgroundColor = KBackColor(@"#ec584c");
    [btn_1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_1 addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    btn_1.frame = CGRectMake(SCREEN_WIDTH - 80, 0, 80, 50);
    [_bottomView addSubview:btn_1];
    
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
    _totalLabel.font = [UIFont systemFontOfSize:14];
    
    [_bottomView addSubview:_totalLabel];
    
    //提示
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text =  @"● 请确保银行绑定的手机号码正确并正在使用，以便及时获取支付系统发出的验证码。";
    nameLabel.font  = [UIFont systemFontOfSize:14];
    nameLabel.numberOfLines = 0;
    nameLabel.textColor = KFontColor(@"#ec584c");
    [nameLabel sizeToFit];
    
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view).offset(10);
        make.right.equalTo(ws.view).offset(-4);
        make.bottom.equalTo(_bottomView.mas_top).offset(-10);
        make.height.equalTo(@(40)).priorityLow();
    }];
    
    [self RefreshBottomView];
}

-(void)RefreshBottomView{
    
    _totalamount = 0.00;
    if(_data[@"payAmount"] != nil){
        _totalamount = [_data[@"payAmount"] floatValue];
    }
    
    NSString *strlabel = [NSString stringWithFormat:@"实付款： ¥ %0.2f  ",_totalamount];
    NSRange range1 = [strlabel rangeOfString:@"¥"];
    //NSRange range2 = [strlabel rangeOfString:@" ("];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strlabel];
    [str addAttribute:NSForegroundColorAttributeName
                value:KFontColor(@"#ec584c")
                range:NSMakeRange(range1.location,strlabel.length-range1.location)];
    
    _totalLabel.attributedText = str;
    
}


#pragma mark - Touch events

- (void)payBtnClick:(UIButton *)btn {

    switch (self.selectedBtn.tag) {
        case SKPayWayFast:
            [MobClick event:@"pay_quick" label:@"快捷支付"];
            //  NSLog(@"---快捷支付");
            [self drawWithOrderpayment:SKPayWayYinLian memWithType:MEMBER_TYPE_PATERN payWithWay:YJPayWayYiji];
            break;
            
        case SKPayWayYinLian:
            [MobClick event:@"pay_union" label:@"银联支付"];
            //  NSLog(@"---银联支付");
            [self drawWithOrderpayment:SKPayWayYinLian memWithType:MEMBER_TYPE_PATERN payWithWay:YJPayWayUPMP];
            break;
            
        default:
            break;
    }

}



#pragma mark - Http request
//请求支付类型
-(void)paymethod{
    
    NSDictionary *postdata = @{@"payCode":_payCode};
    
    HUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:HUD];
    [self.view bringSubviewToFront:HUD];
    HUD.label.text = @"请求中...";
    [HUD showAnimated: YES];
    
    [[NetWorkManager shareManager]netWWorkWithReqUrl:@"pay/paymethod.do" ReqParam:postdata BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
        [HUD hideAnimated:YES];
        
      //  NSLog(@"paymethod:%@",dicStr);
        if(fail_success){ //网络成功
            
            if ([dicStr[@"code"] intValue] == 200) {
                _data = dicStr[@"data"];
            
                //支付方式
                NSMutableArray *mPayMethodsArray = [[NSMutableArray alloc] init];
                NSArray *orginalArray = dicStr[@"data"][@"payMethods"];
                if (orginalArray != nil && orginalArray.count > 0) {
                    [mPayMethodsArray addObjectsFromArray:orginalArray];
                }
                
                //原接口返回5代表3两种固定类型 过滤掉微信类型 =8
                for (int i = ((int)mPayMethodsArray.count - 1); i >= 0; i--) {
                    NSDictionary *dic = mPayMethodsArray[i];
                    if ([dic[@"type"] integerValue] == 5 || [dic[@"type"] integerValue] == 8) {
                        [mPayMethodsArray removeObject:dic];
                    }
                }
                //类型排序 
                [mPayMethodsArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    
                    NSDictionary *methodDic1 = (NSDictionary *)obj1;
                    NSDictionary *methodDic2 = (NSDictionary *)obj2;
                    
                    return [methodDic1[@"type"] compare:methodDic2[@"type"]];
                }];
                
                self.payMethods = mPayMethodsArray;

                [self.tableView reloadData];
                [self RefreshBottomView];
                
            }else {
                
                [MyUtile showAlertViewByMsg:dicStr[@"msg"] vc:self];
            }
            
        }else{
            
            [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
        }
    }];
    
}

#pragma  - mark 支付
//易极付初始化
- (void)startYJPay {
    /**  初始化   **/
    NSString *server = ENV_SERVER_RELEASE;//正式环境
    NSString *partnerid = PARTNER_ID_YJF; //商户号
    NSString *secKey = SECURITY_CODE_YJF; //安全码
    
    if (!partnerid || !secKey) {
        NSLog(@"partnerid和secKey不能为空");
        return;
    }
    NSDictionary *init = @{kYJPayServer: server,
                           kYJPayPartnerId: partnerid,
                           kYJPaySecurityKey: secKey};
    [YJPayService initEnvironment:init error:nil];
}

/**
 *  @author chenxinju, 17-05-05
 *
 *  易极付支付
 *
 *  @param paymethod 向服务器提交的支付类型 获取订单支付信息
 *  @param memType   易首付必传  商户类型
 *  @param payWay    支付类型 1：单一易手付
 */
- (void)drawWithOrderpayment:(NSInteger)paymethod memWithType:(NSString *)memType payWithWay:(YJPayWay )payWay {
    HUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:HUD];
    [self.view bringSubviewToFront:HUD];
    HUD.label.text = @"支付请求中...";
    [HUD showAnimated: YES];
    
    NSDictionary *postdata = @{@"payCode":_payCode,
                               @"payMethod":[NSString stringWithFormat:@"%zd",paymethod]
                               };
    
    [[NetWorkManager shareManager]netWWorkWithReqUrl:SERVER_YJF ReqParam:postdata BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
        [HUD hideAnimated:YES];
        
        NSLog(@"订单号:%@",dicStr);
        if(fail_success){ //网络成功
            if ([dicStr[@"code"] intValue] == 200) {
                
                NSDictionary *dic = dicStr[@"data"];
                self.orderId = dic[@"tradeNo"];
                self.userid = dic[@"userId"];
                //易极付初始化配置
                [self startYJPay];
           
                NSString *tradeNo = self.orderId;
                if (tradeNo.length == 0 || self.userid == nil) {
                    [MyUtile showAlertViewByMsg:@"获取订单错误！" vc:self];
                    return;
                }
                
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setObject:self.orderId forKey:kYJPayTradeNo];
                [params setObject:@(payWay) forKey:kYJPayWay];
                
                //易极付支付，必传userid和usertype
                if (payWay == YJPayWayNone || payWay & YJPayWayYiji || payWay & YJPayWaySuper) {
                    
                    [params setObject:self.userid forKey:kYJPayUserId];
                    [params setObject:memType forKey:kYJPayUserType];
                }
              
                //是否需要显示取消结果页
                BOOL cancelRlt = NO;
                [params setObject:@(cancelRlt) forKey:kYJPayCancelResult];
                
                NSLog(@"支付提交参数%@",params);
                //启动支付
                [YJPayService startPayment:params delegate:self error:nil];
                
            }else {
                
                [MyUtile showAlertViewByMsg:@"获取订单数据失败" vc:self];
            }
            
        }else{
            
            [MyUtile showAlertViewByMsg:@"网络加载失败！" vc:self];
        }
        
    }];

}



#pragma mark - YJPayDelegate methods
- (void)payEngineDidBegin {
    
}

- (void)payEngineDidFinish:(NSString *)type code:(id)code extInfo:(NSDictionary *)info {
        NSLog(@"type:%zd, code:%@, extInfo:%@", type.integerValue, code, info);
//        NSString *msg = [NSString stringWithFormat:@"errcode:%@, errmsg:%@", code, info[@"msg"]];
//        [[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil] show];
    
    switch (type.integerValue) {
        case 1:{//易极付
            if ([code integerValue] == YJPayErrorCodeSuccess) {//成功
                
                [MobClick event:@"pay_quick_success" label:@"快捷支付成功"];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"交易成功" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    
                    MAMyOrdersViewController* vc = [[MAMyOrdersViewController alloc] init];
                    vc.preSelectedHeaderBtnTag = 2;//需要验证是否正确
                    vc.shouldGoBackToRootController = YES;
                    
                    [self.navigationController pushViewController: vc animated:YES];
                }];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
                
                
            }else if ([code integerValue] == YJPayErrorCodeProcessing ) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"订单处理中" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    MAMyOrdersViewController* vc = [[MAMyOrdersViewController alloc] init];
                    vc.preSelectedHeaderBtnTag = 2;//需要验证是否正确
                    vc.shouldGoBackToRootController = YES;
                    [self.navigationController pushViewController: vc animated:YES];
                }];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }else if ([code integerValue] == YJPayErrorCodeFailed) {
                
                [MobClick event:@"pay_quick_failed" label:@"快捷支付失败"];
                [MyUtile showAlertViewByMsg:@"订单支付失败!" vc:self];
            }else if ([code integerValue] == YJPayErrorCodeCancel) {
                
                [MobClick event:@"pay_quick_cancel" label:@"快捷支付取消"];
                [MyUtile showAlertViewByMsg:@"您已经取消支付!" vc:self];
            }
            
        }
            break;
        case 2:{//银联
            
            if([code isEqualToString:@"success"]) {
                
                [MobClick event:@"pay_union_success" label:@"银联支付成功"];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"交易成功" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    MAMyOrdersViewController* vc = [[MAMyOrdersViewController alloc] init];
                    vc.preSelectedHeaderBtnTag = 2;//需要验证是否正确
                    vc.shouldGoBackToRootController = YES;
                    [self.navigationController pushViewController: vc animated:YES];
                }];
                [alertController addAction:cancelAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
            }else if([code isEqualToString:@"fail"]) {//交易失败
                [MobClick event:@"pay_union_failed" label:@"银联支付失败"];
                [MyUtile showAlertViewByMsg:@"支付失败!" vc:self];
            }else if([code isEqualToString:@"cancel"]) { //交易取消
                [MobClick event:@"pay_union_cancel" label:@"银联支付取消"];
                [MyUtile showAlertViewByMsg:@"您已取消支付!" vc:self];
            }
        }
            
        default:
            break;
    }
}

#pragma - mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.payMethods.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SKPayWayCell *cell = [tableView dequeueReusableCellWithIdentifier:PayWayCell_id];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消cell被选中
    
    NSDictionary *dic = self.payMethods[indexPath.row];
    SKPayWallcellmodel *model = [SKPayWallcellmodel mj_objectWithKeyValues:dic];
    
    WS(weakSelf)
    //点击选中按钮的回调
    [cell setPoint:^(UIButton *pointBtn) {
        if (weakSelf.selectedBtn == pointBtn) {
            return ;
        }
        weakSelf.selectedBtn.selected = NO;
        pointBtn.selected = YES;
        weakSelf.selectedBtn = pointBtn;
    }];
    
    if (model.type == 6) {
        cell.pointBtn.selected = YES;
        self.selectedBtn = cell.pointBtn;
        cell.pointBtn.tag = SKPayWayFast;
        cell.seeLimitBtn.hidden = NO;
        cell.limitLabel.text = @"上限:单笔2-5万\n暂不支持信用卡";
        cell.iconImageView.image = [UIImage imageNamed:@"icon_quickpay_1x"];
        //点击查看额度回调
        [cell setSeeLimite:^{
            
            [weakSelf.navigationController pushViewController:[[SKBankMoneyLimiteVC alloc] init] animated:YES];
        }];
        return cell;
    }else if (model.type == 7){  //银联
        cell.limitLabel.text = @"上限:单笔5千";
        cell.iconImageView.image = [UIImage imageNamed:@"icon_unionpay_1x"];
        cell.pointBtn.tag = SKPayWayYinLian;
        
        return cell;
    }
    //        else {
    //
    //            cell.limitLabel.text = @"上限:单笔5千";
    //            cell.iconImageView.image = [UIImage imageNamed:@"icon_weixinpay_1x"];
    //            cell.pointBtn.tag = SKPayWayWeixin;
    //            return cell;
    //        }
    
    return cell;
}

#pragma - mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) return 44;
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
  return 100.f;
  
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0 ){
        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, SCREEN_WIDTH, 44)];
        customView.backgroundColor = [UIColor whiteColor];
        
        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, SCREEN_WIDTH-10, 30)];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.opaque = YES;
        headerLabel.textColor = [UIColor grayColor];
        headerLabel.highlightedTextColor = [UIColor grayColor];
        headerLabel.font = [UIFont systemFontOfSize:14];
        headerLabel.text = @"选择支付方式";
        [customView addSubview:headerLabel];
        //画线
        UIBezierPath* aPath = [UIBezierPath bezierPath];
        aPath.lineWidth = 5.0;
        
        aPath.lineCapStyle = kCGLineCapRound; //线条拐角
        aPath.lineJoinStyle = kCGLineCapRound; //终点处理
        [aPath moveToPoint:CGPointMake(customView.frame.origin.x, customView.frame.size.height- 1)];
        //[aPath addQuadCurveToPoint:CGPointMake(120, 100) controlPoint:CGPointMake(70, 0)];
        [aPath addLineToPoint:CGPointMake(customView.frame.size.width, customView.frame.size.height- 1)];
        CAShapeLayer *CurvedLineLayer=[CAShapeLayer layer];
        CurvedLineLayer.path = aPath.CGPath;
        CurvedLineLayer.fillColor = nil;
        CurvedLineLayer.strokeColor = BACKGROUND_COLOR.CGColor;
        [customView.layer addSublayer:CurvedLineLayer];
        
        return customView;
    }else{
        return nil;
    }
}

#pragma  - mark 懒加载
- (NSMutableArray *)payMethods {
    if (_payMethods == nil) {
        _payMethods = [NSMutableArray array];
    }
    return _payMethods;
}

@end
