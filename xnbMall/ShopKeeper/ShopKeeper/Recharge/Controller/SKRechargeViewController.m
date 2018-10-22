//
//  SKRechargeViewController.m
//  ShopKeeper
//
//  Created by zzheron on 16/6/23.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "SKRechargeViewController.h"
#import "BlocksKit.h"
#import "BlocksKit+UIKit.h"
#import "Utils.h"
#import "NSString+Utils.h"


@interface SKRechargeViewController ()
@property(nonatomic) UIScrollView *scroll;
@property(nonatomic) UILabel *slidLabel;
@property(nonatomic) UIView *headtab;


@property(nonatomic) UITextField *mobile_1;
@property(nonatomic) UITextField *mobile_2;
@property(nonatomic) UITextField *amount_1;

@property(nonatomic) UILabel *amountLabel;
@property(nonatomic) NSString *payment_1;//金额显示
@property(nonatomic) NSString *payment_2;//金额显示


@end

@implementation SKRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充值";
    self.view.backgroundColor = HEXCOLOR(0xF2F2F2ff);
    
    [self makeHeaderTabView];
    [self makeHeaderScrollView];
    
    
    
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)makeHeaderTabView{
    
    _headtab = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)] ;
    _headtab.backgroundColor = [UIColor whiteColor];
    UIButton *btn_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *btn_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn_1.frame = CGRectMake(0, 0, SCREEN_WIDTH/2-0.5, 44);
    btn_2.frame = CGRectMake(SCREEN_WIDTH/2+0.5, 0, SCREEN_WIDTH/2-0.5, 44);
    
    UILabel *center = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-0.5, 10, 1, 24)];
    center.backgroundColor = [UIColor grayColor];
    
    [_headtab addSubview:btn_1];
    [_headtab addSubview:btn_2];
    [_headtab addSubview:center];
    //btn_1.backgroundColor = [UIColor brownColor];
    //btn_2.backgroundColor = [UIColor greenColor];
    [btn_1 setTitle:@"充话费" forState:UIControlStateNormal];
    [btn_2 setTitle:@"充货款" forState:UIControlStateNormal];
    
    UIColor *clor =  HEXCOLOR(0xEE2C2Cff);
    
    [btn_1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn_2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    [btn_1 setTitleColor:clor forState:UIControlStateSelected];
    [btn_2 setTitleColor:clor forState:UIControlStateSelected];

    

    _slidLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH/2, 1)];
    _slidLabel.backgroundColor =  clor;
    
    [btn_1 setSelected:YES];
    
    [btn_1 bk_addEventHandler:^(id sender) {
        [UIView beginAnimations:nil context:nil];//动画开始
        [UIView setAnimationDuration:0.1];
        [btn_1 setSelected:YES];
        [btn_2 setSelected:NO];
        _slidLabel.frame = CGRectMake(0, 44, SCREEN_WIDTH/2, 1);
        [_scroll setContentOffset:CGPointMake(0*SCREEN_WIDTH, 0)];
        [UIView commitAnimations];
    } forControlEvents:UIControlEventTouchUpInside];

    [btn_2 bk_addEventHandler:^(id sender) {
        [UIView beginAnimations:nil context:nil];//动画开始
        [UIView setAnimationDuration:0.1];
        [btn_2 setSelected:YES];
        [btn_1 setSelected:NO];
        _slidLabel.frame = CGRectMake(SCREEN_WIDTH/2, 44, SCREEN_WIDTH/2, 1);
        [_scroll setContentOffset:CGPointMake(1*SCREEN_WIDTH, 0)];
        [UIView commitAnimations];
    } forControlEvents:UIControlEventTouchUpInside];

    
    [self.view addSubview:_headtab];
    [self.view addSubview:_slidLabel];

}


-(void)makeHeaderScrollView{
    _scroll = [[UIScrollView alloc] init];
    _scroll.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scroll];
    WS(ws);
    [_scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view).with.insets(UIEdgeInsetsMake(48, 0, 0, 0));
    }];
    
    _scroll.pagingEnabled = NO;//设为YES时，会按页滑动
    _scroll.bounces = YES;//取消UIScrollView的弹性属性，这个可以按个人喜好来定
    _scroll.contentSize = CGSizeMake( 2 * SCREEN_WIDTH, SCREEN_HEIGHT-160);
    _scroll.delegate = self;
    _scroll.scrollEnabled = NO;

    UIColor *clor1 =  [UIColor grayColor];
    UIColor *clor2 =  HEXCOLOR(0xEE2C2Cff);

    UIView *vv1  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-160)];
    [_scroll addSubview:vv1];
    
    _mobile_1 = [[UITextField alloc] init];
    _mobile_1.placeholder = @"请输入要充值的手机号码";
    _mobile_1.layer.cornerRadius = 5.0;
    _mobile_1.layer.borderWidth = 0.5;
    _mobile_1.layer.borderColor = clor1.CGColor;
    _mobile_1.backgroundColor = [UIColor whiteColor];
    _mobile_1.keyboardType = UIKeyboardTypeNumberPad;

    [vv1 addSubview:_mobile_1];
    
    
    [_mobile_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vv1).offset(10);
        make.left.equalTo(vv1.mas_left).offset(20);
        make.right.equalTo(vv1.mas_right).offset(-20);
        make.height.mas_equalTo(@(40));
    }];
    

    UIButton *btn_a1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *btn_a2 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *btn_a3 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *btn_a4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_a1 setTitle:@"30元" forState:UIControlStateNormal];
    [btn_a2 setTitle:@"50元" forState:UIControlStateNormal];
    [btn_a3 setTitle:@"100元" forState:UIControlStateNormal];
    [btn_a4 setTitle:@"300元" forState:UIControlStateNormal];
    [vv1 addSubview:btn_a1];
    [vv1 addSubview:btn_a2];
    [vv1 addSubview:btn_a3];
    [vv1 addSubview:btn_a4];
    
    btn_a1.backgroundColor = [UIColor whiteColor];
    btn_a1.layer.borderColor = clor1.CGColor;
    btn_a1.layer.cornerRadius = 5.0;
    btn_a1.layer.borderWidth = 0.5;
    [btn_a1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn_a1 setTitleColor:clor2 forState:UIControlStateSelected];


    btn_a2.backgroundColor = [UIColor whiteColor];
    btn_a2.layer.borderColor = clor1.CGColor;
    btn_a2.layer.cornerRadius = 5.0;
    btn_a2.layer.borderWidth = 0.5;
    [btn_a2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn_a2 setTitleColor:clor2 forState:UIControlStateSelected];
    
    btn_a3.backgroundColor = [UIColor whiteColor];
    btn_a3.layer.borderColor = clor1.CGColor;
    btn_a3.layer.cornerRadius = 5.0;
    btn_a3.layer.borderWidth = 0.5;
    [btn_a3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn_a3 setTitleColor:clor2 forState:UIControlStateSelected];
    
    btn_a4.backgroundColor = [UIColor whiteColor];
    btn_a4.layer.borderColor = clor1.CGColor;
    btn_a4.layer.cornerRadius = 5.0;
    btn_a4.layer.borderWidth = 0.5;
    [btn_a4 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn_a4 setTitleColor:clor2 forState:UIControlStateSelected];
    
    float lwth = (SCREEN_WIDTH - 40 - 20)/3;
    
    [btn_a1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mobile_1.mas_bottom).offset(10);
        make.left.equalTo(vv1.mas_left).offset(20);
        make.width.mas_equalTo(@(lwth));
        make.height.mas_equalTo(@(30));
    }];
   
    [btn_a2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mobile_1.mas_bottom).offset(10);
        make.left.equalTo(btn_a1.mas_right).offset(10);
        make.width.mas_equalTo(@(lwth));
        make.height.mas_equalTo(@(30));
    }];
    
    [btn_a3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mobile_1.mas_bottom).offset(10);
        make.left.equalTo(btn_a2.mas_right).offset(10);
        make.width.mas_equalTo(@(lwth));
        make.height.mas_equalTo(@(30));
    }];
    
    [btn_a4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn_a1.mas_bottom).offset(10);
        make.left.equalTo(vv1.mas_left).offset(20);
        make.width.mas_equalTo(@(lwth));
        make.height.mas_equalTo(@(30));
    }];
    
    [btn_a1 bk_addEventHandler:^(id sender) {
        [btn_a1 setSelected:YES];
        [btn_a2 setSelected:NO];
        [btn_a3 setSelected:NO];
        [btn_a4 setSelected:NO];
        btn_a1.layer.borderColor = clor2.CGColor;
        btn_a2.layer.borderColor = clor1.CGColor;
        btn_a3.layer.borderColor = clor1.CGColor;
        btn_a4.layer.borderColor = clor1.CGColor;
        [self changeAmount:@"30"];
    } forControlEvents:UIControlEventTouchUpInside];

    [btn_a2 bk_addEventHandler:^(id sender) {
        [btn_a2 setSelected:YES];
        [btn_a1 setSelected:NO];
        [btn_a3 setSelected:NO];
        [btn_a4 setSelected:NO];
        btn_a2.layer.borderColor = clor2.CGColor;
        btn_a1.layer.borderColor = clor1.CGColor;
        btn_a3.layer.borderColor = clor1.CGColor;
        btn_a4.layer.borderColor = clor1.CGColor;
        [self changeAmount:@"50"];
    } forControlEvents:UIControlEventTouchUpInside];

    [btn_a3 bk_addEventHandler:^(id sender) {
        [btn_a3 setSelected:YES];
        [btn_a2 setSelected:NO];
        [btn_a1 setSelected:NO];
        [btn_a4 setSelected:NO];
        btn_a3.layer.borderColor = clor2.CGColor;
        btn_a2.layer.borderColor = clor1.CGColor;
        btn_a1.layer.borderColor = clor1.CGColor;
        btn_a4.layer.borderColor = clor1.CGColor;
        [self changeAmount:@"100"];
    } forControlEvents:UIControlEventTouchUpInside];

    [btn_a4 bk_addEventHandler:^(id sender) {
        [btn_a4 setSelected:YES];
        [btn_a2 setSelected:NO];
        [btn_a3 setSelected:NO];
        [btn_a1 setSelected:NO];
        btn_a4.layer.borderColor = clor2.CGColor;
        btn_a2.layer.borderColor = clor1.CGColor;
        btn_a3.layer.borderColor = clor1.CGColor;
        btn_a1.layer.borderColor = clor1.CGColor;
        [self changeAmount:@"300"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    _amountLabel = [[UILabel alloc] init];
    [vv1 addSubview:_amountLabel];

    [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn_a4.mas_bottom).offset(10);
        make.left.equalTo(vv1.mas_left).offset(20);
        make.width.mas_equalTo(@(2*lwth));
        make.height.mas_equalTo(@(30));
    }];

    
    [btn_a2 setSelected:YES];
    btn_a2.layer.borderColor = clor2.CGColor;
    [self changeAmount:@"50"];

    
    UIButton *btn_submint1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [vv1 addSubview:btn_submint1];
    [btn_submint1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_submint1.titleLabel.font = [UIFont systemFontOfSize:20];
    btn_submint1.backgroundColor = clor2;
    btn_submint1.layer.cornerRadius = 5.0;
    //btn_submint1.layer.borderWidth = 0.5;
    [btn_submint1 setTitle:@"立即充值" forState:UIControlStateNormal];
    [btn_submint1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_amountLabel.mas_bottom).offset(20);
        make.left.equalTo(vv1.mas_left).offset(50);
        make.right.equalTo(vv1.mas_right).offset(-50);
        make.height.mas_equalTo(@(40));
    }];
    
 
    [btn_submint1 bk_addEventHandler:^(id sender) {
        NSString *mobiletxt = _mobile_1.text;
        if(![NSString validateMobile:mobiletxt]){
            [MyUtile showAlertViewByMsg:@"请输入11位手机号" vc:self];
            return;
        }
        
        [self phonebill];
    } forControlEvents:UIControlEventTouchUpInside];

    
    UIView *vv2  = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH,0,SCREEN_WIDTH,SCREEN_HEIGHT-160)];
    [_scroll addSubview:vv2];
    
    _mobile_2 = [[UITextField alloc] init];
    _mobile_2.placeholder = @"请输入手机号码";
    _mobile_2.layer.cornerRadius = 5.0;
    _mobile_2.layer.borderWidth = 0.5;
    _mobile_2.layer.borderColor = clor1.CGColor;
    _mobile_2.keyboardType = UIKeyboardTypeNumberPad;
    _mobile_2.backgroundColor = [UIColor whiteColor];
    
    [vv2 addSubview:_mobile_2];
    
    [_mobile_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vv2).offset(10);
        make.left.equalTo(vv2.mas_left).offset(20);
        make.right.equalTo(vv2.mas_right).offset(-20);
        make.height.mas_equalTo(@(40));
    }];
 
    _amount_1 = [[UITextField alloc] init];
    _amount_1.placeholder = @"请输入货款金额，目前支持100元整数倍金额";
    _amount_1.layer.cornerRadius = 5.0;
    _amount_1.layer.borderWidth = 0.5;
    _amount_1.layer.borderColor = clor1.CGColor;
    _amount_1.backgroundColor = [UIColor whiteColor];
    _amount_1.keyboardType = UIKeyboardTypeNumberPad;
    
    [vv2 addSubview:_amount_1];
    
    [_amount_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mobile_2.mas_bottom).offset(20);
        make.left.equalTo(vv2.mas_left).offset(20);
        make.right.equalTo(vv2.mas_right).offset(-20);
        make.height.mas_equalTo(@(40));
    }];
    
    UILabel *label_1 = [[UILabel alloc] init];
    [vv2 addSubview:label_1];
    [label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_amount_1.mas_bottom).offset(10);
        make.left.equalTo(vv2.mas_left).offset(20);
        make.right.equalTo(vv2.mas_right).offset(-20);
        make.height.mas_equalTo(@(40));
    }];
    label_1.text = @"备注：充货款金额会充到对方的个人钱包-不可提现余额中，只能消费不能提现~";
    label_1.font = [UIFont systemFontOfSize:14];
    label_1.numberOfLines = 2;
    [label_1 sizeToFit];
    
    
    UIButton *btn_submint2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [vv2 addSubview:btn_submint2];
    [btn_submint2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_submint2.titleLabel.font = [UIFont systemFontOfSize:20];
    btn_submint2.backgroundColor = clor2;
    btn_submint2.layer.cornerRadius = 5.0;
    //btn_submint1.layer.borderWidth = 0.5;
    [btn_submint2 setTitle:@"立即充值" forState:UIControlStateNormal];
    [btn_submint2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label_1.mas_bottom).offset(30);
        make.left.equalTo(vv2.mas_left).offset(50);
        make.right.equalTo(vv2.mas_right).offset(-50);
        make.height.mas_equalTo(@(40));
    }];
    
    
    [btn_submint2 bk_addEventHandler:^(id sender) {
        NSString *mobiletxt = _mobile_2.text;
        if(![NSString validateMobile:mobiletxt]){
            [MyUtile showAlertViewByMsg:@"请输入11位手机号！" vc:self];
            return;
        }
        
        if(![NSString isPureInt:_amount_1.text]){
            [MyUtile showAlertViewByMsg:@"请填写100的倍数金额！" vc:self];
            return;
        }
        
        NSInteger issss = [_amount_1.text integerValue];
        
        if(issss%100 != 0){
            [MyUtile showAlertViewByMsg:@"请填写100的倍数金额！" vc:self];
            return;
        }
        
        [self rechargepayment];
        
    } forControlEvents:UIControlEventTouchUpInside];
  
    
}


-(void)changeAmount:(NSString*) amount{
    _payment_1 = amount;
    
    [self phonebillfee];
}


-(void)changeAmount1:(NSString*) amount{
    _payment_2 = amount;
    NSString *strlabel = [NSString stringWithFormat:@"单价: %@",amount];
    NSRange range1 = [strlabel rangeOfString:@" "];
    
    UIColor *clor = HEXCOLOR(0xEE2C2Cff);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strlabel];
    [str addAttribute:NSForegroundColorAttributeName
                value:clor
                range:NSMakeRange(range1.location, [strlabel length] - range1.location)];
    
    _amountLabel.attributedText = str;
}



-(void)phonebill{
    
        NSLog(@"_adxdr:%@",_payment_1);
        NSDictionary *postdata = @{@"phone":_mobile_1.text,
                                   @"amount":_payment_1
                                   };
    
        NSString *surl = [NSString stringWithFormat:@"%@/recharge/phonebill.do",SERVER_ADDR_XNBMALL];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
        NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];
    
        [manager POST:surl parameters:postdata progress:^(NSProgress * _Nonnull uploadProgress) {
            //
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
    
            NSLog(@"phonebill:%@",retdata);
            NSInteger code = [[retdata objectForKey:@"code"] integerValue];
            if(code == 200){
//                SKPayViewController *vc = [[SKPayViewController alloc] init];
//                vc.payCode = retdata[@"data"][@"payCode"];
//                vc.orderId = retdata[@"data"][@"orderId"];
//                vc.productName = @"新农宝手机充值";
//                vc.productDescription = [NSString stringWithFormat:@"新农宝手机充值，手机号码：%@，充值金额：%@",_mobile_1.text,_payment_2];
//                [self.navigationController pushViewController:vc animated:YES];
    
            }else{
                [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
        }];
        
}



-(void)phonebillfee{
    
    //NSLog(@"_addr:%@",_addr);
    NSDictionary *postdata = @{@"phone":_mobile_1.text,
                               @"amount":_payment_1
                               };
    NSString *surl = [NSString stringWithFormat:@"%@/recharge/phonebillfee.do",SERVER_ADDR_XNBMALL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];
    
    [manager POST:surl parameters:postdata progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        
        NSLog(@"phonebillfee:%@",retdata);
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            [self changeAmount1:retdata[@"data"][@"amount"]];
        }else{
            [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
    }];
    
    
}


-(void)rechargepayment{
    
    //NSLog(@"_addr:%@",_addr);
    NSDictionary *postdata = @{@"phone":_mobile_2.text,
                               @"amount":_amount_1.text
                               };
    
    //NSLog(@"postdata:%@",postdata);
    NSString *surl = [NSString stringWithFormat:@"%@/recharge/payment.do",SERVER_ADDR_XNBMALL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];
    
    [manager POST:surl parameters:postdata progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        
        NSLog(@"recharge_payment:%@",retdata);
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
//            SKPayViewController *vc = [[SKPayViewController alloc] init];
//            vc.payCode = retdata[@"data"][@"payCode"];
//            vc.orderId = retdata[@"data"][@"orderId"];
//            vc.productName = @"新农宝充货款";
//            vc.productDescription = [NSString stringWithFormat:@"新农宝充货款，手机号码：%@，充值金额：%@",_mobile_2.text,_amount_1.text];
//            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
    }];
    
}

@end
