//
//  VideoTeachingCell.m
//  ShopKeeper
//
//  Created by zhough on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "VideoTeachingCell.h"

@interface VideoTeachingCell (){
    
    
}



@property(nonatomic,strong)UIImageView *logoImageView;

@property(nonatomic,strong)UILabel *titleLabel;



@end


@implementation VideoTeachingCell

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
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 79, SCREEN_WIDTH, 1)];
        [line setBackgroundColor:ColorFromRGB(240, 240, 240)];
        [self.contentView addSubview:line];
        
        //
        self.titleLabel.frame = CGRectMake(70, 10, SCREEN_WIDTH - 130, 60);
        [self.titleLabel setTextColor:[UIColor grayColor]];
        [self.titleLabel setNumberOfLines:0];
        [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        
        _logoImageView.frame = CGRectMake(15.f, 10,50, 60);
        [_logoImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_logoImageView setClipsToBounds:YES];
        
    }
    
    return self;
    
}
-(void)update:(NSString*)imagearray title:(NSString*)titlearray{
    _imagestring = imagearray;
    _titlestring = titlearray;
    
    [_logoImageView setImage:[UIImage imageNamed:_imagestring]];
    NSURL * getimageUrl = [NSURL URLWithString:_imagestring];
    
    [_logoImageView sd_setImageWithURL:getimageUrl placeholderImage:[UIImage imageNamed:@"banner"]];
    
    [self.titleLabel setText:_titlestring];
}

@end
