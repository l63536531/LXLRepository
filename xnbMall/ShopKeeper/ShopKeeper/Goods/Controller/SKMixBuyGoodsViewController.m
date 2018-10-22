//
//  SKMixBuyGoodsViewController.m
//  ShopKeeper
//
//  Created by zzheron on 16/8/17.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "SKMixBuyGoodsViewController.h"

@interface SKMixBuyGoodsViewController () {
    
    NSMutableArray *_mGoodArray;
    
    BOOL _isRefreshing;
}

@property (nonatomic) NSInteger ioq;
@property (nonatomic) NSInteger moq;

@property (nonatomic) UIView *bottomView;

@property (nonatomic) UILabel *totalLabel;

@property (nonnull) NSMutableDictionary *selectdata;

@end

@implementation SKMixBuyGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"同厂家混批商品";
    
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

    
    _mGoodArray = [[NSMutableArray alloc] init];
    _selectdata = [[NSMutableDictionary alloc] init];
    _moq = 1;
    _ioq = 1;
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    __weak UITableView *tableView = self.tableView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _isRefreshing = YES;
        [self requestMoreGoods];
    }];
    
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isRefreshing = NO;
        [self requestMoreGoods];
    }];
    [tableView.mj_footer setAutomaticallyHidden:YES];
    
    
    [self makeBottomView];
    
    [self requestMoreGoods];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  _mGoodArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) return 35;
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0 ){
        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, SCREEN_WIDTH, 44)];
        customView.backgroundColor = [tableView backgroundColor];
        
        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, SCREEN_WIDTH-10, 30)];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.opaque = YES;
        headerLabel.textColor = KFontColor(@"#646464");
        headerLabel.highlightedTextColor = [UIColor lightGrayColor];
        headerLabel.font = [UIFont systemFontOfSize:14];
        
        headerLabel.text =  [NSString stringWithFormat:@"起订%ld件，增订%ld件。",_moq,_ioq];
        
        [customView addSubview:headerLabel];
        return customView;
    }else{
        return nil;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = [NSString stringWithFormat:@"MixBuyCell_%ld_%ld",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = _mGoodArray[indexPath.row];
    
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(40, 5, 80, 80)];
    [logoImg sd_setImageWithURL:dic[@"thumbnailUrl"] placeholderImage:[UIImage imageNamed:@"commonPlaceHolderIcon"] completed:nil];
    [cell.contentView addSubview:logoImg];
    
    //商品描述
    UILabel *goodsTitle = [[UILabel alloc] init];
   goodsTitle.font = FONT_HEL(12.f);
    goodsTitle.text = dic[@"title"];
   goodsTitle.textColor = TEXTCURRENT_COLOR;
    goodsTitle.numberOfLines = 5;
    [cell.contentView addSubview:goodsTitle];
    [goodsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logoImg.mas_right).offset(5);
        make.top.equalTo(cell).offset(5);
        make.right.equalTo(cell.contentView).offset(-90);
    }];
    
    NSInteger isAddToCart = [dic[@"isAddToCart"] integerValue];
    if(isAddToCart == 1){
        goodsTitle.textColor = TEXTVICE_COLOR;
    }
    
    
    //价格
    UILabel *price = [[UILabel alloc] init ];
    price.font = [UIFont systemFontOfSize:14];
    price.textAlignment = NSTextAlignmentCenter;
    price.text = [NSString stringWithFormat:@"¥%@",dic[@"goodsPrice"][@"costPrice"]];
    price.textColor = KFontColor(@"#ec584c");
    [cell.contentView addSubview:price];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsTitle.mas_right).offset(5);
        make.top.equalTo(cell).offset(5);
        make.right.equalTo(cell.contentView).offset(-5);
    }];
    
    //规格描述
    UILabel *specDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 74, SCREEN_WIDTH-125, 16.f)];
    specDescLabel.font = FONT_HEL(11.f);
    specDescLabel.text = dic[@"goodsSpecDesc"];
    specDescLabel.textColor = TEXTVICE_COLOR;
    [cell.contentView addSubview:specDescLabel];
    
    UIButton *checkbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkbtn.frame = CGRectMake(0, 0, 40, 80);
    checkbtn.tag=(indexPath.section+1)*1000 + indexPath.row+1;
    [checkbtn setImage:[UIImage imageNamed:@"uncheckedCircle"] forState:UIControlStateNormal];
    [checkbtn setImage:[UIImage imageNamed:@"tick"]  forState:UIControlStateSelected];
    
    [cell.contentView addSubview:checkbtn];
    
    if([_selectdata objectForKey:dic[@"goodsSpecId"]] != nil){
        checkbtn.selected = YES;
    }else{
        checkbtn.selected = NO;
    }
    
    checkbtn.tag = indexPath.row;
    [checkbtn addTarget:self action:@selector(checkbtn:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
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


#pragma mark - Touch events
- (void)checkbtn:(UIButton *)btn {
    
    NSDictionary *dic = _mGoodArray[btn.tag];
    
    btn.selected  = !btn.selected ;//
    if(btn.selected){
        [_selectdata setObject:@"1" forKey:dic[@"goodsSpecId"]];
    }else{
        [_selectdata removeObjectForKey:dic[@"goodsSpecId"]];
    }
    [self RefreshBottomView];
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
    [btn_1 setTitle:@"确定" forState:UIControlStateNormal];
    btn_1.backgroundColor = KBackColor(@"#ec584c");
    [btn_1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_1 bk_addEventHandler:^(id sender) {
        [self requestAddGoodsToCart];
    } forControlEvents:UIControlEventTouchUpInside];
    
    btn_1.frame = CGRectMake(SCREEN_WIDTH-71, 0, 70, 50);
    [_bottomView addSubview:btn_1];
    
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
    _totalLabel.font = [UIFont systemFontOfSize:14];
    _totalLabel.textColor = TEXTCURRENT_COLOR;
    
    [_bottomView addSubview:_totalLabel];
    
    [self RefreshBottomView];
    
}

-(void)RefreshBottomView{
    
    NSInteger totalnum = [_selectdata count];
    
    NSString *strlabel = [NSString stringWithFormat:@"已选择 %ld 件商品",totalnum];
    NSRange range1 = [strlabel rangeOfString:@"择 "];
    NSRange range2 = [strlabel rangeOfString:@" 件"];
   
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strlabel];
    [str addAttribute:NSForegroundColorAttributeName
                value:[UIColor redColor]
                range:NSMakeRange(range1.location+1,range2.location-range1.location-1)];
    
    _totalLabel.attributedText = str;
}

- (void)requestMoreGoods {
    
    NSString *lasteDate = _lastDate;
    if (_isRefreshing) {
        lasteDate = @"";
    }
    
    if (lasteDate == nil) {
        lasteDate = @"";
    }
    
    NSDictionary *postdata = @{@"goodsFactoryId":_goodsFactoryId,
                               @"lastDate":lasteDate,
                               @"templateId":_templateId};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [JKURLSession taskWithMethod:@"goods/itemsmixedpacking.do" parameter:postdata token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            if (error == nil) {
                
                if (_isRefreshing) {
                    [_mGoodArray removeAllObjects];
                }
                
                NSArray *pageArray = resultDic[@"data"][@"goods"];
                
                for(NSDictionary *dd in pageArray){
                    NSMutableDictionary *mdd = [dd mutableCopy];
                    [mdd setObject:@(0) forKey:@"num"];
                    [_mGoodArray addObject:mdd];
                }
                _moq = [resultDic[@"data"][@"moq"] integerValue];
                _ioq = [resultDic[@"data"][@"ioq"] integerValue];
                
                _lastDate = [pageArray lastObject][@"createdDate"];
                if (pageArray == nil || pageArray.count == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                [self.tableView reloadData];
            }else {
                [self showAutoDissmissHud:error.localizedDescription];
            }
        });
    }];
}

-(void)requestAddGoodsToCart {
    
    if(_selectdata.count == 0){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSMutableString *goodslist = [[NSMutableString alloc] init];
    for(NSString *sskey in _selectdata){
        [goodslist appendString:sskey];
        [goodslist appendString:@","];
    }
    
    NSDictionary *postdata= @{@"goodsSpecificationId":[goodslist substringToIndex:(goodslist.length-1)],
                              @"number":@"1"};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [JKURLSession taskWithMethod:@"goods/addcartitem.do" parameter:postdata token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            if (error == nil) {
                
                [self showAutoDissmissHud:@"添加成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else {
                [self showAutoDissmissHud:error.localizedDescription];
            }
        });
    }];
}

@end
