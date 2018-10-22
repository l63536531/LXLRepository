//
//  MemberCardViewCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/6/2.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MemberCardViewCtr.h"
#import "MembershipCardPrepaidCtr.h"
#import "PayRecordsViewCtr.h"
#import "MembershipflowCtr.h"

#import "TransDataProxyCenter.h"

@interface MemberCardViewCtr ()

@end

@implementation MemberCardViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"我的会员卡"];
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"　"
                                                                             style:(UIBarButtonItemStylePlain)
                                                                            target:nil
                                                                            action:nil];
    
    CGRect rect = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT );
    
    mianTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
   
    mianTableView.delegate = (id<UITableViewDelegate>)self;
    mianTableView.dataSource = (id<UITableViewDataSource>)self;
    [mianTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    mianTableView.allowsSelection = YES;
    mianTableView.showsVerticalScrollIndicator = NO;
    [mianTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:mianTableView];
    
//    mianTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
//    [mianTableView.mj_header beginRefreshing];

    
    
}
#pragma mark -- 添加银行卡

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
    
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}



- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    if (indexPath.row == 0) {
        UITableViewCell* cell = [[UITableViewCell alloc]init];

        UIView * line = [[UIView alloc] init];
        [line setBackgroundColor:BACKGROUND_COLOR];
        [cell.contentView addSubview:line];
        
        UIImageView* lowimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0,SCREEN_WIDTH, SCREEN_WIDTH/4*3)];
        [lowimageView setContentMode:UIViewContentModeScaleAspectFill];
        [lowimageView setClipsToBounds:YES];
        [lowimageView setImage:[UIImage imageNamed:@"guidancePageImage2"]];
        [cell addSubview:lowimageView];
        
        line.frame = CGRectMake(0, SCREEN_WIDTH/4*3 - 1, SCREEN_WIDTH, 1);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];

        return cell;
    }else if (indexPath.row==1){
        UITableViewCell* cell = [[UITableViewCell alloc]init];

    
        [cell.contentView addSubview:[self makefootview]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];

        return cell;
    }
    
    
    
    
    
    
    return nil;
    
    
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return 250;
    }else
      return SCREEN_WIDTH/4*3;
   
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"cell");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(UITextField*)createTextField:(CGRect)rect placeholder:(NSString*)holderstring SecureTextEntry:(BOOL)entrybool {
    
    
    UITextField*  textfield = [[UITextField alloc] initWithFrame:rect];
    [textfield setPlaceholder:holderstring];
    [textfield setFont:[UIFont boldSystemFontOfSize:16]];
    [textfield setContentVerticalAlignment : UIControlContentVerticalAlignmentCenter];
    [textfield setTextColor:[UIColor grayColor]];
  
    [textfield setBackgroundColor:[UIColor clearColor]];
    //    [textfield setKeyboardType:UIKeyboardTypeDefault];
    [textfield setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [textfield setAutocorrectionType:UITextAutocorrectionTypeNo];//不要纠错提醒
    [textfield setClearButtonMode:UITextFieldViewModeWhileEditing];//输入时显示清除按钮
    [textfield setSecureTextEntry:entrybool];//密文输入
    [textfield setReturnKeyType:UIReturnKeyNext];
    [textfield setDelegate:self];
    textfield.adjustsFontSizeToFitWidth = YES;
    return textfield;
}

-(UIView*)makefootview{
    
    UIView * bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    [bgview setBackgroundColor:[UIColor clearColor]];
    
    
    UILabel * titlename = [[UILabel alloc] init];
    
    [titlename setFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 30)];
    [titlename setBackgroundColor:[UIColor clearColor]];
    [titlename setTextColor: TEXTCURRENT_COLOR];
    [titlename setTextAlignment:NSTextAlignmentCenter];
    [titlename setFont:[UIFont systemFontOfSize:15]];
//    [titlename setNumberOfLines:0];
    [titlename setAdjustsFontSizeToFitWidth:YES];
    [titlename setText:_shopName];
    [bgview addSubview:titlename];
    
    
    UILabel * moneylab = [[UILabel alloc] init];
    
    [moneylab setFrame:CGRectMake(10, 50, SCREEN_WIDTH-20, 30)];
    [moneylab setBackgroundColor:[UIColor clearColor]];
    [moneylab setTextColor:KFontColor(@"#ec584c")];
    [moneylab setTextAlignment:NSTextAlignmentCenter];
    [moneylab setFont:[UIFont systemFontOfSize:12]];
    [moneylab setAdjustsFontSizeToFitWidth:YES];
    [moneylab setText:[NSString stringWithFormat:@" ¥ %.2f",_balance.floatValue]];
    [bgview addSubview:moneylab];

    CGFloat leftw = 10;
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(leftw , 100, SCREEN_WIDTH -2*leftw, 40)];
    btn.backgroundColor =KBackColor(@"#ec584c");
    [btn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"充值" forState:UIControlStateNormal];
    [btn setTag:101];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.layer setCornerRadius:5];
    [bgview addSubview:btn];
      
    UIButton* btn_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_1 setFrame:CGRectMake(leftw , 150, SCREEN_WIDTH-2*leftw, 40)];
    btn_1.backgroundColor = [UIColor whiteColor];
    [btn_1 addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    [btn_1 setTitle:@"充值记录" forState:UIControlStateNormal];
    [btn_1 setTitleColor: TEXTCURRENT_COLOR forState:UIControlStateNormal];
    [btn_1.layer setCornerRadius:5];
    [btn_1.layer setBorderColor:BACKGROUND_COLOR.CGColor];
    [btn_1.layer setBorderWidth:.5];
    [btn_1 setTag:102];

    [bgview addSubview:btn_1];
    UIButton* btn_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_2 setFrame:CGRectMake(leftw , 200, SCREEN_WIDTH-2*leftw, 40)];
    btn_2.backgroundColor = [UIColor whiteColor];
    [btn_2 addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    [btn_2 setTitle:@"资金流水" forState:UIControlStateNormal];
    [btn_2 setTitleColor: TEXTCURRENT_COLOR forState:UIControlStateNormal];
    [btn_2.layer setCornerRadius:5];
    [btn_2.layer setBorderColor:BACKGROUND_COLOR.CGColor];
    [btn_2.layer setBorderWidth:.5];

    [btn_2 setTag:103];

    [bgview addSubview:btn_2];

    return bgview;
    
}

-(void)buttonclick:(id)sender{
    UIButton* btn = sender;
    NSLog(@"%d",(int)btn.tag);
    if (btn.tag == 101) {
        MembershipCardPrepaidCtr* vc = [[MembershipCardPrepaidCtr alloc] init];
        vc.aid =_aid;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn.tag == 102){
        PayRecordsViewCtr* vc = [[PayRecordsViewCtr alloc] init];
        vc.aid =_aid;

        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn.tag == 103){
        MembershipflowCtr* vc = [[MembershipflowCtr alloc] init];
        vc.getid = _aid;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(void)getData{
    
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"请求中..."];
    
   
    [[TransDataProxyCenter shareController] queryMyystmember:_aid block:^(NSDictionary *dic, NSError *error) {
        if (dic) {
            NSNumber* code = dic[@"code"];
            NSString* msg = [error localizedDescription];
            if ([code intValue]  == 200) {
                NSLog(@"成功");
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [mianTableView reloadData];
                    [SVProgressHUD dismiss];
                    
                });
                
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [mianTableView reloadData];
                    
                    [SVProgressHUD showWithStatus:msg];
                    
                    [SVProgressHUD dismissWithDelay:1];
                    
                });
                
            }
            
            
        }else{
            
            [SVProgressHUD showWithStatus:@"请检查网络"];
            
            [SVProgressHUD dismissWithDelay:1];
            
        }

    }];
    
   
    [mianTableView.mj_header endRefreshing];
    
    
}

@end
