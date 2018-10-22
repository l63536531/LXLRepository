//
//  MyWalletViewCtrTwo.m
//  ShopKeeper
//
//  Created by zhough on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MyWalletViewCtrTwo.h"
#import "MyWalletCellOne.h"
#import "MyWalletCelltwo.h"


#import "MybankCardViewCtrl.h"
#import "MoneyFlowingCtrl.h"
#import "WithdrawalRecordCtrl.h"

#import "TransDataProxyCenter.h"

@interface MyWalletViewCtrTwo ()<MyWalletCelltwodelegate>

@property(nonatomic ,strong) NSString * getid;
@property (nonatomic,strong) NSDictionary * getDic;

@end

@implementation MyWalletViewCtrTwo

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:@"个人钱包"];
    
    [self.view setBackgroundColor:ColorFromRGB(230, 230, 230)];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"　"
                                                                             style:(UIBarButtonItemStylePlain)
                                                                            target:nil
                                                                            action:nil];
    
    CGRect rect = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT);
    
    mianTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    mianTableView.delegate = (id<UITableViewDelegate>)self;
    mianTableView.dataSource = (id<UITableViewDataSource>)self;
    [mianTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    mianTableView.allowsSelection = YES;
    mianTableView.showsVerticalScrollIndicator = NO;
    [mianTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:mianTableView];
    
    mianTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    [self requestAccountInfoWithHud:YES];
}

#pragma mark - Touch events

- (void)refresh {
    [self requestAccountInfoWithHud:YES];
}


#pragma mark - talbeview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0||indexPath.row==1) {
        
        MyWalletCellOne * cell = [[MyWalletCellOne alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ];
        NSString* balance = _getDic[@"balance"];
        NSString* withdrawBalance = _getDic[@"withdrawBalance"];
        if (balance == nil) {
            balance = @"0.00";
        }
        
        if (withdrawBalance == nil) {
            withdrawBalance = @"0.00";
        }
        
        CGFloat getmoney =[balance floatValue] - [withdrawBalance floatValue];
        
        NSArray * titlearray =@[@[@"我的余额",balance],@[@"不可提现余额",[NSString stringWithFormat:@"%.2f",getmoney]]];
        [cell update:titlearray[indexPath.row]];
        cell.getrow = indexPath.row;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
        
    }else if (indexPath.row ==2){
        MyWalletCelltwo * cell = [[MyWalletCelltwo alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ];
        NSString* withdrawBalance = _getDic[@"withdrawBalance"];
        
        if (withdrawBalance == nil) {
            withdrawBalance = @"0.00";
        }
        cell.delegate = self;
        
        [cell update:[NSString stringWithFormat:@"%0.2f", [withdrawBalance floatValue]]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    else {
        static NSString *CellIdentifier1 = @"CellIdentifier7";
        UITableViewCell *cell = [mianTableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
            [line setBackgroundColor:ColorFromRGB(230, 230, 230)];
            [cell.contentView addSubview:line];
        }
        NSArray * textarray =@[@"我的银行卡",@"资金流水",@"提现记录"];
        
        cell.textLabel.text = [textarray objectAtIndex:indexPath.row - 3];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
        case 3://我的银行卡
        {
            MybankCardViewCtrl* mybankvc = [[MybankCardViewCtrl alloc] init];
            mybankvc.getid = _getDic[@"id"];
            NSLog(@"%@",_getDic[@"id"]);
            [self.navigationController pushViewController:mybankvc animated:YES];
            
        }
            break;
        case 4://资金流水
        {
            MoneyFlowingCtrl * moneyvc = [[MoneyFlowingCtrl alloc] init];
            moneyvc.getid = _getDic[@"id"];
            
            [self.navigationController pushViewController:moneyvc animated:YES];
        }
            break;
        case 5://提现记录
        {
            WithdrawalRecordCtrl* withrecord = [[WithdrawalRecordCtrl alloc] init];
            withrecord.getid = _getDic[@"id"];
            
            [self.navigationController pushViewController:withrecord animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)requestAccountInfoWithHud:(BOOL)showHud {
    
    MBProgressHUD *hud = nil;
    if (showHud) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [JKURLSession taskWithMethod:@"money/scaccounts.do" parameter:nil token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (showHud) {
                [hud hideAnimated:YES];
            }
            if (error == nil) {

                _getDic = resultDic[@"data"];
                _getid = _getDic[@"id"];
                [mianTableView reloadData];
            }else {
                [self showAutoDissmissHud:error.localizedDescription];
            }
        });
    }];
}

#pragma mark - MyWalletCelltwodelegate 提现
-(void)wallettwoclick{
    
    NSLog(@"提现");
    if (_getid != nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [JKURLSession taskWithMethod:@"money/asseswithdraw.do" parameter:@{@"aid":_getid} token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [hud hideAnimated:YES];
                if (error == nil) {
                    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"提示"                                                                             message:@"请输入提现金额和密码"  preferredStyle:UIAlertControllerStyleAlert];
                    //添加Button
                    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        
                        textField.keyboardType = UIKeyboardTypeDecimalPad;
                        
                        NSString* balance = _getDic[@"balance"];
                        NSLog(@"--%@",balance);
                        NSString* withdrawBalance = _getDic[@"withdrawBalance"];
                        
                        if (withdrawBalance == nil) {
                            withdrawBalance = @"0.00";
                        }
                        
                        textField.placeholder = [NSString stringWithFormat:@"可提现余额%@元",[NSString stringWithFormat:@"%.2f",[withdrawBalance floatValue]]];
                    }];
                    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        
                        textField.keyboardType = UIKeyboardTypeNumberPad;
                        textField.placeholder =@"请输入提现密码";
                    }];
                    
                    [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                        NSString* amount = [JKTool NoNilStringForString:alertController.textFields[0].text];
                        NSString* psw = [JKTool NoNilStringForString:alertController.textFields[1].text];
                        
                        NSLog(@"--%@  ",alertController.textFields[1].text);
                        
                        NSMutableDictionary *mPraDic = [NSMutableDictionary dictionaryWithCapacity:3];
                        [mPraDic setObject:_getid forKey:@"aid"];
                        [mPraDic setObject:psw forKey:@"pwd"];
                        [mPraDic setObject:amount forKey:@"amount"];
                        
                        MBProgressHUD *hud2 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        [JKURLSession taskWithMethod:@"money/withdraw.do" parameter:mPraDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [hud2 hideAnimated:YES];
                                if (error == nil) {
                                    [self requestAccountInfoWithHud:NO];//刷新
                                    [self showAutoDissmissHud:@"提现成功！"];
                                }else {
                                    [self showAutoDissmissHud:error.localizedDescription];
                                }
                            });
                        }];
                    }]];
                    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController: alertController animated: YES completion: nil];

                    
                }else {
                    [self showAutoDissmissHud:error.localizedDescription];
                }
            });
        }];
    }else {
        [self showAutoDissmissHud:@"未获取到提现账户id"];
    }
}

@end
