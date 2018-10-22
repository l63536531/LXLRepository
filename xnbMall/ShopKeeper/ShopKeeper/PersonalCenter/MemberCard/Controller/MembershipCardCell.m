//
//  MembershipCardCell.m
//  ShopKeeper
//
//  Created by zhough on 16/6/2.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MembershipCardCell.h"
@interface MembershipCardCell (){
    
    
}



@property(nonatomic,strong)UIImageView *logoImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *titleLabel0;


@end

@implementation MembershipCardCell

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
        
        
        
//        self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        
//        [self.contentView addSubview:self.logoImageView];
        
        self.titleLabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.titleLabel];
        
        self.titleLabel0 =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.titleLabel0];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1)];
        [line setBackgroundColor:BACKGROUND_COLOR];
        [self.contentView addSubview:line];
        
        
        
    }
    
    return self;
    
}
-(void)update:(NSString*)imagearray title:(NSString*)titlearray{
    _imagestring = imagearray;
    _titlestring = titlearray;
    
    [self layoutSubviews];
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];

    CGFloat leftx= 15;
   
    self.titleLabel.frame = CGRectMake(leftx, 0, SCREEN_WIDTH/2, 60);
    [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.titleLabel setText:_titlestring];
    [self.titleLabel setTextColor:TEXTCURRENT_COLOR];
    [self.titleLabel setNumberOfLines:0];
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    
    
    self.titleLabel0.frame = CGRectMake(SCREEN_WIDTH/2+leftx, 0, SCREEN_WIDTH/2 - 50, 60);
    [self.titleLabel0 setFont:[UIFont systemFontOfSize:14]];
    
    [self.titleLabel0 setText:[NSString stringWithFormat:@"余额  ¥ %.2f",_imagestring.floatValue]];
    [self.titleLabel0 setTextColor:KFontColor(@"#ec584c")];
    [self.titleLabel0 setNumberOfLines:0];
    [self.titleLabel0 setTextAlignment:NSTextAlignmentLeft];

}


@end
