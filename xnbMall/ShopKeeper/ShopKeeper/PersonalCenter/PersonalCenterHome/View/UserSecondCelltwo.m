//
//  UserSecondCelltwo.m
//  ShopKeeper
//
//  Created by zhough on 16/9/12.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "UserSecondCelltwo.h"
#import "ShareUnity.h"

@interface UserSecondCelltwo()


@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *timeLabel;





@end

@implementation UserSecondCelltwo

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        
    }
    
    return self;
    
}
-(void)update:(NSDictionary*)dic{
    
    
    [self layoutSubviews];
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    CGFloat tabwidth = SCREEN_WIDTH / 2;
    
    
    CGFloat iamgeW = SCREEN_WIDTH/12;
    CGFloat labH = 25;
    CGFloat butH =labH+iamgeW+10;
    NSInteger gettwostate = [ShareUnity managerAndserviceSecondState];

    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, butH - 1, SCREEN_WIDTH, 1)];
    [line setBackgroundColor:ColorFromRGB(240, 240, 240)];
    [self.contentView addSubview:line];
    
    for (int i= 0 ; i < _titlearray.count; i++) {
        
        
        int btnx = i;
        int btny = 0 ;
        if (i>1) {
            tabwidth = SCREEN_WIDTH / 3;
            btnx = i - 2;
            btny = 1;
        }
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(tabwidth*btnx, btny*butH, tabwidth, butH)];
        btn.backgroundColor = [UIColor clearColor];
        [btn.layer setShadowColor:[UIColor clearColor].CGColor];
        [btn setTag:i+gettwostate*1000];
        [self.contentView  addSubview:btn];
        [btn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIImageView* selfImageView = [[UIImageView alloc]initWithFrame:CGRectMake((tabwidth - iamgeW)/2, 10,iamgeW, iamgeW)];
        
        [selfImageView setContentMode:UIViewContentModeScaleToFill];
        
        [selfImageView setClipsToBounds:YES];
        
        
        [selfImageView setBackgroundColor:[UIColor clearColor]];
        
        [selfImageView setImage:[UIImage imageNamed:[_imagearray objectAtIndex:i]]];
        [btn addSubview:selfImageView];
        
        
        
        UILabel *selflab = [[UILabel alloc] init];
        [selflab setBackgroundColor:[UIColor clearColor]];
        [selflab setFrame:CGRectMake(0, 10+iamgeW, tabwidth,labH)];
        [selflab setTextColor:ColorFromHex(0x646464)];
        [selflab setText:[_titlearray objectAtIndex:i]];
        [selflab setTextAlignment:NSTextAlignmentCenter];
        [selflab setNumberOfLines:0];
        [selflab setFont:[UIFont systemFontOfSize:10]];
        selflab.adjustsFontSizeToFitWidth = YES;
        
        [btn addSubview:selflab];
        
    }
    
}

-(void)buttonclick:(id)sender{
    
    UIButton* btn = sender;
    NSInteger index = btn.tag;
    
    if ([self.delegate respondsToSelector:@selector(clickButton:title:)]) {
        [self.delegate clickButton:index title:_titlearray[index%1000]];
    }
    
}

@end