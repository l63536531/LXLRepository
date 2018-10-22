//
//  GiftVouchersCell.m
//  ShopKeeper
//
//  Created by zhough on 16/6/1.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "GiftVouchersCell.h"
@interface GiftVouchersCell (){
    
    
}

@property(nonatomic,strong)UIImageView *logoImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@end

@implementation GiftVouchersCell

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
        self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.logoImageView];
        
        self.titleLabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.titleLabel];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
        [line setBackgroundColor:ColorFromRGB(240, 240, 240)];
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
    
    _logoImageView.frame= CGRectMake(leftx, 10,30, 30);
    [_logoImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_logoImageView setClipsToBounds:YES];
    [_logoImageView setImage:[UIImage imageNamed:_imagestring]];
    [_logoImageView.layer setCornerRadius:5];
    
    self.titleLabel.frame = CGRectMake(50, 0, SCREEN_WIDTH - 140, 50);
    [self.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.titleLabel setText:_titlestring];
    [self.titleLabel setTextColor:[UIColor grayColor]];
    [self.titleLabel setNumberOfLines:0];
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
}


@end
