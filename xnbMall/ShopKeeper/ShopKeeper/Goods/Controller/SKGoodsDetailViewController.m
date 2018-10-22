//
//  SKGoodsDetailViewController.m
//  ShopKeeper
//
//  Created by zzheron on 16/6/2.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "SKGoodsDetailViewController.h"
#import "SDCycleScrollView.h"
#import "UIButton+ExtCenter.h"
#import "UIButton+Badge.h"
#import "UserInfo.h"
#import "NSString+Utils.h"
#import "MyUtile.h"
#import "MAShoppingCartViewController.h"
#import "UserInfo.h"
#import "SKSettleViewController.h"
#import "SKMixBuyGoodsViewController.h"
#import "CWStarRateView.h"
#import "SKGoodsCommentViewController.h"
#import "LoginViewController.h"

@interface SKGoodsDetailViewController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, UIWebViewDelegate, MWPhotoBrowserDelegate>

@property (nonatomic) UITableView *tableView;

@property(nonatomic) SDCycleScrollView *cycleScrollView;
@property(nonatomic) NSMutableArray *bannerimglist;

@property(nonatomic) NSDictionary *data;


@property (nonatomic) UIView *bottomView;
@property (nonatomic) UIButton *btn_1;
@property (nonatomic) UIButton *btn_2;
@property (nonatomic) UIButton *btn_3;
@property (nonatomic) UIButton *btn_4;

@property(nonatomic) UserInfo *user;

@property(nonatomic) NSMutableDictionary *buttonmap;//规格按钮列表

@property(nonatomic) UIWebView *webview;
@property(nonatomic) NSString *goodsSpecIdSelect;
@property(nonatomic) NSInteger goodsSelectNum;
@property(nonatomic) NSInteger goodsMoq;//起订量
@property(nonatomic) NSInteger goodsIoq;//增订量
@property(nonatomic) BOOL mixBuy;//混批

@property(nonatomic) NSMutableArray *photos;

@property(nonatomic) NSMutableArray *raisemark;//商品评论标签列表
@property(nonatomic) NSDictionary *markdata;//评论标签列表
@property(nonatomic) NSArray *raiselist;//评论列表

@property(nonatomic) NSString *arrivalFreightFee;//运费描述

@end

@implementation SKGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bannerimglist = [NSMutableArray new];
    _buttonmap = [NSMutableDictionary new];

    _photos = [NSMutableArray new];
    _raisemark = [NSMutableArray new];

    _user  = [UserInfo yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"]];
    if(_user == nil){
        _user = [UserInfo new];
    }

    _goodsSelectNum = 1;
    _goodsMoq = 1;
    _goodsIoq = 1;
    _mixBuy = NO;
    _goodsSpecIdSelect = _goodsSpecId;
 
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-60);
    }];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"GoodsTablewCell"];

    __weak UITableView *tableView = self.tableView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                       dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                           [self ystspec];
                           dispatch_async(dispatch_get_main_queue(), ^{
                           });
                           
                       });
    }];
    
    tableView.mj_header.automaticallyChangeAlpha = YES;

    

    float lwidth = self.view.frame.size.width;
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, lwidth, lwidth) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.currentPageDotColor = [UIColor orangeColor];
    _cycleScrollView.autoScrollTimeInterval = 3.0;
    
    _bottomView = [[UIView alloc] init];
    [self makeBottomView];

    [self ystspec];
    [self appraisemark];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //NSLog(@"3333viewDidAppear");
    [self ystcartcount];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_data.count>0){
        return 6;
    }
    else
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 2 && [NSString isBlankString:_arrivalFreightFee]) return 0;//运费描述
    if(section == 4 && [_raiselist count] == 0) return 0;//商品评论
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 2 && [NSString isBlankString:_arrivalFreightFee]) return 0.001;
    if(section == 4 && [_raiselist count] == 0) return 0.001;
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if(indexPath.section == 0){
    //    return self.view.frame.size.width;
    //}
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   //UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"GoodsTablewCell"];
    NSString *ID = [NSString stringWithFormat:@"detailGoodsCell_%ld_%ld",indexPath.section,indexPath.row];
    //static NSString *ID = @"mainviewcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.section == 0){
       [self MakeSectionIntro:cell];
    }
    if(indexPath.section == 1){
       [self MakeSectionSeller:cell];
    }
    
    if(indexPath.section == 2){
        [self MakeSectionArrival:cell];
    }
    if(indexPath.section == 3){
        [self MakeSectionSpec:cell];
    }
    if(indexPath.section == 4 ){
        [self MakeSectionComments:cell];//评论列表
    }
    
    if(indexPath.section == 5){
        [self MakeSectionDetailIntro:cell];//商品详情
    }

    return cell;
}

/**
 *商品名称，价格
 */
-(void)MakeSectionIntro:(UITableViewCell*)cell{
    CGSize titleSize = [_data[@"title"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
    //CGSize size =[content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];

    UIView *iv = [UIView new];
    iv.frame = CGRectMake(0, 0, SCREEN_WIDTH, 105+titleSize.height);
    
    
    UILabel *lb1 = [UILabel new];
    UILabel *lb2 = [UILabel new];
    UILabel *lb3 = [UILabel new];
    UILabel *lb4 = [UILabel new];
    UILabel *lb5 = [UILabel new];
    UILabel *lb6 = [UILabel new];

    lb1.textColor = HEXCOLOR(0x5B5B5BFF);
    lb2.textColor = HEXCOLOR(0xA6A6A6FF);
    lb3.textColor = HEXCOLOR(0xEE3B3BFF);
    lb4.textColor = KFontColor(@"#646464");
    lb5.textColor = KFontColor(@"#646464");
    lb6.textColor = HEXCOLOR(0xA6A6A6FF);

    UIColor *clor = HEXCOLOR(0xEE2C2Cff);

    NSDictionary *goodsPrice = _data[@"goodsPrice"];

    float  retailPrice= [goodsPrice[@"retailPrice"] floatValue];
    
    iv.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80+titleSize.height);
    NSMutableAttributedString *retailPrice1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"售价：¥ %.2f",retailPrice] attributes:nil];

    lb1.text = _data[@"title"];
    lb2.text = _data[@"subTitle"];
    lb3.attributedText = retailPrice1;
    
    NSString *strlabel_1 = [NSString stringWithFormat:@"已售: %@",_data[@"saleNumber"]];
    NSMutableAttributedString *attr_1 = [[NSMutableAttributedString alloc] initWithString:strlabel_1];
    NSRange range_1 = [strlabel_1 rangeOfString:@":"];
    [attr_1 addAttribute:NSForegroundColorAttributeName
                   value:clor
                   range:NSMakeRange(range_1.location+1, [strlabel_1 length] - range_1.location-1)];
    lb6.attributedText =attr_1 ;
    
    
    
    lb1.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    lb2.font = [UIFont systemFontOfSize:14];
    lb3.font = [UIFont systemFontOfSize:18];
    lb6.font = [UIFont systemFontOfSize:14];
    
    [iv addSubview:lb1];
    [iv addSubview:lb2];
    [iv addSubview:lb3];
    [iv addSubview:lb6];
    
    [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iv).offset(5);
        make.left.equalTo(iv).offset(5);
        make.right.equalTo(iv.mas_right).offset(-5);
        make.height.mas_equalTo(@(titleSize.height));
    }];
    
    [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb1.mas_bottom).offset(1);
        make.left.equalTo(iv).offset(5);
        make.right.equalTo(iv.mas_right).offset(-5);
        make.height.mas_equalTo(@(30));
    }];
    [lb3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb2.mas_bottom).offset(1);
        make.left.equalTo(iv).offset(5);
        make.right.equalTo(iv.mas_right).offset(-(SCREEN_WIDTH/5)*2.5);
        make.height.mas_equalTo(@(30));
    }];
    
    [lb6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb2.mas_bottom).offset(1);
        make.left.equalTo(lb3.mas_right).offset(5);
        make.right.equalTo(iv.mas_right).offset(-5);
        make.height.mas_equalTo(@(30));
    }];
    
    [cell.contentView addSubview:iv];
    cell.frame = iv.frame;
    lb1.numberOfLines = 0;
    [lb1 sizeToFit];
    
}

/**
 *商家物流发货介绍
 ***/
-(void)MakeSectionSeller:(UITableViewCell*)cell{
    UIView *iv = [UIView new];
    iv.backgroundColor = [UIColor clearColor];
    iv.frame = CGRectMake(0, 0, SCREEN_WIDTH, 85);
    
    UILabel *lb1 = [UILabel new];
    UILabel *lb2 = [UILabel new];
    UILabel *lb3 = [UILabel new];
    
    NSString *strlabel1 = [NSString stringWithFormat:@"发货地址：%@",_data[@"shipAddress"]];
    NSRange range1 = [strlabel1 rangeOfString:@"："];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strlabel1];
    [str addAttribute:NSForegroundColorAttributeName
                value:[UIColor redColor]
                range:NSMakeRange(range1.location+1,strlabel1.length-range1.location-1)];
    
    lb1.attributedText = str;
    
    NSString *strlabel2 = [NSString stringWithFormat:@"预计发货时间：%@",_data[@"deliveryTime"]];
    NSRange range2 = [strlabel2 rangeOfString:@"："];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:strlabel2];
    [str2 addAttribute:NSForegroundColorAttributeName
                value:[UIColor redColor]
                range:NSMakeRange(range2.location+1,strlabel2.length-range2.location-1)];
    
    lb2.attributedText = str2;
    
    NSString *strlabel3 = [NSString stringWithFormat:@"本商品由 %@ 销售并提供服务",_data[@"shopName"]];
    NSRange range3 = [strlabel3 rangeOfString:@" "];
    NSRange range4 = [strlabel3 rangeOfString:@" " options:NSBackwardsSearch];
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:strlabel3];
    [str3 addAttribute:NSForegroundColorAttributeName
                 value:[UIColor redColor]
                 range:NSMakeRange(range3.location,range4.location - range3.location)];
    
    lb3.attributedText = str3;

    lb1.font = [UIFont systemFontOfSize:16];
    lb2.font = [UIFont systemFontOfSize:16];
    lb3.font = [UIFont systemFontOfSize:12];
    
    
    [iv addSubview:lb1];
    [iv addSubview:lb2];
    [iv addSubview:lb3];
    
    [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iv).offset(5);
        make.left.equalTo(iv).offset(5);
        make.right.equalTo(iv.mas_right).offset(0);
        make.height.mas_equalTo(@(25));
    }];
    [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb1.mas_bottom).offset(1);
        make.left.equalTo(iv).offset(5);
        make.right.equalTo(iv.mas_right).offset(-5);
        make.height.mas_equalTo(@(25));
    }];
    [lb3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb2.mas_bottom).offset(1);
        make.left.equalTo(iv).offset(5);
        make.right.equalTo(iv.mas_right).offset(-5);
        make.height.mas_equalTo(@(25));
    }];
    
    
    [cell.contentView addSubview:iv];
    cell.frame = iv.frame;
}

/**
 *商品运费介绍
 ***/
-(void)MakeSectionArrival:(UITableViewCell*)cell {
    UIView *iv = [UIView new];
    iv.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
    iv.backgroundColor = [UIColor clearColor];

    UILabel *lb4 = [UILabel new];
    [iv addSubview:lb4];

    lb4.font = [UIFont systemFontOfSize:14];
    
    [lb4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iv).offset(5);
        make.left.equalTo(iv).offset(5);
        make.right.equalTo(iv.mas_right).offset(-5);
        make.height.mas_equalTo(@(60));
    }];
    
    lb4.text = [NSString stringWithFormat:@"%@ \n%@",_data[@"arrivalFreightFee"],_data[@"arrivalFreightFeeNotes"]];
    lb4.numberOfLines = 0;
    [cell.contentView addSubview:iv];
    cell.frame = iv.frame;
}

/**
 *商品规格,购买数量
 ***/
-(void)MakeSectionSpec:(UITableViewCell*)cell {
    UIView *iv = [UIView new];
    iv.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    iv.backgroundColor = [UIColor clearColor];
    
    NSDictionary *specDescMap = _data[@"specDescMap"];
    NSDictionary *specTypeMap = _data[@"specTypeMap"];
    
    UIColor *clor = HEXCOLOR(0xEE2C2Cff);
    if([specTypeMap count] > 0){
        UILabel *lb = [UILabel new];
        lb.text = @"选择商品规格型号";
        lb.font = [UIFont systemFontOfSize:16];
        lb.textColor = HEXCOLOR(0x5B5B5BFF);
        [iv addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iv).offset(5);
            make.left.equalTo(iv).offset(5);
            make.right.equalTo(iv.mas_right).offset(-5);
            make.height.mas_equalTo(@(25));
        }];
        
        float lx = 5,ly= 32;
        int n=1;
        for (NSString *key in specTypeMap) {
            NSArray *arr = specTypeMap[key];
            UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(lx, ly, 50, 20)];
            lb1.font = [UIFont systemFontOfSize:14];
            lb1.text = [NSString stringWithFormat:@"%@:",key];
            [cell addSubview:lb1];
            
            ly+=25;
            for(int i=0 ;i<arr.count;i++){
                //NSLog(@"%@",arr[i]);
                NSString *str = arr[i];
                CGSize size =[str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
                if(lx+size.width+4+5 > SCREEN_WIDTH){
                    lx = 5; ly+=25;
                }
                //NSInteger iitag = n*10000+(i+1)*100;
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(lx, ly, size.width+4, 20);
                lx+=size.width + 4 + 5;
                btn.backgroundColor = HEXCOLOR(0xF5F5F5FF);
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                [btn setTitle:str forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                
                NSDictionary *sDic = specDescMap[_goodsSpecIdSelect];
                if([sDic objectForKey:key]!=nil){
                    NSString *sValue = [sDic objectForKey:key];
                    if([str isEqualToString:sValue]){
                        [btn setSelected:YES];
                        btn.backgroundColor = clor;
                    }
                }
                
                [btn bk_addEventHandler:^(id sender) {
                    if(!btn.selected){
                        [btn setSelected:YES];
                        btn.backgroundColor = clor;
                        NSString *buttonName = btn.titleLabel.text;
                        NSString *hkey = [NSString stringWithFormat:@"%@_",key];
                        for(NSString *skey in _buttonmap){
                            if([skey hasPrefix:hkey]){
                                NSInteger itag= [[_buttonmap objectForKey:skey] integerValue];
                                UIButton *btn1 = [self.view viewWithTag:itag];
                                //UIButton *btn1 = [_buttonmap objectForKey:skey];
                                NSString *btnName = btn1.titleLabel.text;
                                if(![btnName isEqualToString:buttonName]){
                                    //NSLog(@"btnName:%@,%ld",btnName,btn1.tag);
                                    [btn1 setSelected:NO];
                                    btn1.backgroundColor = HEXCOLOR(0xF5F5F5FF);
                                }
                            }
                        }
                        
                        for(NSString *ssskey in specDescMap){
                            NSDictionary *dd = [specDescMap objectForKey:ssskey];
                            if([dd objectForKey:key]){
                                NSString *ddValue = [dd objectForKey:key];
                                if([ddValue isEqualToString:str]){
                                    _goodsSpecIdSelect = ssskey;
                                    [self ystspec];
                                }
                            }
                        }
                    }
                    
                } forControlEvents:UIControlEventTouchUpInside];
                
                BOOL isKK = NO;
                
                for(NSString *ssskey in specDescMap){
                    NSDictionary *dd = [specDescMap objectForKey:ssskey];
                    if([dd objectForKey:key] != nil){
                        NSString *ddValue = [dd objectForKey:key];
                        if([ddValue isEqualToString:str]){
                            isKK = YES;
                        }
                    }
                    if(isKK) break;
                }
                
                if(!isKK){
                    btn.enabled = NO;
                    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                }else{
                    btn.enabled = YES;
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
                
                [btn.layer setCornerRadius:2]; //设置矩形四个圆角半径
                //[btn.layer setBorderWidth:1.0]; //边框宽度
                btn.tag = n*10000+(i+1)*100;
                [iv addSubview:btn];
                [_buttonmap setObject:@(btn.tag) forKey:[NSString stringWithFormat:@"%@_%ld",key,btn.tag]];
            }
            n++;
            
            lx = 5;
            if(arr.count>0){
               ly+=25;
            }
        }
        iv.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44+ly);
        
        UILabel *line = [UILabel new];
        line.backgroundColor = [UIColor lightGrayColor];
        [iv addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iv).offset(5);
            make.right.equalTo(iv.mas_right).offset(-5);
            make.top.equalTo(iv.mas_bottom).offset(-43);
            make.height.mas_equalTo(@(1));
        }];
    }
    
    UILabel *lb1 = [UILabel new];
    lb1.text = @"数量：";
    lb1.font = [UIFont systemFontOfSize:14];
    lb1.textColor = [UIColor grayColor];
    [iv addSubview:lb1];
    [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iv.mas_bottom).offset(-35);
        make.left.equalTo(iv).offset(5);
        make.width.mas_equalTo(@(60));
        make.height.mas_equalTo(@(25));
    }];
    
    UIButton *btn_a1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *btn_a2 = [UIButton buttonWithType:UIButtonTypeCustom];
    UITextField *amount = [[UITextField alloc] init];
    amount.textAlignment = NSTextAlignmentCenter;
    [btn_a1 setTitle:@"－" forState:UIControlStateNormal];
    [btn_a2 setTitle:@"＋" forState:UIControlStateNormal];
    [btn_a1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn_a2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn_a1.layer.borderWidth = 0.5;
    btn_a2.layer.borderWidth = 0.5;
    amount.layer.borderWidth = 0.5;
    amount.font = [UIFont systemFontOfSize:12];
    amount.textColor = [UIColor grayColor];
    //[_amount sizeToFit];
    UIColor *clor1 = [UIColor lightGrayColor];//HEXCOLOR(0xFAFAFAff);
    btn_a1.layer.borderColor = clor1.CGColor;
    btn_a2.layer.borderColor = clor1.CGColor;
    amount.layer.borderColor = clor1.CGColor;
    amount.text = [NSString stringWithFormat:@"%ld",_goodsSelectNum];
    
    [iv addSubview:btn_a1];
    [iv addSubview:btn_a2];
    [iv addSubview:amount];
    
    
    [btn_a1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lb1.mas_right).offset(1);
        make.top.equalTo(iv.mas_bottom).offset(-35);
        make.height.equalTo(@(25));
        make.width.equalTo(@(25));
    }];
    [amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn_a1.mas_right).offset(-1);
        make.top.equalTo(iv.mas_bottom).offset(-35);
        make.height.equalTo(@(25));
        make.width.equalTo(@(60));
    }];
    [btn_a2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(amount.mas_right).offset(-1);
        make.top.equalTo(iv.mas_bottom).offset(-35);
        make.height.equalTo(@(25));
        make.width.equalTo(@(25));
    }];
    
    [btn_a1 bk_addEventHandler:^(id sender) {
        _goodsSelectNum -= _goodsIoq;
        if(_goodsSelectNum < _goodsMoq){
            _goodsSelectNum = _goodsMoq;
            [MyUtile showAlertViewByMsg:[NSString stringWithFormat:@"起订量不能小于%ld",_goodsMoq] vc:self];
        }
        
        amount.text = [NSString stringWithFormat:@"%ld",_goodsSelectNum];
        //code
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    [btn_a2 bk_addEventHandler:^(id sender) {
        _goodsSelectNum += _goodsIoq;
        
        amount.text = [NSString stringWithFormat:@"%ld",_goodsSelectNum];
    } forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger mixBuy =[_data[@"mixBuy"] integerValue];
    if(mixBuy == 1){
        UILabel *lbmixBuy = [[UILabel alloc] init];
        lbmixBuy.userInteractionEnabled=YES;
        [iv addSubview:lbmixBuy];
        [lbmixBuy mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iv.mas_bottom).offset(-44);
            make.bottom.equalTo(iv.mas_bottom).offset(0);
            make.right.equalTo(iv.mas_right).offset(-5);
            make.left.equalTo(iv.mas_right).offset(-(SCREEN_WIDTH/2-5));
        }];
        [lbmixBuy bk_whenTapped:^{
            SKMixBuyGoodsViewController *vc = [SKMixBuyGoodsViewController new];
            vc.templateId = _data[@"templateId"];
            vc.goodsFactoryId = _data[@"factoryId"];
            vc.lastDate = @"";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        
        lbmixBuy.textColor = HEXCOLOR(0xEE2C2Cff);
        lbmixBuy.text = [NSString stringWithFormat:@"起订%@，增订%@\n更过混批商品",_data[@"moqDesc"],_data[@"ioqDesc"]];
        lbmixBuy.textAlignment = NSTextAlignmentRight;
        lbmixBuy.font = [UIFont systemFontOfSize:12];
        lbmixBuy.numberOfLines = 0;
    }

    [cell.contentView addSubview:iv];
    cell.frame = iv.frame;
}

/**
 *商品评论
 ***/
-(void)MakeSectionComments:(UITableViewCell*)cell{
    UIView *iv = [UIView new];
    iv.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    //iv.backgroundColor = [UIColor brownColor];
    UILabel *lb1 = [UILabel new];
    lb1.text = [NSString stringWithFormat:@"商品评价(%ld)",[_raisemark count]];
    lb1.font = [UIFont systemFontOfSize:16];
    lb1.textColor = HEXCOLOR(0x5B5B5BFF);
    [iv addSubview:lb1];
    [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iv).offset(5);
        make.left.equalTo(iv).offset(5);
        make.right.equalTo(iv.mas_right).offset(-5);
        make.height.mas_equalTo(@(25));
    }];
    
    float lx = 10,ly= 35;
    
    UIColor *clor = HEXCOLOR(0x8C8C8CFF);
    for(int i=0 ;i<[_raisemark count];i++){
        NSDictionary *dic = _raisemark[i];
        NSString *str = [NSString stringWithFormat:@"%@(%@)",dic[@"desc"],dic[@"number"]];
        CGSize size =[str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        if(lx+size.width+10+5 > SCREEN_WIDTH){
            lx = 10; ly+=35;
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(lx, ly, size.width+10, 30);
        lx+=size.width + 10 + 5;
        btn.backgroundColor = HEXCOLOR(0xFFF0F5FF);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn.layer setCornerRadius:4]; //设置矩形四个圆角半径
        //[btn.layer setBorderWidth:1.0]; //边框宽度
        NSInteger imark = [dic[@"mark"] integerValue];
        btn.tag = 500+imark;
        [iv addSubview:btn];
        NSInteger iselected = [dic[@"selected"] integerValue];
        if(iselected == 1) {
            btn.selected = YES;
            btn.backgroundColor = clor;
        }
        
        [btn bk_addEventHandler:^(id sender) {
            if(!btn.selected){
                btn.selected = YES;
                btn.backgroundColor = clor;
                NSInteger ibtntag =btn.tag;
                for(int i=0;i<[_raisemark count];i++){
                    NSMutableDictionary *oo = _raisemark[i];
                    NSInteger iimark = [oo[@"mark"] integerValue];
                    if(iimark == ibtntag%500){
                        [oo setObject:@(1) forKey:@"selected"];
                        [self listappraisal:oo[@"mark"] withFirst:NO];
                    }else{
                        [oo setObject:@(0) forKey:@"selected"];
                        NSInteger ibtntag1 =500+iimark;
                        UIButton *btn1 = [self.view viewWithTag:ibtntag1];
                        btn1.backgroundColor =HEXCOLOR(0xFFF0F5FF);
                        btn1.selected = NO;
                    }
                }
            }
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
    
    if([_raiselist count]>0){//评论
        ly+=40;
        NSDictionary *rdic =_raiselist[0];
        UIImageView  *imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"male79"]];
        imgLogo.frame = CGRectMake(15, ly, 18, 18);
        [iv addSubview:imgLogo];
        
        CGSize rsize =[rdic[@"createUserPhone"] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        UILabel *labeluser = [[UILabel alloc] init];
        labeluser.frame = CGRectMake(35, ly, rsize.width+10, 18);
        labeluser.text = rdic[@"createUserPhone"];
        labeluser.font = [UIFont systemFontOfSize:12];
        labeluser.textColor = [UIColor lightGrayColor];
        [iv addSubview:labeluser];
        CWStarRateView *rate = [[CWStarRateView alloc] initWithFrame:CGRectMake(35+rsize.width+20, ly, 100, 18)];
        rate.allowChange = NO;
        rate.scorePercent = [rdic[@"starnum"] floatValue]/5.0;
        
        [iv addSubview:rate];
        
        ly+=25;
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        CGRect crect = [rdic[@"content"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                   context:nil];
        UILabel *labelcontent = [[UILabel alloc] init];
        labelcontent.frame = CGRectMake(20, ly, SCREEN_WIDTH-40, crect.size.height+5);
        labelcontent.text = rdic[@"content"];
        labelcontent.font = [UIFont systemFontOfSize:12];
        labelcontent.textColor = KFontColor(@"#646464");
        [iv addSubview:labelcontent];
        
        ly+=crect.size.height+10;
        
        UILabel *labelSpec = [[UILabel alloc] init];
        labelSpec.frame = CGRectMake(20, ly, SCREEN_WIDTH-40, 18);
        labelSpec.text = [NSString stringWithFormat:@"%@    %@",
                          rdic[@"createTime"],rdic[@"goodsSpecName"]];
        labelSpec.font = [UIFont systemFontOfSize:12];
        labelSpec.textColor = [UIColor lightGrayColor];
        [labelSpec sizeToFit];
        [iv addSubview:labelSpec];
    }
    
    ly+=25;
    
    UIButton *btnmore = [UIButton buttonWithType:UIButtonTypeCustom];
    btnmore.frame = CGRectMake((SCREEN_WIDTH-120)/2, ly, 120, 35);
    btnmore.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnmore setTitle:@"查看跟多评论" forState:UIControlStateNormal];
    [btnmore setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btnmore.layer setCornerRadius:4];
    [btnmore.layer setBorderWidth:1.0];
    btnmore.layer.borderColor = [UIColor redColor].CGColor;
    [btnmore bk_addEventHandler:^(id sender) {
        SKGoodsCommentViewController *vc = [[SKGoodsCommentViewController alloc] init];
        vc.goodsId = _goodsId;
        [self.navigationController pushViewController:vc animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [iv addSubview:btnmore];
    
    iv.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44+ly);
    
    [cell.contentView addSubview:iv];
    cell.frame = iv.frame;
}

/**
 *商品详情
 ***/
-(void)MakeSectionDetailIntro:(UITableViewCell*)cell {
    
    UIView *iv = [UIView new];
    iv.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    //iv.backgroundColor = [UIColor brownColor];
    UILabel *lb1 = [UILabel new];
    lb1.text = @"查看商品详情";
    lb1.textColor = HEXCOLOR(0x5B5B5BFF);
    [iv addSubview:lb1];
    [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iv).offset(5);
        make.left.equalTo(iv).offset(5);
        make.right.equalTo(iv.mas_right).offset(-50);
        make.height.mas_equalTo(@(25));
    }];
    
    UIButton *select1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *select2 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *select3 = [UIButton buttonWithType:UIButtonTypeCustom];
    select1.tag = 101;
    select2.tag = 102;
    select3.tag = 103;
    
    UIColor *clor = HEXCOLOR(0xEE2C2Cff);
    [select1 setTitle:@"商品详情" forState:UIControlStateNormal];
    [select1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [select2 setTitle:@"规格参数" forState:UIControlStateNormal];
    [select2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [select3 setTitle:@"包装售后" forState:UIControlStateNormal];
    [select3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [select1 setTitleColor:clor forState:UIControlStateSelected];
    [select2 setTitleColor:clor forState:UIControlStateSelected];
    [select3 setTitleColor:clor forState:UIControlStateSelected];
    
    select1.layer.borderWidth = 0.5;
    select1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    select2.layer.borderWidth = 0.5;
    select2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    select3.layer.borderWidth = 0.5;
    select3.layer.borderColor = [UIColor lightGrayColor].CGColor;
   
    [iv addSubview:select1];
    [iv addSubview:select2];
    [iv addSubview:select3];

    [select1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb1.mas_bottom).offset(5);
        make.left.equalTo(iv).offset(0);
        make.width.mas_equalTo(@(SCREEN_WIDTH/3));
        make.height.mas_equalTo(@(44));
    }];

    [select2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb1.mas_bottom).offset(5);
        make.left.equalTo(select1.mas_right).offset(0);
        make.width.mas_equalTo(@(SCREEN_WIDTH/3));
        make.height.mas_equalTo(@(44));
    }];

    [select3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb1.mas_bottom).offset(5);
        make.left.equalTo(select2.mas_right).offset(0);
        make.width.mas_equalTo(@(SCREEN_WIDTH/3));
        make.height.mas_equalTo(@(44));
    }];
    
    _webview = [[UIWebView alloc] init];
    _webview.tag = 1001;
    _webview.delegate = self;
    _webview.scrollView.scrollEnabled = YES;
    _webview.scalesPageToFit = YES;
    [_webview sizeToFit];
    
    [iv addSubview:_webview];
    [_webview loadHTMLString:_data[@"detailsMobile"] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(select2.mas_bottom).offset(0);
        make.left.equalTo(iv).offset(0);
        make.right.equalTo(iv.mas_right).offset(0);
        make.height.mas_equalTo(@(SCREEN_HEIGHT - 200));
    }];

    [select1 bk_addEventHandler:^(id sender) {
        if(!select1.selected){
            select1.selected = YES;
            select2.selected = !select1.selected;
            select3.selected = !select1.selected;
            select1.layer.borderWidth = 0.0;
            select2.layer.borderWidth = 0.5;
            select3.layer.borderWidth = 0.5;
            [_webview removeFromSuperview];
            [_webview loadHTMLString:_data[@"detailsMobile"] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
            //NSLog(@"detailsMobile:%@",_data[@"detailsMobile"] );
            [iv addSubview:_webview];
            [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(select2.mas_bottom).offset(0);
                make.left.equalTo(iv).offset(0);
                make.right.equalTo(iv.mas_right).offset(0);
                make.height.mas_equalTo(@(SCREEN_HEIGHT - 200));
            }];
        }
    } forControlEvents:UIControlEventTouchUpInside];

    [select2 bk_addEventHandler:^(id sender) {
        if(!select2.selected){
            select2.selected = YES;
            select1.selected = !select2.selected;
            select3.selected = !select2.selected;
            select1.layer.borderWidth = 0.5;
            select2.layer.borderWidth = 0.0;
            select3.layer.borderWidth = 0.5;
            [_webview removeFromSuperview];
            [_webview loadHTMLString:_data[@"salesService"] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
            [iv addSubview:_webview];
            [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(select2.mas_bottom).offset(0);
                make.left.equalTo(iv).offset(0);
                make.right.equalTo(iv.mas_right).offset(0);
                make.height.mas_equalTo(@(SCREEN_HEIGHT - 200));
            }];
        }

    } forControlEvents:UIControlEventTouchUpInside];
    
    [select3 bk_addEventHandler:^(id sender) {
         if(!select3.selected){
            select3.selected = YES;
            select1.selected = !select3.selected;
            select2.selected = !select3.selected;
            select1.layer.borderWidth = 0.5;
            select2.layer.borderWidth = 0.5;
            select3.layer.borderWidth = 0.0;
            [_webview removeFromSuperview];
            [_webview loadHTMLString:_data[@"specParams"] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
            [iv addSubview:_webview];
            [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(select2.mas_bottom).offset(0);
                make.left.equalTo(iv).offset(0);
                make.right.equalTo(iv.mas_right).offset(0);
                make.height.mas_equalTo(@(SCREEN_HEIGHT - 200));
            }];
        }

    } forControlEvents:UIControlEventTouchUpInside];
    
    iv.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-120);
    
    
    [cell.contentView addSubview:iv];
    cell.frame = iv.frame;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    
    [webView stringByEvaluatingJavaScriptFromString:
     @"var tagHead =document.documentElement.firstChild;"
     "var tagStyle = document.createElement(\"style\");"
     "tagStyle.setAttribute(\"type\", \"text/css\");"
     "tagStyle.appendChild(document.createTextNode(\"BODY{padding: 20pt 15pt}\"));"
     "var tagHeadAdd = tagHead.appendChild(tagStyle);"];
    
    for(int i=0;i<50;i++){
        NSString *str = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].style.width = '100%%'",i];
        [webView stringByEvaluatingJavaScriptFromString:str];
    }
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //NSLog(@"---点击了第%ld张图片", (long)index);
    
    [_photos removeAllObjects];
    
    for(int i = 0; i < [_bannerimglist count]; i++){
        [_photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:_bannerimglist[i]]]];
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill = NO;
    browser.alwaysShowControls = NO;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    //browser.autoPlayOnAppear = NO;
    [browser setCurrentPhotoIndex:index];
    
    // Present
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:browser animated:YES];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count) {
        return [_photos objectAtIndex:index];
    }
    return nil;
}

-(void)makeBottomView{
    [self.view addSubview:_bottomView];
    WS(ws);
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view).offset(0);
        make.right.equalTo(ws.view).offset(0);
        make.bottom.equalTo(ws.view).offset(0);
        make.height.equalTo(@(60)).priorityLow();
    }];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _btn_1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn_2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn_3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn_4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [_bottomView addSubview:_btn_1];
    [_bottomView addSubview:_btn_2];
    [_bottomView addSubview:_btn_3];
    [_bottomView addSubview:_btn_4];
    
    [_btn_1 setImage:[UIImage imageNamed:@"CustomerService"] forState:UIControlStateNormal];
    [_btn_2 setImage:[UIImage imageNamed:@"f-2"] forState:UIControlStateNormal];
    [_btn_1 setTitle:@"客服" forState:UIControlStateNormal];
    [_btn_2 setTitle:@"购物车" forState:UIControlStateNormal];
    [_btn_3 setTitle:@"加入购物车" forState:UIControlStateNormal];
    [_btn_4 setTitle:@"立即购买" forState:UIControlStateNormal];
    
    
    float lwth = SCREEN_WIDTH/4;
    
    _btn_1.frame  = CGRectMake(0, 0, lwth, 60);
    _btn_2.frame  = CGRectMake(lwth, 0, lwth, 60);
    _btn_3.frame  = CGRectMake(2*lwth, 0, lwth, 60);
    _btn_4.frame  = CGRectMake(3*lwth, 0, lwth, 60);
    [_btn_1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btn_2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btn_3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btn_4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btn_1.titleLabel.font = [UIFont systemFontOfSize:12];
    _btn_2.titleLabel.font = [UIFont systemFontOfSize:12];
    _btn_3.titleLabel.font = [UIFont systemFontOfSize:14];
    _btn_4.titleLabel.font = [UIFont systemFontOfSize:14];
    _btn_3.backgroundColor = [UIColor lightGrayColor];
    _btn_4.backgroundColor = HEXCOLOR(0xEE2C2Cff);
    [_btn_1 setTintColor:[UIColor grayColor]];
    [_btn_2 setTintColor:[UIColor grayColor]];
    [_btn_1 verticalImageAndTitle:5];
    [_btn_2 verticalImageAndTitle:1];
    
    _btn_2.badgeValue = @"0";
    _btn_2.badgeOriginX = lwth*0.6;
    _btn_2.badgeOriginY = 6;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.2)];
    line.backgroundColor = [UIColor grayColor];
    [_bottomView addSubview:line];
    
    [_btn_1 bk_addEventHandler:^(id sender) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"请拨打客服热线"                                                                            message:@"4000-456-115"  preferredStyle:UIAlertControllerStyleAlert];
        //添加Button
        [alertController addAction: [UIAlertAction actionWithTitle:@"拨打" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4000-456-115"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }]];
        
        [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController: alertController animated: YES completion: nil];

    } forControlEvents:UIControlEventTouchUpInside];
    
    [_btn_2 bk_addEventHandler:^(id sender) {
        MAShoppingCartViewController *vc = [[MAShoppingCartViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_btn_3 bk_addEventHandler:^(id sender) {
        [self addystcartitem ];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_btn_4 bk_addEventHandler:^(id sender) {
        [self ystsettle ];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self ystcartcount];
}

-(void)ystspec{
    NSDictionary *postdata = @{@"goodsSpecId":_goodsSpecIdSelect};
    
    NSString *surl =  [NSString stringWithFormat:@"%@/goods/spec.do",SERVER_ADDR_XNBMALL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];
    
    [manager POST:surl parameters:postdata progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        
        NSLog(@"ystspec:%@",retdata);
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [_bannerimglist removeAllObjects];
            
            NSDictionary *photoList =retdata[@"data"][@"photoList"];
            for(NSString *ssskey in photoList){
                [_bannerimglist addObject:[photoList objectForKey:ssskey ]];
            }

            [_cycleScrollView setImageURLStringsGroup:_bannerimglist];
            self.tableView.tableHeaderView = _cycleScrollView;

            self.title = retdata[@"data"][@"title"];
            _data = retdata[@"data"];
            _goodsSpecIdSelect = _data[@"goodsSpecId"];
            _goodsSelectNum = [_data[@"moq"] integerValue];
            _arrivalFreightFee = _data[@"arrivalFreightFee"];
            _mixBuy = [_data[@"mixBuy"] boolValue];
            if(!_mixBuy){
                _goodsMoq = [_data[@"moq"] integerValue];
                _goodsIoq = [_data[@"ioq"] integerValue];
            }
            [self.tableView reloadData];
            
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:retdata[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:^{}];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
    }];
}

-(void)addystcartitem{
    
    NSDictionary *postdata = @{@"goodsSpecificationId":_goodsSpecIdSelect,
                               @"number":[NSString stringWithFormat:@"%ld",_goodsSelectNum]};
    
    NSString *surl = [NSString stringWithFormat:@"%@/goods/addcartitem.do",SERVER_ADDR_XNBMALL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];
    
    [manager POST:surl parameters:postdata progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        
        //NSLog(@"addystcartitem:%@",retdata);
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
             [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            [self ystcartcount];
        }else{
            [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
    }];
    
}

-(void)ystcartcount{
    NSString *surl = [NSString stringWithFormat:@"%@/goods/cartcount.do",SERVER_ADDR_XNBMALL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];
    
    [manager POST:surl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        
        //NSLog(@"ystcartcount:%@",retdata);
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            
            _btn_2.badgeValue = [NSString stringWithFormat:@"%@",retdata[@"data"]];
            float lwth = SCREEN_WIDTH/4;
            _btn_2.badgeOriginX = lwth*0.6;
            _btn_2.badgeOriginY = 6;
            [SVProgressHUD dismiss];
        }else{
            [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
    }];
    
}


-(void)ystsettle{
    
    NSString *isLoginStr = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:MALL_IS_LOGIN];
    
    NSLog(@"isLoginStr是否是商家 isLoginStr  = %@",isLoginStr);
    if(isLoginStr == nil || isLoginStr.length == 0){
        
        
        LoginViewController* vc = [[LoginViewController alloc]init];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
        navi.navigationBar.translucent = NO;
        [navi.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        [self presentViewController:navi animated:YES completion:nil];
    }
    
    NSMutableDictionary *goods = [[NSMutableDictionary alloc] init];
    [goods setValue:[NSString stringWithFormat:@"%ld",_goodsSelectNum] forKey:_goodsSpecIdSelect];

    NSDictionary *postdata = @{@"goods":goods,
                               @"usedGiftCard":@"true",
                               @"areaId":@""};
    
    
    NSString *surl = [NSString stringWithFormat:@"%@/order/settle.do",SERVER_ADDR_XNBMALL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];
    
    [manager POST:surl parameters:postdata progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        
        NSLog(@"ystsettle:%@",retdata);
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            SKSettleViewController *vc = [[SKSettleViewController alloc] init];
            vc.data = retdata[@"data"];
            vc.goods = goods;
            vc.areaId = @"";
            vc.usedGiftCard = @"false";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
    }];
    
}




-(void)appraisemark{
    _markdata = @{@"qualityGood":@{@"desc":@"质量不错",@"mark":@"1"},
                  @"priceGood":@{@"desc":@"价格优惠",@"mark":@"2"},
                  @"logisticeGood":@{@"desc":@"物流快",@"mark":@"3"},
                  @"serviceGood":@{@"desc":@"服务态度不错",@"mark":@"4"},
                  @"packGood":@{@"desc":@"包装好",@"mark":@"5"},
                  @"qualityBad":@{@"desc":@"质量不好",@"mark":@"6"},
                  @"priceBad":@{@"desc":@"价格不合理",@"mark":@"7"},
                  @"logisticeBad":@{@"desc":@"物流太慢",@"mark":@"8"},
                  @"serviceBad":@{@"desc":@"服务态度不好",@"mark":@"9"},
                  @"packBad":@{@"desc":@"包装破损",@"mark":@"10"}};
    
    NSDictionary *postdata = @{@"goodsId":_goodsId};
    NSString *surl = [NSString stringWithFormat:@"%@/comment/appraisemark.do",SERVER_ADDR_XNBMALL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];
    
    [manager POST:surl parameters:postdata progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        
        NSLog(@"appraisemark:%@",retdata);
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            [_raisemark removeAllObjects];
            NSDictionary *ddic = retdata[@"data"];
            for(NSString *skey in _markdata){
                if([ddic objectForKey:skey] != nil){
                    NSDictionary *sdic = [_markdata objectForKey:skey];
                    NSDictionary *idic = @{@"desc":sdic[@"desc"],
                                           @"mark":sdic[@"mark"],
                                           @"skey":skey,
                                           @"number":[ddic objectForKey:skey],
                                           @"selected":@(0)
                                           };
                    [_raisemark addObject:[idic mutableCopy]];
                }
            }
            
            NSLog(@"_raisemark:%@",_raisemark);
            
            if([_raisemark count] > 0){
                NSMutableDictionary *oo = _raisemark[0];
                [oo setObject:@(1) forKey:@"selected"];
                [self listappraisal:oo[@"mark"] withFirst:YES];
            }
            
            
        }else{
            [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
    }];
    
}

-(void)listappraisal:(NSString*)mark withFirst:(BOOL) isfirst{
    NSDictionary *postdata = @{@"goodsId":_goodsId,
                               @"mark":mark};
    
    NSLog(@"postdata:%@",postdata);
    NSString *surl = [NSString stringWithFormat:@"%@/comment/listappraisal.do",SERVER_ADDR_XNBMALL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];
    
    [manager POST:surl parameters:postdata progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        
        NSLog(@"listappraisal:%@",retdata);
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            _raiselist = retdata[@"data"][@"list"];
            if([_raisemark count] > 0){
                if(isfirst)
                    [self.tableView reloadData];
                else{
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:4];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }else{
            [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
    }];
    
}


@end
