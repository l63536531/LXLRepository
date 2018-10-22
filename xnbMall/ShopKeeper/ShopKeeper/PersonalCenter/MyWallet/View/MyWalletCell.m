//
//  MyWalletCell.m
//  ShopKeeper
//
//  Created by zhough on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MyWalletCell.h"
#import "ShareUnity.h"

@interface MyWalletCell()

@property (nonatomic,strong) UILabel * accountlabel;//账户
@property (nonatomic,strong) UILabel * balancelabel;//余额
@property (nonatomic,strong) UILabel * servicelabel;//服务

@end

@implementation MyWalletCell

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
        self.servicelabel =[[UILabel alloc] initWithFrame:CGRectZero];

        [self.contentView addSubview:self.servicelabel];
        
        UIImageView* lowimageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 24, 29,6, 11)];
        [lowimageView setContentMode:UIViewContentModeScaleAspectFill];
        [lowimageView setClipsToBounds:YES];
        [lowimageView setImage:[UIImage imageNamed:@"arrowRight"]];
        [self.contentView addSubview:lowimageView];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 10)];
        [line setBackgroundColor:ColorFromRGB(230, 230, 230)];
        [self.contentView addSubview:line];
        
        
        
    }
    
    return self;
    
}
-(void)update:(MyWallelistModel*)model{
    _model  = model;
    
    [self layoutSubviews];
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    
    CGFloat leftx= 10;
    
    
    
    
    self.accountlabel.frame = CGRectMake(leftx, 5, SCREEN_WIDTH - 30, 30);
    [self.accountlabel setFont:[UIFont systemFontOfSize:14]];
    [self.accountlabel setText:[NSString stringWithFormat:@"账户：%@",_model.code]];
    [self.accountlabel setTextColor:[UIColor grayColor]];
    [self.accountlabel setNumberOfLines:0];
    [self.accountlabel setAdjustsFontSizeToFitWidth:YES];
    [self.accountlabel setTextAlignment:NSTextAlignmentLeft];
    
    
    self.balancelabel.frame = CGRectMake(leftx, 40, SCREEN_WIDTH - 140, 20);
    [self.balancelabel setFont:[UIFont systemFontOfSize:14]];
    [self.balancelabel setBackgroundColor:[UIColor clearColor]];
    [self.balancelabel setTextColor:[UIColor redColor]];
    [self.balancelabel setNumberOfLines:0];
    [self.balancelabel setTextAlignment:NSTextAlignmentLeft];
    
    NSString* labtext =[NSString stringWithFormat:@"余额：%.2f",[_model.balance floatValue]] ;
    NSMutableAttributedString *typeStr = [[NSMutableAttributedString alloc] initWithString:labtext];
    [typeStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 3)];
//    [typeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12]range:NSMakeRange(0, 6)];
    self.balancelabel.attributedText=typeStr;
    
    self.servicelabel.frame = CGRectMake(100, 40, SCREEN_WIDTH - 130, 20);
    [self.servicelabel setFont:[UIFont systemFontOfSize:14]];
    [self.servicelabel setText:[ShareUnity getwalletType:_model.walletType]];
    [self.servicelabel setTextColor:[UIColor grayColor]];
    [self.servicelabel setBackgroundColor:[UIColor clearColor]];
    [self.servicelabel setNumberOfLines:0];
    [self.servicelabel setTextAlignment:NSTextAlignmentRight];
    
    
    
}

-(NSString*)getwalletType:(NSString*)walletTyoe{

    
    if ([walletTyoe isEqualToString:@"normal"]) {
        
        return @"个人钱包";
        
    }else if ([walletTyoe isEqualToString:@"station"]){
    
        
        return @"服务站钱包";
    }else if ([walletTyoe isEqualToString:@"stationStore"]){
        
        
        return @"服务站门店钱包";
    }else if ([walletTyoe isEqualToString:@"center"]){
        
        
        return @"服务中心钱包";
    }else if ([walletTyoe isEqualToString:@"centerStore"]){
        
        
        return @"服务中心门店钱包";
    }else

    return @"";
}

@end
