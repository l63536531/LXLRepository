//
//  MyBankCardCell.m
//  ShopKeeper
//
//  Created by zhough on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MyBankCardCell.h"
@interface MyBankCardCell()

@property (nonatomic,strong) UILabel * accountlabel;//银行
@property (nonatomic,strong) UILabel * balancelabel;//卡号


@property (nonatomic,strong) UIButton * choosebtn;//银行卡选择
@property (nonatomic,strong) UIButton * deletebtn;//删除



@end
@implementation MyBankCardCell

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
        
        
        self.accountlabel =[[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.accountlabel];
        
        self.balancelabel =[[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.balancelabel];
        
        
        self.choosebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.choosebtn];
        
        self.deletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.deletebtn];
    
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
        [line setBackgroundColor:ColorFromRGB(240, 240, 240)];
        [self.contentView addSubview:line];
        
        UIView * line_0 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 42 , 15, 1, 20)];
        [line_0 setBackgroundColor:ColorFromRGB(240, 240, 240)];
        [self.contentView addSubview:line_0];

        
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

    self.accountlabel.frame = CGRectMake(leftx, 0, SCREEN_WIDTH/2 - leftx, 50);
    [self.accountlabel setFont:[UIFont systemFontOfSize:14]];
    [self.accountlabel setText:[NSString stringWithFormat:@"%@",[_titlearray objectAtIndex:0]]];
    [self.accountlabel setTextColor:[UIColor grayColor]];
    [self.accountlabel setBackgroundColor:[UIColor clearColor]];
    [self.accountlabel setNumberOfLines:0];
    self.accountlabel.adjustsFontSizeToFitWidth = YES;
    [self.accountlabel setTextAlignment:NSTextAlignmentLeft];
    
    
    self.balancelabel.frame = CGRectMake(SCREEN_WIDTH/2-90, 0, SCREEN_WIDTH/2 , 50);
    [self.balancelabel setFont:[UIFont systemFontOfSize:14]];
    [self.balancelabel setBackgroundColor:[UIColor clearColor]];
    [self.balancelabel setTextColor:[UIColor redColor]];
    [self.balancelabel setNumberOfLines:0];
    self.balancelabel.adjustsFontSizeToFitWidth = YES;
    [self.balancelabel setTextAlignment:NSTextAlignmentRight];
    NSString* stringcard = [_titlearray objectAtIndex:1];

    NSString* getchangestring = nil;
    if (stringcard.length > 10) {
        getchangestring =  [stringcard stringByReplacingCharactersInRange:NSMakeRange(6,  stringcard.length- 10) withString:@"******"];

    }else{
        getchangestring = stringcard;
    }

    [self.balancelabel setText:getchangestring];
    
    UIImageView* _logoImageView = [[UIImageView alloc] init];
    
    _logoImageView.frame= CGRectMake(SCREEN_WIDTH -70, 15, 20, 20);
    [_logoImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    if (_gettag == 0) {
        [_logoImageView setImage:[UIImage imageNamed:@"bankyes"]];

    }else{
        [_logoImageView setImage:[UIImage imageNamed:@"bankno"]];

    
    }
    [self.contentView addSubview:_logoImageView];
    

    [self.deletebtn setFrame:CGRectMake(SCREEN_WIDTH - 40, 5, 40, 40)];
    self.deletebtn.backgroundColor = [UIColor clearColor];
    [self.deletebtn.layer setShadowColor:[UIColor clearColor].CGColor];
    [self.deletebtn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.deletebtn setImage:[UIImage imageNamed:@"垃圾桶"] forState:UIControlStateNormal];
    [self.deletebtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.deletebtn setTag:102];

    [self.deletebtn.imageView setClipsToBounds:YES];

}

-(void)buttonclick:(id)sender{
    
    UIButton* btn = sender;
    NSInteger index = btn.tag;
    
    if ([self.delegate respondsToSelector:@selector(clickButton:)]) {
        [self.delegate clickButton:_gettag];
    }
    


}
@end
