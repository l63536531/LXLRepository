//
//  SKPayWayCell.m
//  Demo-10.11
//
//  Created by djk on 16/10/13.
//  Copyright © 2016年 NQ. All rights reserved.
//

#import "SKPayWayCell.h"


@implementation SKPayWayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
    }
    return  self;
}

- (void)setup{
        self.backgroundColor = [UIColor whiteColor];
    //0.选中btn
    UIButton *pointBtn = [[UIButton alloc] init];
    [pointBtn setImage:[UIImage imageNamed:@"point_white"] forState:UIControlStateNormal];
    [pointBtn setImage:[UIImage imageNamed:@"point_red"] forState:UIControlStateSelected];
    [pointBtn addTarget:self action:@selector(pointBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:pointBtn];
    self.pointBtn = pointBtn;
    
    //1.图标ImageView
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payway_yijifu"]];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    //2.上限Label
    UILabel *limitLabel = [[UILabel alloc] init];
    limitLabel.numberOfLines = 0;
    limitLabel.font = [UIFont systemFontOfSize:12];
    limitLabel.text = @"上限:单笔2-5万,每日10万";
    limitLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:limitLabel];
    self.limitLabel = limitLabel;
    
    //3.查看各银行限额Btn
    UIButton *seeLimitBtn = [[UIButton alloc] init];
    seeLimitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    seeLimitBtn.titleLabel.numberOfLines = 0;
    [seeLimitBtn setTitle:@"查看各银行限额>>" forState:UIControlStateNormal];
    [seeLimitBtn setTitleColor:ColorFromRGB(170.f,170.f,170.f) forState:UIControlStateNormal];
    [self.contentView addSubview:seeLimitBtn];
    [seeLimitBtn addTarget:self action:@selector(seeLimitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    seeLimitBtn.hidden = YES;
    self.seeLimitBtn = seeLimitBtn;
    
    //4.会员余额Label
    UILabel *memberMoneyLabel = [[UILabel alloc] init];
    memberMoneyLabel.font = [UIFont systemFontOfSize:12];
    memberMoneyLabel.text = @"￥0.00";
    memberMoneyLabel.textColor = KFontColor(@"#ec584c");;
    [self.contentView addSubview:memberMoneyLabel];
    memberMoneyLabel.hidden = YES;
    self.memberMoneyLabel = memberMoneyLabel;
}

- (void)pointBtnDidClick:(UIButton *)pointBtn{
    if (self.point) {
        self.point(pointBtn);
    }
}

- (void)seeLimitBtnClick{
    if (self.seeLimite) {
        self.seeLimite();
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //设置子控件约束
    //0.选中btn
    [self.pointBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(30);
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(15);
    }];
    //1.图标ImageView
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(40);
        make.left.equalTo(self.pointBtn.mas_right).offset(2);
        make.width.offset(170);
        make.centerY.equalTo(self.pointBtn);
    }];
    //2.上限Label
    [self.limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(4);
    }];
    //3.查看各银行限额Btn
    [self.seeLimitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(5);
        make.right.equalTo(self).offset(-5);
    }];
   //4.会员余额Label
    [self.memberMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pointBtn);
        make.left.equalTo(self.iconImageView.mas_right).offset(5);
    }];
}

@end
