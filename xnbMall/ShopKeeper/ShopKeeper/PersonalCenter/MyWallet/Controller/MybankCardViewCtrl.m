//
//  MybankCardViewCtrl.m
//  ShopKeeper
//
//  Created by zhough on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MybankCardViewCtrl.h"
#import "MyBankCardCell.h"
#import "AddBankCardViewCtrl.h"

#import "TransDataProxyCenter.h"
#import "MybankCardModel.h"

@interface MybankCardViewCtrl ()<MyBankCardCellDelegate>{

}


@property (nonatomic, strong)UIView * bgview;

@end

static NSString *const myBankCardCellIdentifier = @"MyBankCardCell";

@implementation MybankCardViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"我的银行卡"];
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    
    getcardlist = [[NSMutableArray alloc] init];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"　"
                                                                             style:(UIBarButtonItemStylePlain)
                                                                            target:nil
                                                                           action:nil];
    
   // 无数据视图
    [self.view addSubview:self.bgview];
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarbutton)];
 
}


- (void)setUpTableView  {
    
    CGRect rect = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT);
    
    mianTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    mianTableView.delegate = (id<UITableViewDelegate>)self;
    mianTableView.dataSource = (id<UITableViewDataSource>)self;
    [mianTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    mianTableView.allowsSelection = YES;
    mianTableView.showsVerticalScrollIndicator = NO;
    [mianTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:mianTableView];
    
    // 注册cell
    [mianTableView registerClass:[MyBankCardCell class] forCellReuseIdentifier:myBankCardCellIdentifier];
    
}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self setUpTableView];
    
    [self getData];
}

#pragma mark -- 添加银行卡
-(void)rightBarbutton{

    AddBankCardViewCtrl * addbankcard = [[AddBankCardViewCtrl alloc] init];
    addbankcard.getid  = _getid;
    [self.navigationController pushViewController:addbankcard animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    if (getcardlist.count>0) {
        self.bgview.hidden = YES;
    }else{
        self.bgview.hidden = NO;
        
    }
    return getcardlist.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyBankCardCell * cell = [tableView dequeueReusableCellWithIdentifier:myBankCardCellIdentifier];
    MybankCardModel* model = getcardlist[indexPath.row];
    
    NSArray * titlearray =@[model.bankName,model.bankNo];
    cell.gettag = indexPath.row;
    cell.delegate = self;
    [cell update:titlearray];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

//    设置默认银行卡
    MybankCardModel* model = getcardlist[indexPath.row];
    NSDictionary *dic =@{@"aid":_getid,
                         @"cid":model.idD};
    
    [MBProgressHUD showMessage:@"设置中..." ToView:nil];
    [[NetWorkManager shareManager] netWWorkWithReqUrl:@"money/setdefaultcard.do" ReqParam:dic BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
        [MBProgressHUD hideHUD];
        if (fail_success) {
            NSNumber* code = dicStr[@"code"];
            
            if ([code intValue]  == 200) {
                
                [MBProgressHUD showSuccess:@"设置成功" ToView:self.view];
            }
            else{
                
                [MBProgressHUD showWarn:dicStr[@"msg"] ToView:self.view];
            }
            
        }else{
            [MBProgressHUD showError:@"网络加载失败!" ToView:self.view ];
        }
        
    }];
  
}
#pragma mark 删除银行卡
-(void)clickButton:(NSInteger)tag{
    //删除银行卡
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil                                                                            message:@"支付密码："  preferredStyle:UIAlertControllerStyleAlert];
    //添加Button
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入支付密码";
        [textField setSecureTextEntry:YES];//密文输入
        paypassword = textField.text;
    }];
    
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        MybankCardModel* model = getcardlist[tag];
        
        NSDictionary *dic =@{@"pwd":alertController.textFields[0].text,
                             @"cid":model.idD};
        
        [MBProgressHUD showMessage:@"删除中..." ToView:nil];
        [[NetWorkManager shareManager] netWWorkWithReqUrl:@"money/deletecard.do" ReqParam:dic BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
            
            [MBProgressHUD hideHUD];
            if (fail_success) {
                NSNumber* code = dicStr[@"code"];
                
                if ([code intValue]  == 200) {
                    
                    [MBProgressHUD showSuccess:@"删除成功" ToView:self.view];
                    // 延迟2秒，再请求数据刷新
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self getData];
                    });
                }
                else{
                    
                    [MBProgressHUD showWarn:dicStr[@"msg"] ToView:self.view];
                }
                
            }else{
                [MBProgressHUD showError:@"网络加载失败!" ToView:self.view ];
            }
        }];
        
        
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated: YES completion: nil];
    
    
    
    
}


#pragma mark -- 请求用户银行卡
-(void)getData{

    NSDictionary *dic =@{@"aid":_getid};
    [MBProgressHUD showMessage:@"请求中..." ToView:nil];
    [[NetWorkManager shareManager] netWWorkWithReqUrl:@"money/bankcards.do" ReqParam:dic BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
        
        [MBProgressHUD hideHUD];
        if (fail_success) {
            NSNumber* code = dicStr[@"code"];
            
            if ([code intValue]  == 200) {
                [getcardlist removeAllObjects];
                
                NSArray* array =dicStr[@"data"];
                if (array != nil && [array count] > 0) {
                    
                    for (NSDictionary* getdic in array) {
                        
                        MybankCardModel* model = [MybankCardModel create:getdic];
                        [getcardlist addObject:model];
                        
                    }
                }
                
                [mianTableView reloadData];
            }else{
                
                [MBProgressHUD showWarn:dicStr[@"msg"] ToView:self.view];
            }
            
        }else{
            [MBProgressHUD showError:@"网络加载失败!" ToView:self.view ];
        }
    }];

}


#pragma  mark - 懒加载


- (UIView *)bgview {
    
    if (_bgview == nil) {
        UIView   *bgview = [[UIView alloc] init];
        [bgview setBackgroundColor:[UIColor clearColor]];
        [bgview setFrame:CGRectMake(0, SCREEN_HEIGHT/4, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
        [bgview setHidden:YES];
        
        
        UIImageView * logoImageView = [[UIImageView alloc] init];
        logoImageView.frame= CGRectMake(SCREEN_WIDTH/3, 0,SCREEN_WIDTH/3, SCREEN_WIDTH/3);
        [logoImageView setContentMode:UIViewContentModeScaleAspectFill];
        [logoImageView setClipsToBounds:YES];
        [logoImageView setImage:[UIImage imageNamed:@"quan2"]];
        [logoImageView.layer setCornerRadius:SCREEN_WIDTH/6];
        
        [bgview addSubview:logoImageView];
        
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(0, SCREEN_WIDTH/3+10, SCREEN_WIDTH , 30);
        [titleLabel setFont:[UIFont systemFontOfSize:16]];
        [titleLabel setText:@"没有绑定银行卡"];
        [titleLabel setTextColor:[UIColor grayColor]];
        [titleLabel setNumberOfLines:0];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [bgview addSubview:titleLabel];
        self.bgview = bgview;
    }
    return _bgview;
    
}

@end
