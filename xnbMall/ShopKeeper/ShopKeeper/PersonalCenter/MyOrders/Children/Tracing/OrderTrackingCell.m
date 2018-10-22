//
//  OrderTrackingCell.m
//  ShopKeeper
//
//  Created by zhough on 16/6/14.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "OrderTrackingCell.h"


@interface OrderTrackingCell()

@property (nonatomic,strong) UILabel * detaillabel;//细节
@property (nonatomic,strong) UILabel * timelabel;//时间

@property (nonatomic,strong) UIView * roundView;


@end


@interface OrderTrackingCell () {
    
    UIButton *_btn;
}

@end

@implementation OrderTrackingCell

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
        self.accessoryType = UITableViewCellAccessoryNone;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        self.detaillabel =[[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.detaillabel];
        
        self.timelabel =[[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.timelabel];
        
        UIView* verticalLine = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 1, 70)];
        [verticalLine setBackgroundColor:ColorFromRGB(230, 230, 230)];
        [self.contentView addSubview:verticalLine];
        
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(30, 69, SCREEN_WIDTH - 30, 1)];
        [line setBackgroundColor:ColorFromRGB(230, 230, 230)];
        [self.contentView addSubview:line];
        
        _roundView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_roundView];
        
        CGFloat leftx= 30;
        _roundView.frame = CGRectMake(10.5, 30, 10, 10);
        [_roundView.layer setCornerRadius:5];
        
        self.detaillabel.frame = CGRectMake(leftx, 5, SCREEN_WIDTH - 40, 40);
        [self.detaillabel setFont:[UIFont systemFontOfSize:14]];
        [self.detaillabel setTextColor:[UIColor grayColor]];
        [self.detaillabel setNumberOfLines:0];
        [self.detaillabel setTextAlignment:NSTextAlignmentLeft];
        
        self.timelabel.frame = CGRectMake(leftx, 45, SCREEN_WIDTH - 140, 20);
        [self.timelabel setFont:[UIFont systemFontOfSize:14]];
        [self.timelabel setBackgroundColor:[UIColor clearColor]];
        [self.timelabel setTextColor:[UIColor grayColor]];
        [self.timelabel setNumberOfLines:0];
        [self.timelabel setTextAlignment:NSTextAlignmentLeft];
        
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(SCREEN_WIDTH-105 , 45, 90, 25)];
        [btn setTitle:@"快递到哪了？" forState:UIControlStateNormal];
        
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitleColor:ColorFromRGB(233, 43, 43) forState:UIControlStateNormal];
        [btn setHidden:YES];
        [btn.layer setCornerRadius:5];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        _btn = btn;
    }
    
    return self;
    
}
-(void)update:(NSArray*)titlearray{
    _titlearray  = titlearray;
    
    [self layoutSubviews];
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.detaillabel setText:[NSString stringWithFormat:@"%@",[_titlearray objectAtIndex:0]]];
    self.timelabel.text=[_titlearray objectAtIndex:1];
    
    
    if (_getsetion == 0) {
        [_roundView setBackgroundColor:[UIColor redColor]];
        
    }else{
        [_roundView setBackgroundColor:ColorFromRGB(230, 230, 230)];
    }
    
    [_btn setHidden:!_isbtnshow];
}

-(void)clickbutton:(id)sender{
    
    UIButton* btn = sender;
    
    if ([self.delegate respondsToSelector:@selector(clickButton:)]) {
        [self.delegate clickButton:_getsetion];
    }
    NSLog(@"%d",(int)btn.tag);
}


@end

