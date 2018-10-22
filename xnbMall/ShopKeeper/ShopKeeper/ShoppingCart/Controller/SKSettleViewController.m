//
//  SKSettleViewController.m
//  ShopKeeper
//
//  Created by zzheron on 16/8/18.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "SKSettleViewController.h"
#import "SKUserAddressViewController.h"
#import "SKYiextremelyPayController.h"

#import "LoginViewController.h"
#import "JKURLSession.h"

@interface SKSettleViewController ()
@property (nonatomic) UIView *bottomView;

@property (nonatomic) UILabel *totalLabel;

@property (nonatomic) NSMutableArray *lisdata;
@property (nonatomic) NSDictionary *addr;
@property (nonatomic) NSString *comment;

@end

@implementation SKSettleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单提交";
    
    _lisdata = [[NSMutableArray alloc] init];
    _comment = @"";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollsToTop = YES;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    
    
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
    
    [self makeBottomView];
    [self defaultaddress];
     // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Touch events

- (void)commitOrder {

    NSString *isLoginStr = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:MALL_IS_LOGIN];
    NSLog(@"isLoginStr是否是商家 isLoginStr  = %@",isLoginStr);
    if(isLoginStr == nil || isLoginStr.length == 0){
        
        LoginViewController* vc = [[LoginViewController alloc]init];
        vc.loginResultBlock = ^(BOOL success){
            if(success) {
                [self ystsubmit];
            }
        };
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
        navi.navigationBar.translucent = NO;
        [navi.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        [self presentViewController:navi animated:YES completion:nil];
    }else {
        [self ystsubmit];
    }
}

-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return  1;
    if(section == 1)
        return  1;
    if(section == 2)
        return  1;
    if(section == 3)
        return  3;
    
    return  0;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    NSString *ID = [NSString stringWithFormat:@"MixBuyCell_%ld_%ld",indexPath.section,indexPath.row];
    //static NSString *ID = @"mainviewcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    if(indexPath.section == 0){
        if(_addr.count>0){
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20, 30)];
            nameLabel.textColor =  TEXTCURRENT_COLOR;
            nameLabel.font = [UIFont systemFontOfSize:14] ;
            nameLabel.text = [NSString stringWithFormat:@"%@  %@",_addr[@"contactName"],_addr[@"contactPhone"]];
            [cell.contentView addSubview:nameLabel];
            
            UILabel *addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 36, SCREEN_WIDTH-20, 40)];
            addrLabel.textColor = [UIColor grayColor];
            addrLabel.font = [UIFont systemFontOfSize:14] ;
            //addrLabel.backgroundColor = [UIColor greenColor];
            NSString *address = [NSString stringWithFormat:@"%@%@%@%@_%@"
                                 ,_addr[@"street"][@"province"][@"name"]
                                 ,_addr[@"street"][@"city"][@"name"]
                                 ,_addr[@"street"][@"county"][@"name"]
                                 ,_addr[@"street"][@"street"][@"name"]
                                 ,_addr[@"address"]];
            
            addrLabel.text = address;
            [cell.contentView addSubview:addrLabel];
        }else{
            UILabel *noaddress = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
            noaddress.textColor =  TEXTCURRENT_COLOR;
            noaddress.font = [UIFont systemFontOfSize:20] ;
            noaddress.textColor = KFontColor(@"#ec584c");
            noaddress.textAlignment = NSTextAlignmentCenter;
            noaddress.text = @"请点击添加收货地址！";
            [cell.contentView addSubview:noaddress];
        }
    }
    
    if(indexPath.section == 1){
        
        [self MakeDetailSection:cell ];
        
    }
    
    if(indexPath.section == 2){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *tatalgiftLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-170, 2 , 150, 40)];
        tatalgiftLabel.textColor =  TEXTCURRENT_COLOR;
        tatalgiftLabel.font = [UIFont systemFontOfSize:14] ;
        tatalgiftLabel.textAlignment = NSTextAlignmentRight;
        tatalgiftLabel.text = [NSString stringWithFormat:@"礼券余额：¥ %0.2f",[_data[@"totalGiftCardAmount"] floatValue]];
        [cell.contentView addSubview:tatalgiftLabel];
        
        UIButton *checkbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        checkbtn.frame = CGRectMake(5, 13, 20, 20);
        [checkbtn setImage:[UIImage imageNamed:@"uncheckedCircle"] forState:UIControlStateNormal];
        [checkbtn setImage:[UIImage imageNamed:@"tick"]  forState:UIControlStateSelected];
        if ([_usedGiftCard isEqualToString:@"true"]) {
            checkbtn.selected = YES;
        }else{
            checkbtn.selected = NO;
        }
        [checkbtn bk_addEventHandler:^(id sender) {
            checkbtn.selected = !checkbtn.selected;
            if(checkbtn.selected){
                _usedGiftCard = @"true";
                [MobClick event:@"order_commit_use_coupon" label:@"提交订单使用礼券"];
            }else{
                _usedGiftCard = @"false";
            }
            [self.tableView reloadData];
            [self RefreshBottomView ];
        } forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:checkbtn];
        
        UILabel *giftLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 2 , 150, 40)];
        giftLabel.textColor =  TEXTCURRENT_COLOR;
        giftLabel.font = [UIFont systemFontOfSize:14] ;
        giftLabel.text =[NSString stringWithFormat:@"礼券折扣：¥ %0.2f",[_data[@"giftCardAmount"] floatValue]];
        [cell.contentView addSubview:giftLabel];
        
    }
    
    if(indexPath.section == 3){
        if(indexPath.row == 0){
            UILabel *label_1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 2 , 150, 40)];
            label_1.textColor =  TEXTCURRENT_COLOR;
            label_1.font = [UIFont systemFontOfSize:14] ;
            label_1.text =@"商品金额";
            [cell.contentView addSubview:label_1];
            
            UILabel *label_2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-170, 2 , 150, 40)];
            label_2.textColor = KFontColor(@"#ec584c");
            label_2.font = [UIFont systemFontOfSize:14] ;
            label_2.textAlignment = NSTextAlignmentRight;
            label_2.text =[NSString stringWithFormat:@"¥ %0.2f",[_data[@"totalAmount"] floatValue]];
            [cell.contentView addSubview:label_2];
            
        }
        
        if(indexPath.row == 1){
            UILabel *label_1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 2 , 150, 40)];
            label_1.textColor =  TEXTCURRENT_COLOR;
            label_1.font = [UIFont systemFontOfSize:14] ;
            label_1.text =@"礼券";
            [cell.contentView addSubview:label_1];
            
            UILabel *label_2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-170, 2 , 150, 40)];
            label_2.textColor = KFontColor(@"#ec584c");
            label_2.font = [UIFont systemFontOfSize:14] ;
            label_2.textAlignment = NSTextAlignmentRight;
            if([_usedGiftCard isEqualToString:@"true"])
                label_2.text =[NSString stringWithFormat:@"- ¥ %0.2f",[_data[@"giftCardAmount"] floatValue]];
            else
                label_2.text =[NSString stringWithFormat:@"- ¥ %0.2f",0.00];
            
            [cell.contentView addSubview:label_2];
            
        }
        
        if(indexPath.row == 3){
            UILabel *label_1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 2 , 150, 40)];
            label_1.textColor =  TEXTCURRENT_COLOR;
            label_1.font = [UIFont systemFontOfSize:14] ;
            label_1.text =@"运费";
            [cell.contentView addSubview:label_1];
            
            UILabel *label_2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-170, 2 , 150, 40)];
            label_2.textColor = KFontColor(@"#ec584c");
            label_2.font = [UIFont systemFontOfSize:14] ;
            label_2.textAlignment = NSTextAlignmentRight;
            label_2.text =[NSString stringWithFormat:@"- ¥ %0.2f",[_data[@"freightFee"] floatValue]];
            
            [cell.contentView addSubview:label_2];
        }
    }
    return cell;
}


#pragma  mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) return 0.001;
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 80;
    if(indexPath.section == 1){
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    return 44;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section >0 ){
        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, SCREEN_WIDTH, 44)];
        customView.backgroundColor = [UIColor whiteColor];
        
        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-10, 30)];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.opaque = YES;
        headerLabel.textColor = KFontColor(@"#ec584c");
        headerLabel.highlightedTextColor = [UIColor lightGrayColor];
        headerLabel.font = [UIFont systemFontOfSize:14];
        
        if(section == 1)
            headerLabel.text =  @"订单详情";
        if(section == 2)
            headerLabel.text =  @"礼券";
        if(section == 3)
            headerLabel.text =  @"应付金额";
        
        [customView addSubview:headerLabel];
        return customView;
    }else{
        return nil;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0){
        if(_addr.count>0){
            SKUserAddressViewController *vc = [[SKUserAddressViewController alloc] init];
            vc.delegate=self;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ChangeAddressViewCtr *vc = [[ChangeAddressViewCtr alloc] init];
            vc.delegate=self;
            vc.isDefault = @"1";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

//初始化tableView时设置
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero]; }
}



//创建商品详情的cell
-(void)MakeDetailSection:(UITableViewCell*)cell {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *iv = [UIView new];
    iv.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, 35);
    iv.backgroundColor = [UIColor clearColor];
    
    float fhight = 5;
    
    NSArray *templateGoodsList = _data[@"templateGoodsList"];
    for(int n=0;n<templateGoodsList.count;n++){
        NSDictionary *dic = templateGoodsList[n];
        NSInteger mixBuy = [dic[@"mixBuy"] integerValue];
        //增订量
        UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, fhight, SCREEN_WIDTH-22, 30)];
        headLabel.textColor = TEXTCURRENT_COLOR;
        fhight += 30;
        if(mixBuy == 1){  //支持混批
            headLabel.text = [NSString stringWithFormat:@"%@", dic[@"templateDescription"]];
        }else{
            headLabel.text = @"不支持混批";
        }
        headLabel.font = [UIFont systemFontOfSize:14];
        [iv addSubview:headLabel];
        
        NSArray *goodsList = dic[@"goodsList"];
        
        //高90
        for(int i=0;i<goodsList.count;i++){
            //增加起订下自定义线条
            UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, fhight, SCREEN_WIDTH, 0.5)];
            lineLabel.backgroundColor = ColorFromRGB(190.f,189.f,195.f); //229
            [iv addSubview:lineLabel];
            NSDictionary *dic2 = goodsList[i];
            
            //商品主图
            UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, fhight+10, 70, 70)];
            [logoImg sd_setImageWithURL:dic2[@"logoUrl"] placeholderImage:[UIImage imageNamed:@"commonPlaceHolderIcon"] completed:nil];
            
            //商品描述
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, fhight+10, SCREEN_WIDTH-190, 60)];
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.text = dic2[@"goodsTitle"];
            titleLabel.textColor = [UIColor grayColor];
            titleLabel.numberOfLines = 4;
            [titleLabel sizeToFit];
            
            //商品价格
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, fhight+20, 90, 25)];
            priceLabel.font = [UIFont systemFontOfSize:14];
            priceLabel.text = [NSString stringWithFormat:@"¥ %0.2f",[dic2[@"price"] floatValue]];
            priceLabel.textColor = KFontColor(@"#ec584c");
            [priceLabel sizeToFit];
            
            //件数
            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, fhight+45, 90, 25)];
            numberLabel.font = [UIFont systemFontOfSize:14];
            numberLabel.textColor = TEXTCURRENT_COLOR;
            numberLabel.text = [NSString stringWithFormat:@"x%@",dic2[@"number"]];
            [numberLabel sizeToFit];
            
            [iv addSubview:logoImg];
            [iv addSubview:titleLabel];
            [iv addSubview:priceLabel];
            [iv addSubview:numberLabel];

            fhight+=90;
        }
        
        //自定义分组线
        UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, fhight, SCREEN_WIDTH, 10)];
        footLabel.backgroundColor = ColorFromRGB(190.f,189.f,195.f);
        [iv addSubview:footLabel];
        fhight+=10;
    }
    //间隔线
    UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, fhight, SCREEN_WIDTH, 0.5)];
    lineLabel1.backgroundColor = ColorFromRGB(190.f,189.f,195.f);
    [iv addSubview:lineLabel1];
    
    UILabel *headLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(2, fhight, SCREEN_WIDTH-22, 30)];
    headLabel1.text = @"买家留言：";
    headLabel1.font = [UIFont systemFontOfSize:14];
    headLabel1.textColor = TEXTCURRENT_COLOR;
    [iv addSubview:headLabel1];
    fhight+=30;
    
    UITextField *commentField = [[UITextField alloc] initWithFrame:CGRectMake(10, fhight+3, SCREEN_WIDTH-32, 50)];
    commentField.delegate = self;
    commentField.returnKeyType = UIReturnKeyDone;  //键盘返回类型
    commentField.backgroundColor = HEXCOLOR(0xF5F5F5FF);
    commentField.text = _comment;
    [iv addSubview:commentField];
    
    fhight+=60;
    
    iv.frame = CGRectMake(5, 0, SCREEN_WIDTH-10, fhight);
    [cell.contentView addSubview:iv];
    cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, fhight);
}

#pragma mark -

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint origin = textField.frame.origin;
    CGPoint point = [textField.superview convertPoint:origin toView:self.tableView];
    float navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGPoint offset = self.tableView.contentOffset;
    if(point.y > (self.view.frame.size.height-navBarHeight-256)){
        offset.y = (point.y - (self.view.frame.size.height-navBarHeight-256) + 22);
        [self.tableView setContentOffset:offset animated:YES];
        
    }
    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _comment = textField.text;
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
 
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



#pragma mark - 

-(void)makeBottomView {
    _bottomView = [UIView new];
    [self.view addSubview:_bottomView];
    WS(ws);
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view).offset(0);
        make.right.equalTo(ws.view).offset(0);
        make.bottom.equalTo(ws.view).offset(0);
        make.height.equalTo(@(50)).priorityLow();
    }];
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    //分割线
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.2)];
    line.backgroundColor = [UIColor grayColor];
    [_bottomView addSubview:line];
    
    
    UIButton *btn_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_1 setTitle:@"提交订单" forState:UIControlStateNormal];
    btn_1.backgroundColor = KBackColor(@"#ec584c");
    [btn_1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_1 addTarget:self action:@selector(commitOrder) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomView addSubview:btn_1];
    
    [btn_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomView.mas_right).offset(0);
        make.top.bottom.equalTo(_bottomView);
        make.width.equalTo(@100);
    }];
     //支付金额
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
    _totalLabel.font = [UIFont systemFontOfSize:14];
    
    [_bottomView addSubview:_totalLabel];
    
    [self RefreshBottomView];
    
}

-(void)RefreshBottomView{
    
    float totalprice = 0;
    if(_data[@"totalAmount"] != nil){
        if ([_usedGiftCard isEqualToString:@"true"])
            totalprice = [_data[@"totalAmount"] floatValue]-[_data[@"giftCardAmount"] floatValue];
        else
            totalprice = [_data[@"totalAmount"] floatValue] ;
    }
    
    if (totalprice < 0) {
        totalprice = 0;
    }
    
    NSString *strlabel = [NSString stringWithFormat:@"应付金额： ¥ %0.2f  ",totalprice];
    NSRange range1 = [strlabel rangeOfString:@"¥"];
    //NSRange range2 = [strlabel rangeOfString:@" ("];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strlabel];
    [str addAttribute:NSForegroundColorAttributeName
                value:[UIColor redColor]
                range:NSMakeRange(range1.location,strlabel.length-range1.location)];
    
    _totalLabel.attributedText = str;
    
}

-(void)changeAddress:(NSDictionary*)value{
    _addr = value;
    _areaId = _addr[@"tareaId"];
    [self ystsettle11];
}

-(void)GetNewDefultAddress{
    [self defaultaddress];
}

#pragma mark - 

-(void)defaultaddress{
    
    [JKURLSession taskWithMethod:@"user/defaultaddress.do" parameter:nil token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error == nil) {
                
                _addr = resultDic[@"addr"];
                
                [self.tableView reloadData];
            }else {
                [self showAutoDissmissHud:error.localizedDescription];
            }
        });
    }];
}

-(void)ystsettle11{
    NSDictionary *postdata = @{@"goods":_goods,
                               @"usedGiftCard":_usedGiftCard,
                               @"raid":_areaId};
    
    [JKURLSession taskWithMethod:@"order/settle.do" parameter:postdata token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error == nil) {
                
                _data = resultDic[@"data"];
                [self.tableView reloadData];
                [self RefreshBottomView];
            }else {
                [self showAutoDissmissHud:error.localizedDescription];
            }
        });
    }];
}


-(void)ystsubmit{
    
    NSLog(@"_addr:%@",_addr);
    if (_addr[@"id"]) {
        
    }else{
    
        [MyUtile showAlertViewByMsg:@"请添加收货地址" vc:self];
        return;
    }
    
    NSDictionary *postdata = @{@"goods":_goods,
                               @"usedGiftCard":_usedGiftCard,
                               @"addrId":_addr[@"id"],
                               @"comment":_comment
                               };
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [JKURLSession taskWithMethod:@"order/submit.do" parameter:postdata token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            if (error == nil) {
                [MobClick event:@"order_commit_success" label:@"提交订单成功"];
                SKYiextremelyPayController *vc = [[SKYiextremelyPayController alloc]init];
                vc.payCode = resultDic[@"data"][@"payCode"];
                vc.orderId = resultDic[@"data"][@"orderId"];
                vc.productName = @"新农宝商城";
                vc.productDescription = @"新农宝商城";
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                [MobClick event:@"order_commit_failed" label:@"提交订单使失败"];
                [self showAutoDissmissHud:error.localizedDescription];
            }
        });
    }];
}
@end
