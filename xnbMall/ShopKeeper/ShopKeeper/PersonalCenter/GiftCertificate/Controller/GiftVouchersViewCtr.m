//
//  GiftVouchersViewCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/6/1.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "GiftVouchersViewCtr.h"
#import "GiftVouchersCell.h"
#import "ActivateCouponViewCtr.h"
#import "PreferentialRecordCtr.h"
#import "CouponValidViewCtr.h"
#import "TransDataProxyCenter.h"

@interface GiftVouchersViewCtr ()

@end

@implementation GiftVouchersViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"我的礼券"];
    [self.view setBackgroundColor:ColorFromRGB(240, 240, 240)];
    totalAmount = 0.0;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"　"
                                                                             style:(UIBarButtonItemStylePlain)
                                                                            target:nil
                                                                            action:nil];
    
    CGRect rect = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT);
    
    mianTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    mianTableView.scrollEnabled = YES;
    mianTableView.bounces = NO;
    mianTableView.delegate = (id<UITableViewDelegate>)self;
    mianTableView.dataSource = (id<UITableViewDataSource>)self;
    [mianTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    mianTableView.allowsSelection = YES;
    mianTableView.showsVerticalScrollIndicator = NO;
    [mianTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:mianTableView];
    [self makemianview];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self giftcardBalance];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0&&indexPath.row == 0) {
        UITableViewCell* cell = [[UITableViewCell alloc]init];
        UIImageView* _logoImageView = [[UIImageView alloc] init];
        
        _logoImageView.frame= CGRectMake(15, 10,30, 30);
        [_logoImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_logoImageView setClipsToBounds:YES];
        [_logoImageView setImage:[UIImage imageNamed:@"礼券余额"]];
        [_logoImageView.layer setCornerRadius:5];
        [cell.contentView addSubview:_logoImageView];
        
        UILabel * titlelab = [[UILabel alloc] init];
        titlelab.frame = CGRectMake(50, 0, SCREEN_WIDTH /3, 50);
        [titlelab setFont:[UIFont systemFontOfSize:16]];
        [titlelab setTextColor:[UIColor grayColor]];
        [titlelab setText:@"礼券余额"];
        [titlelab setNumberOfLines:0];
        [titlelab setTextAlignment:NSTextAlignmentLeft];
        [cell.contentView addSubview:titlelab];
        
//        礼券金
        
        UILabel * moneylab = [[UILabel alloc] init];
        moneylab.frame = CGRectMake(50, 0, SCREEN_WIDTH - 65, 50);
        [moneylab setFont:[UIFont systemFontOfSize:16]];
        [moneylab setTextColor:[UIColor grayColor]];
        [moneylab setNumberOfLines:0];
        [moneylab setTextAlignment:NSTextAlignmentRight];
        [cell.contentView addSubview:moneylab];
        NSString* labtext =[NSString stringWithFormat:@"%@元",[NSString stringWithFormat:@"%.2f",totalAmount]] ;
        NSMutableAttributedString *typeStr = [[NSMutableAttributedString alloc] initWithString:labtext];
        [typeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, labtext.length - 1)];
        //    [typeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12]range:NSMakeRange(0, 6)];
        moneylab.attributedText=typeStr;
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
        [line setBackgroundColor:ColorFromRGB(240, 240, 240)];
        [cell.contentView addSubview:line];

        return cell;
    }else{
    
        GiftVouchersCell *cell = [[GiftVouchersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ];
       
        if (indexPath.section == 0 && indexPath.row == 1) {
            [cell update:@"激活礼券" title:@"激活礼券"];
        }else{
            
            NSArray * imagearray = @[@"优惠记录",@"余额有效期"];
            NSArray * titlearray =@[@"优惠记录",@"余额有效期"];
            NSString * titlestring =[titlearray objectAtIndex:indexPath.row];

            [cell update:[imagearray objectAtIndex:indexPath.row] title:titlestring];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0 && indexPath.row == 1) {//激活礼券
        
        ActivateCouponViewCtr* activatevc = [[ActivateCouponViewCtr alloc] init];
        activatevc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:activatevc animated:YES];
        
    }else if (indexPath.section == 1&& indexPath.row == 0){
        
        PreferentialRecordCtr* prevc = [[PreferentialRecordCtr alloc] init];
        prevc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:prevc animated:YES];
    
    }else if (indexPath.section == 1&& indexPath.row == 1){
        
        CouponValidViewCtr* coupvc = [[CouponValidViewCtr alloc] init];
        coupvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:coupvc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)makemianview{

    bgview = [[UIView alloc] init];
    [bgview setBackgroundColor:[UIColor clearColor]];
    [bgview setFrame:CGRectMake(0, SCREEN_HEIGHT/4, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
    [bgview setHidden:YES];
    [self.view addSubview:bgview];
    
    UIImageView * logoImageView = [[UIImageView alloc] init];
    logoImageView.frame= CGRectMake(SCREEN_WIDTH/3, 0,SCREEN_WIDTH/3, SCREEN_WIDTH/3);
    [logoImageView setContentMode:UIViewContentModeScaleAspectFill];
    [logoImageView setClipsToBounds:YES];
    [logoImageView setImage:[UIImage imageNamed:@"wodelan"]];
    [logoImageView.layer setCornerRadius:SCREEN_WIDTH/6];
    [bgview addSubview:logoImageView];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, SCREEN_WIDTH/3+10, SCREEN_WIDTH , 30);
    [titleLabel setFont:[UIFont systemFontOfSize:16]];
    [titleLabel setText:@"没有推荐的用户"];
    [titleLabel setTextColor:[UIColor grayColor]];
    [titleLabel setNumberOfLines:0];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [bgview addSubview:titleLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 礼券余额
-(void)giftcardBalance{
    
    [[TransDataProxyCenter shareController] queryGiftcardBalanceblock:^(NSDictionary *dic, NSError *error) {
        NSNumber * code  = dic[@"code"];
        if ([code intValue] == 200) {
            
            NSNumber * total = dic[@"data"][@"balance"];
            totalAmount =[total floatValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [mianTableView reloadData];
                
            });
            NSLog(@"成功");
        }
    }];
}

@end
