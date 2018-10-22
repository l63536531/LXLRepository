//
//  SKGoodsCommentViewController.m
//  ShopKeeper
//
//  Created by zzheron on 16/9/27.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "SKGoodsCommentViewController.h"
#import "NSString+Utils.h"
#import "CWStarRateView.h"

#import "JKURLSession.h"
#import "MACommentCell.h"

@interface SKGoodsCommentViewController () {
    
    NSInteger _mark;
    BOOL _isRefreshing;
    NSInteger _totalNum;//全部评论数
}

@property(nonatomic) NSMutableArray *raisemark;//商品评论标签列表
@property(nonatomic) NSDictionary *markdata;//评论标签列表
@property(nonatomic) NSMutableArray *raiselist;//评论列表
@property(nonatomic) NSString *lastValue;

@end

@implementation SKGoodsCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _raisemark = [[NSMutableArray alloc] init];
    _raiselist = [[NSMutableArray alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollsToTop = YES;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    __weak UITableView *tableView = self.tableView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isRefreshing = NO;
        [self listappraisal];
    }];
    
    _lastValue = nil;
    _isRefreshing = NO;
    _mark = 44;//全部
    
    [self requestExistMarks];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _raiselist.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *commentDic = _raiselist[indexPath.row];
    return [MACommentCell cellHeightForCommentDic:commentDic];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    MACommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MACommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSDictionary *commentDic = _raiselist[indexPath.row];
    cell.commentDic = commentDic;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)MakeTableViewHeadView{
    UIView *headerView = [UIView new];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    headerView.backgroundColor = [UIColor whiteColor];
    
    float lx = 10,ly= 5;
    
    UIColor *clor = THEMECOLOR;//HEXCOLOR(0x8C8C8CFF);
    for(int i=0 ;i<[_raisemark count] + 1;i++){
        
        NSString *btnTitle = nil;
        
        NSDictionary *dic = nil;
        if (i == 0) {
            btnTitle = [NSString stringWithFormat:@"全部(%zd)",_totalNum];//全部
        }else {
            dic = _raisemark[i-1];
            btnTitle = [NSString stringWithFormat:@"%@(%@)",dic[@"desc"],dic[@"number"]];
        }
        
        CGSize size =[btnTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        if(lx+size.width+10+5 > SCREEN_WIDTH){
            lx = 10; ly+=35;
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(lx, ly, size.width+10, 30);
        lx+=size.width + 10 + 5;
        btn.backgroundColor = HEXCOLOR(0xFFF0F5FF);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:btnTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn.layer setCornerRadius:4]; //设置矩形四个圆角半径

        if (i == 0) {
            btn.tag = 44;               //全部
            btn.selected = YES;
            btn.backgroundColor = clor;
        }else {
            NSInteger imark = [dic[@"mark"] integerValue];
            btn.tag = 500+imark;
        }
        [headerView addSubview:btn];

        [btn addTarget:self action:@selector(headerBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40+ly);
    self.tableView.tableHeaderView = headerView;
}

- (void)headerBtn:(UIButton *)btn {
    if(!btn.selected){
        btn.selected = YES;
        btn.backgroundColor = THEMECOLOR;//HEXCOLOR(0x8C8C8CFF);
        
        UIView *headerView = btn.superview;
        for (UIButton *enumBtn in headerView.subviews) {
            
            if (enumBtn.tag != btn.tag) {
                enumBtn.backgroundColor =HEXCOLOR(0xFFF0F5FF);
                enumBtn.selected = NO;
            }
        }
        
        _mark = btn.tag;
        _isRefreshing = YES;
        
        [self listappraisal];
    }
}

/**
 *  @author 黎国基, 16-11-24 19:11
 *
 *  存在的 标签
 */
-(void)requestExistMarks{
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
    
    [JKURLSession taskWithMethod:@"comment/appraisemark.do" parameter:postdata token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        if (error == nil) {
            
            [_raisemark removeAllObjects];
            
            NSDictionary *orgDic = resultDic[@"data"];
            
            _totalNum = [orgDic[@"allNum"] integerValue];
            
            for(NSString *skey in _markdata){
                if([orgDic objectForKey:skey] != nil){
                    NSDictionary *localFixedDic = [_markdata objectForKey:skey];
                    NSDictionary *createDic = @{@"desc":localFixedDic[@"desc"],
                                           @"mark":localFixedDic[@"mark"],
                                           @"skey":skey,
                                           @"number":[orgDic objectForKey:skey],
                                           };
                    [_raisemark addObject:[createDic mutableCopy]];
                }
            }
            
            self.title =[NSString stringWithFormat:@"评论(%ld)",[_raisemark count]];
            
            [self MakeTableViewHeadView];
            
            _isRefreshing = YES;
            [self listappraisal];
            
        }else {
            [self showAutoDissmissHud:error.localizedDescription];
        }
    }];
}

-(void)listappraisal {
    NSMutableDictionary *postdata = [[NSMutableDictionary alloc] init];
    
    NSString *lastValue = _lastValue;
    
    if (_isRefreshing) {
        _lastValue = nil;
    }else {
        if (lastValue != nil) {
            [postdata setObject:lastValue forKey:@"lastValue"];
        }
    }
    
    if(_mark != 44){
        //非 全部
        [postdata setObject:[NSString stringWithFormat:@"%zd",_mark - 500] forKey:@"mark"];
    }
    [postdata setObject:_goodsId forKey:@"goodsId"];
    
    [JKURLSession taskWithMethod:@"comment/listappraisal.do" parameter:postdata token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        
        if(_isRefreshing) {
            [_raiselist removeAllObjects];
        }
        
        if (error == nil) {
            
            NSArray *pageArray = resultDic[@"data"][@"list"];
            
            [_raiselist addObjectsFromArray:pageArray];
            
            NSDictionary *ldic = [_raiselist lastObject];
            if(ldic != nil){
                _lastValue = [NSString stringWithFormat:@"%@",ldic[@"id"]];//最后一个id值，第一次可不填，第二次请求开始，必须填。id倒序排
            }
            
            if (resultDic[@"data"][@"pageSize"] != nil) {
                NSInteger pageSize = [resultDic[@"data"][@"pageSize"] integerValue];
                if (pageArray.count < pageSize) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    [self.tableView.mj_footer resetNoMoreData];
                }
            }else {
                if([pageArray count] == 0){
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer resetNoMoreData];
                }
            }
        }else {
            [self showAutoDissmissHud:error.localizedDescription];
        }
        [self.tableView reloadData];
    }];
}

@end
