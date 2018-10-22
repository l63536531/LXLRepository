//
//  SKBankMoneyLimiteVC.m
//  ShopKeeper
//
//  Created by XNB2 on 16/10/28.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "SKBankMoneyLimiteVC.h"
#import "SKBankLimiteCell.h"

@interface SKBankMoneyLimiteVC () <UITableViewDelegate,UITableViewDataSource>
/**
 *  银行付款金额数据源
 */
@property (nonatomic, strong) NSArray *bankLimiteArr;


@property (nonatomic, strong)UITableView *tableView;

@end

@implementation SKBankMoneyLimiteVC

#pragma mark - 标识符
static NSString* SKBankLimiteCellIdentifier = @"SKBankLimiteCell";

- (NSArray *)bankLimiteArr{
    if (!_bankLimiteArr) {
        _bankLimiteArr = @[
                           @{
                               @"bank":@"银行",
                               @"singleLimite":@"单笔上限",
                               @"dayLimite":@"日上限"
                               },
                           @{
                               @"bankImage":@"bank_icon_abc",
                               @"bank":@"中国农业银行",
                               @"singleLimite":@"2万",
                               @"dayLimite":@"5万"
                               },
                           @{
                               @"bankImage":@"bank_icon_bc",
                               @"bank":@"中国银行",
                               @"singleLimite":@"49999",
                               @"dayLimite":@"10万"
                               },
                           @{
                               @"bankImage":@"bank_icon_ccb",
                               @"bank":@"中国建设银行",
                               @"singleLimite":@"5万",
                               @"dayLimite":@"10万"
                               },
                           @{
                               @"bankImage":@"bank_icon_cib",
                               @"bank":@"兴业银行",
                               @"singleLimite":@"5万",
                               @"dayLimite":@"5万"
                               },
                           @{
                               @"bankImage":@"bank_icon_wmbc",
                               @"bank":@"中国民生银行",
                               @"singleLimite":@"5万",
                               @"dayLimite":@"10万"
                               },
                           @{
                               @"bankImage":@"bank_icon_cqrcb",
                               @"bank":@"重庆农村商业银行",
                               @"singleLimite":@"5万",
                               @"dayLimite":@"10万"
                               },
                           @{
                               @"bankImage":@"bank_icon_icbc",
                               @"bank":@"中国工商银行",
                               @"singleLimite":@"5万",
                               @"dayLimite":@"5万"
                               },
                           @{
                               @"bankImage":@"bank_icon_pab",
                               @"bank":@"平安银行",
                               @"singleLimite":@"5万",
                               @"dayLimite":@"10万"
                               },
                           @{
                               @"bankImage":@"bank_icon_psbc",
                               @"bank":@"中国邮政储蓄银行",
                               @"singleLimite":@"5万",
                               @"dayLimite":@"10万"
                               },
                           @{
                               @"bankImage":@"bank_icon_ceb",
                               @"bank":@"中国光大银行",
                               @"singleLimite":@"5万",
                               @"dayLimite":@"10万"
                               },
                           ];
    }
    return _bankLimiteArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加
    [self.view addSubview:self.tableView];
    [self setTitle:@"各银行付款金额上限"];
    [self setupTableView];
}



- (void)setupTableView{
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SKBankLimiteCell class]) bundle:nil] forCellReuseIdentifier:SKBankLimiteCellIdentifier];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bankLimiteArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SKBankLimiteCell *cell = [tableView dequeueReusableCellWithIdentifier:SKBankLimiteCellIdentifier];
    cell.bankImageView.image = [UIImage imageNamed:self.bankLimiteArr[indexPath.row][@"bankImage"]];
    cell.bankLabel.text = self.bankLimiteArr[indexPath.row][@"bank"];
    cell.singleLimiteLabel.text = self.bankLimiteArr[indexPath.row][@"singleLimite"];
    cell.dayLimiteLabel.text = self.bankLimiteArr[indexPath.row][@"dayLimite"];
    return cell;
}

#pragma mark - UITableViewDelegate
//选中某行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

#pragma - mark 懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStylePlain
                      ];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

@end
