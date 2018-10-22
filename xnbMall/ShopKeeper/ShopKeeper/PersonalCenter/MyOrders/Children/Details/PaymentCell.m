//
//  PaymentCell.m
//  ShopKeeper
//
//  Created by zhough on 16/6/14.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "PaymentCell.h"


@interface PaymentCell()

@property (nonatomic,strong) UILabel * paylabel;//支付方式
@property (nonatomic,strong) UILabel * paytypelabel;//支付方式
@property (nonatomic,strong) UILabel * goodslabel;//商品

@property (nonatomic,strong) UILabel * pricelabel;//商品金额
@property (nonatomic,strong) UILabel * giftlabel;//礼券
@property (nonatomic,strong) UILabel * giftpricelabel;//礼券金额


@end

@implementation PaymentCell

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
        
        self.paylabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.paylabel];
        self.paytypelabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.paytypelabel];
        
        
        
        
        self.goodslabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.goodslabel];
        
        self.pricelabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.pricelabel];

        self.giftlabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.giftlabel];
        
        self.giftpricelabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.giftpricelabel];

        
//        UIImageView* lowimageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 24, 29,6, 11)];
//        [lowimageView setContentMode:UIViewContentModeScaleAspectFill];
//        [lowimageView setClipsToBounds:YES];
//        [lowimageView setImage:[UIImage imageNamed:@"arrowRight"]];
//        [self.contentView addSubview:lowimageView];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
        [line setBackgroundColor:ColorFromRGB(240, 240, 240)];
        [self.contentView addSubview:line];
        
        
        
    }
    
    return self;
    
}
-(void)update:(NSArray*)titlearray{
    _titlearray  = titlearray;
    
    [self layoutSubviews];
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    
    CGFloat leftx= 10;
    
    
    
    
    self.paylabel.frame = CGRectMake(leftx, 0, SCREEN_WIDTH/2, 40);
    [self.paylabel setFont:[UIFont systemFontOfSize:16]];
    [self.paylabel setText:@"支付方式"];
    [self.paylabel setTextColor:[UIColor grayColor]];
    [self.paylabel setNumberOfLines:0];
    [self.paylabel setTextAlignment:NSTextAlignmentLeft];
    
    
    self.paytypelabel.frame = CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3*2 - leftx, 40);
    [self.paytypelabel setFont:[UIFont systemFontOfSize:16]];
    [self.paytypelabel setText:[NSString stringWithFormat:@"%@",[_titlearray objectAtIndex:0]]];
    [self.paytypelabel setTextColor:ColorFromRGB(236, 89, 82)];
    [self.paytypelabel setNumberOfLines:0];
    [self.paytypelabel setTextAlignment:NSTextAlignmentRight];
    
    self.goodslabel.frame = CGRectMake(leftx, 40, SCREEN_WIDTH/2, 30);
    [self.goodslabel setFont:[UIFont systemFontOfSize:14]];
    [self.goodslabel setBackgroundColor:[UIColor clearColor]];
    [self.goodslabel setTextColor:[UIColor grayColor]];
    [self.goodslabel setNumberOfLines:0];
    [self.goodslabel setTextAlignment:NSTextAlignmentLeft];
    [self.goodslabel setText:@"商品价格"];//不用'金额'，因为可能是积分
    
    self.pricelabel.frame = CGRectMake(SCREEN_WIDTH/3, 40, SCREEN_WIDTH/3*2 - leftx, 30);
    [self.pricelabel setFont:[UIFont systemFontOfSize:13]];
    [self.pricelabel setBackgroundColor:[UIColor clearColor]];
    [self.pricelabel setTextColor:ColorFromRGB(236, 89, 82)];
    [self.pricelabel setNumberOfLines:0];
    [self.pricelabel setTextAlignment:NSTextAlignmentRight];
    [self.pricelabel setText:[_titlearray objectAtIndex:1]];

    
    
    self.giftlabel.frame = CGRectMake(leftx, 70, SCREEN_WIDTH/2, 30);
    [self.giftlabel setFont:[UIFont systemFontOfSize:13]];
    [self.giftlabel setText:@"礼券"];
    [self.giftlabel setTextColor:[UIColor grayColor]];
    [self.giftlabel setBackgroundColor:[UIColor clearColor]];
    [self.giftlabel setNumberOfLines:0];
    [self.giftlabel setTextAlignment:NSTextAlignmentLeft];
    
    self.giftpricelabel.frame = CGRectMake(SCREEN_WIDTH/3, 70, SCREEN_WIDTH/3*2 - leftx, 30);
    [self.giftpricelabel setFont:[UIFont systemFontOfSize:14]];
    [self.giftpricelabel setText:[_titlearray objectAtIndex:2]];
    [self.giftpricelabel setTextColor:ColorFromRGB(236, 89, 82)];
    [self.giftpricelabel setBackgroundColor:[UIColor clearColor]];
    [self.giftpricelabel setNumberOfLines:0];
    [self.giftpricelabel setTextAlignment:NSTextAlignmentRight];


    
//    NSString* labtext =[NSString stringWithFormat:@"余额：%@",[_titlearray objectAtIndex:1]] ;
//    NSMutableAttributedString *typeStr = [[NSMutableAttributedString alloc] initWithString:labtext];
//    [typeStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 3)];
//    //    [typeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12]range:NSMakeRange(0, 6)];
//    self.balancelabel.attributedText=typeStr;
    
    
    
    
}


@end
