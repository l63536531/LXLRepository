//
//  MyWalletCellOne.m
//  ShopKeeper
//
//  Created by zhough on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MyWalletCellOne.h"
@interface MyWalletCellOne()

@property (nonatomic,strong) UILabel * accountlabel;//标题
@property (nonatomic,strong) UILabel * balancelabel;//余额

@end
@implementation MyWalletCellOne

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
        
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
        [line setBackgroundColor:ColorFromRGB(230, 230, 230)];
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

    CGFloat leftx= 15;
    
    self.accountlabel.frame = CGRectMake(leftx, 0, SCREEN_WIDTH - 20, 50);
    [self.accountlabel setFont:[UIFont systemFontOfSize:16]];
    [self.accountlabel setText:[NSString stringWithFormat:@"%@",[_titlearray objectAtIndex:0]]];
    [self.accountlabel setTextColor:[UIColor grayColor]];
    [self.accountlabel setBackgroundColor:[UIColor clearColor]];
    [self.accountlabel setNumberOfLines:0];
    [self.accountlabel setTextAlignment:NSTextAlignmentLeft];
    
    
    self.balancelabel.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH /2- 15, 50);
    [self.balancelabel setFont:[UIFont systemFontOfSize:16]];
    [self.balancelabel setBackgroundColor:[UIColor clearColor]];
    if (_getrow == 0) {
        [self.balancelabel setTextColor:[UIColor redColor]];

    }else{
    
        [self.balancelabel setTextColor:[UIColor grayColor]];

    }
    [self.balancelabel setNumberOfLines:0];
    [self.balancelabel setTextAlignment:NSTextAlignmentRight];
    
    NSString* labtext =[NSString stringWithFormat:@"%.2f元",[[_titlearray objectAtIndex:1] floatValue]] ;
    
   [self.balancelabel setText:labtext];
    
    
}

@end
