//
//  CouponValidCell.m
//  ShopKeeper
//
//  Created by zhough on 16/6/2.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "CouponValidCell.h"
@interface CouponValidCell()

@property (nonatomic,strong) UILabel * accountlabel;//订单

@property (nonatomic,strong) UILabel * timelabel;//时间

@property (nonatomic,strong) UILabel * moneylabel;//价钱

@property (nonatomic,strong) UILabel * balancelabel;//余额


@end

@implementation CouponValidCell

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
        
        self.timelabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.timelabel];
        
        
        self.moneylabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.moneylabel];
        
        self.balancelabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.balancelabel];
        
        
        
        
       
        
        
        UIView * line_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 10)];
        [line_1 setBackgroundColor:ColorFromRGB(240, 240, 240)];
        [self.contentView addSubview:line_1];
        
        
    }
    
    return self;
    
}
-(void)update:(NSArray*)titlearray{
    _titlearray  = titlearray;
    
    [self layoutSubviews];
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    
    CGFloat leftx= 15;
    
    
    
    
    self.accountlabel.frame = CGRectMake(leftx, 5, SCREEN_WIDTH - 20, 20);
    [self.accountlabel setFont:[UIFont systemFontOfSize:13]];
    [self.accountlabel setText:[NSString stringWithFormat:@"%@",[_titlearray objectAtIndex:0]]];
    [self.accountlabel setTextColor:[UIColor grayColor]];
    [self.accountlabel setNumberOfLines:0];
    [self.accountlabel setTextAlignment:NSTextAlignmentLeft];
    
    
    self.timelabel.frame = CGRectMake(leftx, 25, SCREEN_WIDTH - 20, 15);
    [self.timelabel setFont:[UIFont systemFontOfSize:14]];
    [self.timelabel setText:[NSString stringWithFormat:@"%@",[_titlearray objectAtIndex:1]]];
    [self.timelabel setTextColor:[UIColor lightGrayColor]];
    [self.timelabel setNumberOfLines:0];
    [self.timelabel setTextAlignment:NSTextAlignmentLeft];
    
    
    self.moneylabel.frame = CGRectMake(leftx, 40, SCREEN_WIDTH/2, 30);
    [self.moneylabel setFont:[UIFont systemFontOfSize:14]];
    [self.moneylabel setText:[NSString stringWithFormat:@"%@",[_titlearray objectAtIndex:2]]];
    
    if ([[_titlearray objectAtIndex:2] hasSuffix:@"可用"]) {
        [self.moneylabel setTextColor:[UIColor redColor]];

    }else{
        [self.moneylabel setTextColor:[UIColor lightGrayColor]];

    }
    [self.moneylabel setNumberOfLines:0];
    [self.moneylabel setTextAlignment:NSTextAlignmentLeft];
    
    
    self.balancelabel.frame = CGRectMake(SCREEN_WIDTH/2, 40, SCREEN_WIDTH/2 - 15, 30);
    [self.balancelabel setFont:[UIFont systemFontOfSize:14]];
    [self.balancelabel setBackgroundColor:[UIColor clearColor]];
    [self.balancelabel setTextColor:[UIColor redColor]];
    [self.balancelabel setNumberOfLines:0];
    [self.balancelabel setTextAlignment:NSTextAlignmentRight];
    
//    NSString* labtext =[NSString stringWithFormat:@"余额：%@",[_titlearray objectAtIndex:3]] ;
//    NSMutableAttributedString *typeStr = [[NSMutableAttributedString alloc] initWithString:labtext];
//    [typeStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 3)];
//    //    [typeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12]range:NSMakeRange(0, 6)];
//    self.balancelabel.attributedText=typeStr;
    
 
    
    
    
}


@end
