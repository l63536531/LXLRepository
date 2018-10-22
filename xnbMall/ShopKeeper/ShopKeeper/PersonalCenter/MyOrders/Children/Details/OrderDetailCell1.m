//
//  OrderDetailCell1.m
//  ShopKeeper
//
//  Created by zhough on 16/6/13.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "OrderDetailCell1.h"


@interface OrderDetailCell1()

@property (nonatomic,strong) UILabel * statelabel;//订单状态
@property (nonatomic,strong) UILabel * orderlabel;//订单
@property (nonatomic,strong) UILabel * instructionslabel;//介绍
@property (nonatomic, strong) UIButton * btn;

@end

@implementation OrderDetailCell1

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
        
        self.statelabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.statelabel];
        self.orderlabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.orderlabel];
        
        self.instructionslabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.instructionslabel];
        
        self.btn =[UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.contentView addSubview:self.btn];
        
//        UIImageView* lowimageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 24, 29,6, 11)];
//        [lowimageView setContentMode:UIViewContentModeScaleAspectFill];
//        [lowimageView setClipsToBounds:YES];
//        [lowimageView setImage:[UIImage imageNamed:@"arrowRight"]];
//        [self.contentView addSubview:lowimageView];
       
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 1)];
        [line setBackgroundColor:ColorFromRGB(230, 230, 230)];
        [self.contentView addSubview:line];
        
        UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, 10)];
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
    
    
    
    
    self.statelabel.frame = CGRectMake(leftx, 0, SCREEN_WIDTH /3 -leftx - 10, 30);
    [self.statelabel setFont:[UIFont systemFontOfSize:14]];
    [self.statelabel setText:[NSString stringWithFormat:@"%@",[_titlearray objectAtIndex:0]]];
    [self.statelabel setTextColor:ColorFromRGB(233, 43, 43)];
    [self.statelabel setBackgroundColor:[UIColor clearColor]];
    [self.statelabel setNumberOfLines:0];
    [self.statelabel setAdjustsFontSizeToFitWidth:YES];
    [self.statelabel setTextAlignment:NSTextAlignmentLeft];
    
    
    self.orderlabel.frame = CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3*2 - leftx, 30);
    [self.orderlabel setFont:[UIFont systemFontOfSize:14]];
    [self.orderlabel setBackgroundColor:[UIColor clearColor]];
    [self.orderlabel setTextColor:[UIColor grayColor]];
    [self.orderlabel setNumberOfLines:0];
    [self.orderlabel setTextAlignment:NSTextAlignmentRight];
    [self.orderlabel setAdjustsFontSizeToFitWidth:YES];
    
    NSString* labtext =[NSString stringWithFormat:@"订单编号：%@",[_titlearray objectAtIndex:1]] ;
       self.orderlabel.text=labtext;
    
    
    self.instructionslabel.frame = CGRectMake(10, 40, SCREEN_WIDTH - 115, 25);
    [self.instructionslabel setFont:[UIFont systemFontOfSize:14]];
    [self.instructionslabel setText:[_titlearray objectAtIndex:2]];
    [self.instructionslabel setTextColor:[UIColor grayColor]];
    [self.instructionslabel setBackgroundColor:[UIColor clearColor]];
    [self.instructionslabel setNumberOfLines:0];
    [self.instructionslabel setAdjustsFontSizeToFitWidth:YES];
    [self.instructionslabel setTextAlignment:NSTextAlignmentRight];
    
    [_btn setFrame:CGRectMake(SCREEN_WIDTH-100, 40, 70, 25)];
    [_btn setBackgroundColor:ColorFromHex(0xec584c)];
    [_btn setTag:101];
    [_btn setTitle:@"订单追踪" forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_btn.layer setCornerRadius:5];
    [_btn addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_btn];

    
}
-(void)clickbutton:(id)sender{
    if ([self.delegate respondsToSelector:@selector(clickDingDengButton)]) {
        [self.delegate clickDingDengButton];
    }

}

@end
