//
//  MyRecommendedUserCtrl.m
//  ShopKeeper
//
//  Created by zhough on 16/5/29.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MyRecommendedUserCtrl.h"
#import "MyRecommendedCell.h"

@interface MyRecommendedUserCtrl ()

@end

@implementation MyRecommendedUserCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"个人信息"];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
    
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}



- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    MyRecommendedCell *cell = [[MyRecommendedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ];
    
    NSArray * imagearray = @[@"",@"",@"wodelan",@"wodelan"];
    NSArray * titlearray =@[@"用户1",@"用户2",@"用户3",@"新农"];
    NSString * titlestring =[titlearray objectAtIndex:indexPath.row];
    
    [cell update:[imagearray objectAtIndex:indexPath.row] title:titlestring];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    

    
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





@end
