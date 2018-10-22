//
//  SKPointExchangeViewController.m
//  ShopKeeper
//
//  Created by zzheron on 16/9/8.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "SKPointExchangeViewController.h"
#import "MAMyOrdersViewController.h"
#import "LoginViewController.h"

@interface SKPointExchangeViewController () {
    
    UITextField *_commentField;
    
    JKView *_mask;                                  //弹出键盘时，遮住scrollview禁止滚动

    CGFloat _tfBottom;                              //输入框底部 在tableview中的坐标
    CGSize _tempTableViewContentSize;
}

@property (nonatomic) UIView *bottomView;


@property (nonatomic) NSDictionary *addr;
@property (nonatomic) NSString *comment;

@property (nonatomic) UILabel *totalLabel;

@end

@implementation SKPointExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单提交";
    
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
    
    [self makeBottomView];
    [self defaultaddress];

    // Do any additional setup after loading the view.
    _mask = [[JKView alloc] initWithFrame:_tableView.frame];
    [_mask addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskTap:)]];
    [self.view addSubview:_mask];
    _mask.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Touch events

- (void)maskTap:(id)sender {
    
    [_tableView endEditing:YES];
}

- (void)commitOrder {
    
    NSString *isLoginStr = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:MALL_IS_LOGIN];
    NSLog(@"isLoginStr是否是商家 isLoginStr  = %@",isLoginStr);
    if(isLoginStr == nil || isLoginStr.length == 0){
        
        LoginViewController* vc = [[LoginViewController alloc]init];
        vc.loginResultBlock = ^(BOOL success){
            if(success) {
                [self pointsexchange];
            }
        };
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
        navi.navigationBar.translucent = NO;
        [navi.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        [self presentViewController:navi animated:YES completion:nil];
    }else {
        [self pointsexchange];
    }
}

#pragma mark - keyboard notification

- (void)keboardShow:(NSNotification *)notification{
    
    _mask.hidden = NO;
    
    _tempTableViewContentSize = _tableView.contentSize;
    //键盘高度发生变化时也会被执行
    NSDictionary *userDic = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userDic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardH = keyboardF.size.height;
    
    CGFloat contentHeight = SCREEN_HEIGHT - 64.f;
    
    NSLog(@"tfBottom = %f,contentHeight = %f",_tfBottom,contentHeight);
    NSLog(@"keyboardF.h = %f",keyboardF.size.height);
    
    CGFloat bottomY = _commentField.frame.origin.y + _commentField.frame.size.height;
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    CGPoint point = [cell convertPoint:CGPointMake(_commentField.frame.origin.x, bottomY) toView:_tableView];
    
    _tfBottom =  point.y + 30.f + 5.f;
    
    if (_tfBottom + keyboardH > contentHeight) {
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat indent = (_tfBottom + keyboardH - contentHeight);
            NSLog(@"indent = %f",indent);
            
            CGSize size = _tempTableViewContentSize;
            size.height = size.height + indent;
            [_tableView setContentSize:size];
            
            [_tableView setContentOffset:CGPointMake(0.f, indent) animated:YES];
        });
    }
}

- (void)keboardHide:(NSNotification *)notification{
    
    _mask.hidden = YES;
    
    CGSize size = _tempTableViewContentSize;
    [_tableView setContentSize:size];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25f animations:^{
            CGRect tableFrame = _tableView.frame;
            tableFrame.origin.y = 0;
            [_tableView setFrame:tableFrame];
        }];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return 1;
    if(section == 1) return 2;
    return 0;
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


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) return 0.01;
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    NSString *ID = [NSString stringWithFormat:@"wweeqwrewqweq%ld_%ld",indexPath.section,indexPath.row];
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
            nameLabel.textColor = KFontColor(@"#646464");
            
            nameLabel.font = [UIFont systemFontOfSize:14] ;
            nameLabel.text = [NSString stringWithFormat:@"%@  %@",_addr[@"contactName"],_addr[@"contactPhone"]];
            [cell.contentView addSubview:nameLabel];
            
            UILabel *addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 36, SCREEN_WIDTH-20, 40)];
            addrLabel.textColor = [UIColor grayColor];
            addrLabel.font = [UIFont systemFontOfSize:14] ;
            NSString *address = [NSString stringWithFormat:@"%@%@%@%@_%@"
                                 ,_addr[@"street"][@"province"][@"name"]
                                 ,_addr[@"street"][@"city"][@"name"]
                                 ,_addr[@"street"][@"county"][@"name"]
                                 ,_addr[@"street"][@"street"][@"name"]
                                 ,_addr[@"address"]];
            
            addrLabel.text = address;
            [cell.contentView addSubview:addrLabel];
        }
    }

    if(indexPath.section == 1){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.row == 0){
            
            UILabel *headLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 3, SCREEN_WIDTH-30, 25)];
            headLabel1.text = @"商品详情";
            headLabel1.font = [UIFont systemFontOfSize:14];
            headLabel1.textColor = KFontColor(@"#ec584c");
            [cell.contentView  addSubview:headLabel1];
            
            UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, 70, 70)];
            [logoImg sd_setImageWithURL:_data[@"logoImgUrl"] placeholderImage:[UIImage imageNamed:@"commonPlaceHolderIcon"] completed:nil];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 35, SCREEN_WIDTH-185, 60)];
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.text = _data[@"title"];
            titleLabel.textColor = [UIColor grayColor];
            titleLabel.numberOfLines = 0;
            [titleLabel sizeToFit];
            
            
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 50, 70, 25)];
            priceLabel.font = [UIFont systemFontOfSize:14];
            priceLabel.text = [NSString stringWithFormat:@"%@",_data[@"bonus"]];
            priceLabel.textColor = KFontColor(@"#ec584c");;
            [priceLabel sizeToFit];
            
            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 75, 70, 25)];
            numberLabel.font = [UIFont systemFontOfSize:14];
            numberLabel.text = [NSString stringWithFormat:@"x%@",@"1"];
            [numberLabel sizeToFit];
            
            [cell.contentView addSubview:logoImg];
            [cell.contentView addSubview:titleLabel];
            [cell.contentView addSubview:priceLabel];
            [cell.contentView addSubview:numberLabel];
            cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 110);
        }
        
        if(indexPath.row == 1){
            UILabel *headLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 25)];
            headLabel1.text = @"买家留言：";
            headLabel1.font = [UIFont systemFontOfSize:14];
            [cell.contentView  addSubview:headLabel1];
            
            UITextField *commentField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, SCREEN_WIDTH-40, 50)];
            commentField.delegate = self;
            commentField.returnKeyType = UIReturnKeyDone;  //键盘返回类型
            commentField.backgroundColor = HEXCOLOR(0xF5F5F5FF);
            commentField.text = _comment;
            [cell.contentView addSubview:commentField];
            _commentField = commentField;
            cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
        }
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        SKUserAddressViewController *vc = [[SKUserAddressViewController alloc] init];
        vc.delegate=self;
        [self.navigationController pushViewController:vc animated:YES];
    }
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


-(void)makeBottomView{
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
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.2)];
    line.backgroundColor = [UIColor grayColor];
    [_bottomView addSubview:line];
    
    UIButton *btn_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_1 setTitle:@"提交订单" forState:UIControlStateNormal];
    btn_1.backgroundColor = KBackColor(@"#ec584c");
    [btn_1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn_1 addTarget:self action:@selector(commitOrder) forControlEvents:UIControlEventTouchUpInside];
    
    btn_1.frame = CGRectMake(SCREEN_WIDTH-90, 5, 80, 40);
    [_bottomView addSubview:btn_1];
    
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
    _totalLabel.font = [UIFont systemFontOfSize:14];
    
    [_bottomView addSubview:_totalLabel];
    
    [self RefreshBottomView];
}

-(void)RefreshBottomView{
    
    NSString *strlabel = [NSString stringWithFormat:@"积分：%@ ",_data[@"bonus"]];
    NSRange range1 = [strlabel rangeOfString:@"："];
    //NSRange range2 = [strlabel rangeOfString:@" ("];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strlabel];
    [str addAttribute:NSForegroundColorAttributeName
                value:[UIColor redColor]
                range:NSMakeRange(range1.location+range1.length,strlabel.length-range1.location-range1.length)];
    
    _totalLabel.attributedText = str;
    
}

-(void)changeAddress:(NSDictionary*)value{
    _addr = value;
    [self.tableView reloadData];
}


-(void)defaultaddress{
    
    
    NSString *surl = [NSString stringWithFormat:@"%@/user/defaultaddress.do",SERVER_ADDR_XNBMALL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];
    
    [manager POST:surl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        
        NSLog(@"defaultaddress:%@",retdata);
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            
            _addr = retdata[@"addr"];
            
            [self.tableView reloadData];
            
        }else{
            [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
        [self.tableView reloadData];
    }];
    
}


-(void)pointsexchange{
    
    
    NSDictionary *goods = @{_data[@"goodsSpecId"]:@"1"};

    if (_comment == nil) {
        _comment = @"";
    }
    NSDictionary *postdata = @{@"addrId":_addr[@"id"],
                               @"goods":goods,
                               @"comment":_comment
                               };
    NSString *surl = [NSString stringWithFormat:@"%@/points/exchange.do",SERVER_ADDR_XNBMALL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];
    
    [manager POST:surl parameters:postdata progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        
        NSLog(@"pointsexchange:%@",retdata);
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"兑换成功" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                MAMyOrdersViewController *vc = [MAMyOrdersViewController new];
                vc.preSelectedHeaderBtnTag = 0;
                vc.shouldGoBackToRootController = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:^{}];
        }else{
            [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
        [self.tableView reloadData];
    }];
    
}



@end
