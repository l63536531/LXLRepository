//
//  OrderAddressCell.m
//  ShopKeeper
//
//  Created by zhough on 16/6/13.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "OrderAddressCell.h"
@interface OrderAddressCell()

@property (nonatomic,strong) UILabel * namelabel;//订单状态
@property (nonatomic,strong) UILabel * addresslabel;//订单

@end
@implementation OrderAddressCell
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
        
        self.namelabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.namelabel];
        self.addresslabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.addresslabel];
        
     
        
        UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 10)];
        [line1 setBackgroundColor:ColorFromRGB(230, 230, 230)];
        [self.contentView addSubview:line1];
        
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
    
    
    
    
    self.namelabel.frame = CGRectMake(leftx, 10, SCREEN_WIDTH  - leftx*2, 20);
    [self.namelabel setFont:[UIFont systemFontOfSize:16]];
    [self.namelabel setText:[NSString stringWithFormat:@"%@",[_titlearray objectAtIndex:0]]];
    [self.namelabel setTextColor:[UIColor grayColor]];
    [self.namelabel setBackgroundColor:[UIColor clearColor]];
    [self.namelabel setNumberOfLines:0];
    [self.namelabel setAdjustsFontSizeToFitWidth:YES];
    [self.namelabel setTextAlignment:NSTextAlignmentLeft];
    
    
    self.addresslabel.frame = CGRectMake(leftx, 30, SCREEN_WIDTH  - leftx*2, 20);
    [self.addresslabel setFont:[UIFont systemFontOfSize:14]];
    [self.addresslabel setBackgroundColor:[UIColor clearColor]];
    [self.addresslabel setTextColor:[UIColor grayColor]];
    [self.addresslabel setNumberOfLines:0];
    [self.addresslabel setTextAlignment:NSTextAlignmentLeft];
    [self.addresslabel setAdjustsFontSizeToFitWidth:YES];
    
    NSString* labtext =[NSString stringWithFormat:@"%@",[_titlearray objectAtIndex:1]] ;
    self.addresslabel.text=labtext;
    
    
    
    
}



@end
