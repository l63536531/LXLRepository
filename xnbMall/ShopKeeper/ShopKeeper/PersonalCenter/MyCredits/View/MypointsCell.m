//
//  MypointsCell.m
//  ShopKeeper
//
//  Created by zhough on 16/6/2.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MypointsCell.h"
@interface MypointsCell()

@property (nonatomic,strong) UILabel * accountlabel;//

@property (nonatomic,strong) UILabel * timelabel;//时间

@property (nonatomic,strong) UILabel * pointlabel;//积分



@end

@implementation MypointsCell

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
        
        
        self.pointlabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.pointlabel];
 
        
        UIView * line_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1)];
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
    
    
    
    
    self.accountlabel.frame = CGRectMake(leftx, 0, SCREEN_WIDTH - 80, 35);
    [self.accountlabel setFont:[UIFont systemFontOfSize:14]];
    [self.accountlabel setText:[NSString stringWithFormat:@"%@",[_titlearray objectAtIndex:0]]];
    [self.accountlabel setTextColor:ColorFromHex(0x646464)];
    [self.accountlabel setNumberOfLines:0];
    [self.accountlabel setTextAlignment:NSTextAlignmentLeft];
    
    
    self.timelabel.frame = CGRectMake(leftx, 35, SCREEN_WIDTH - 80, 20);
    [self.timelabel setFont:[UIFont systemFontOfSize:14]];
    [self.timelabel setText:[NSString stringWithFormat:@"%@",[_titlearray objectAtIndex:1]]];
    [self.timelabel setTextColor:ColorFromHex(0x646464)];
    [self.timelabel setNumberOfLines:0];
    [self.timelabel setTextAlignment:NSTextAlignmentLeft];
    
    
    self.pointlabel.frame = CGRectMake(SCREEN_WIDTH/3*2 - 15, 20, SCREEN_WIDTH/3, 20);
    [self.pointlabel setFont:[UIFont systemFontOfSize:14]];
    [self.pointlabel setBackgroundColor:[UIColor clearColor]];
    [self.pointlabel setText:[NSString stringWithFormat:@"%@",[_titlearray objectAtIndex:2]]];
    [self.pointlabel setTextColor:ColorFromHex(0x646464)];
    [self.pointlabel setNumberOfLines:0];
    [self.pointlabel setTextAlignment:NSTextAlignmentRight];
    
    
    
}


@end
