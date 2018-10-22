//
//  MyWalletCelltwo.m
//  ShopKeeper
//
//  Created by zhough on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MyWalletCelltwo.h"
@interface MyWalletCelltwo()

@property (nonatomic,strong) UILabel * accountlabel;//账户
@property (nonatomic,strong) UILabel * balancelabel;//余额
@property (nonatomic,strong) UIButton * servicebtn;//服务

@end
@implementation MyWalletCelltwo

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.accountlabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.accountlabel];
        self.balancelabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.balancelabel];
        self.servicebtn =[[UIButton alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.servicebtn];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
        [line setBackgroundColor:ColorFromRGB(230, 230, 230)];
        [self.contentView addSubview:line];
        
        
        
    }
    
    return self;
    
}
-(void)update:(NSString*)titlestring{
    _titlestring  = titlestring;
    
    [self layoutSubviews];
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    
    CGFloat leftx= 15;
    
    
    
    
    self.accountlabel.frame = CGRectMake(leftx, 0, SCREEN_WIDTH/2, 50);
    [self.accountlabel setFont:[UIFont systemFontOfSize:16]];
    [self.accountlabel setText:@"可提现余额"];
    [self.accountlabel setTextColor:[UIColor grayColor]];
    [self.accountlabel setNumberOfLines:0];
    [self.accountlabel setTextAlignment:NSTextAlignmentLeft];
    
    
    self.balancelabel.frame = CGRectMake(SCREEN_WIDTH/2,0 , SCREEN_WIDTH/2- 75, 50);
    [self.balancelabel setFont:[UIFont systemFontOfSize:16]];
    [self.balancelabel setBackgroundColor:[UIColor clearColor]];
    [self.balancelabel setTextColor:[UIColor redColor]];
    [self.balancelabel setNumberOfLines:0];
    [self.balancelabel setTextAlignment:NSTextAlignmentRight];
    NSString* labtext =[NSString stringWithFormat:@"%@元",_titlestring] ;
    [self.balancelabel setText:labtext];
    
    
    
    
    
    self.servicebtn.frame = CGRectMake(SCREEN_WIDTH - 65, 10, 50, 30);
    [self.servicebtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.servicebtn setTitle:@"提现" forState:UIControlStateNormal];
    [self.servicebtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.servicebtn setBackgroundColor:[UIColor clearColor]];
    [self.servicebtn.layer setBorderColor:[UIColor redColor].CGColor];
    [self.servicebtn.layer setBorderWidth:1];
    [self.servicebtn.layer setCornerRadius:4];
    
    [self.servicebtn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

-(void)btnclick:(id)sender{
    UIButton * btn = sender;
    
    if ([self.delegate respondsToSelector:@selector(wallettwoclick)]) {
        [self.delegate wallettwoclick];
    }
    
    
    NSLog(@"%ld",btn.tag);
    
}

@end
