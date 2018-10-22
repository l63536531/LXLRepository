//
//  UserTabButtonCell.m
//  画图demo
//
//  Created by zhough on 16/5/27.
//  Copyright © 2016年 gzspark. All rights reserved.
//

#import "UserTabButtonCell.h"
#import "ShareUnity.h"

@interface UserTabButtonCell()

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *timeLabel;

@end

@implementation UserTabButtonCell

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
    
    
    CGFloat tabwidth = SCREEN_WIDTH / 4;
    

    CGFloat iamgeW = SCREEN_WIDTH/12;
    CGFloat labH = 25;
    CGFloat butH =labH+iamgeW+15;
    
    NSInteger getstateone = [ShareUnity managerAndserviceState];
    
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (int i= 0 ; i < _titlearray.count; i++) {
        
        int btnx = i%4;
        int btny = 0 ;
        if (i>3) {
            if (_titlearray.count == 9) {
                tabwidth = SCREEN_WIDTH / 5;
                 btnx = i%5;
            }
            btny = 1;
        }
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(tabwidth*btnx, btny*butH, tabwidth, butH)];
        btn.backgroundColor = [UIColor clearColor];
        [btn.layer setShadowColor:[UIColor clearColor].CGColor];
        [btn setTag:i+getstateone*100];
        [self.contentView  addSubview:btn];
        [btn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView* selfImageView = [[UIImageView alloc]initWithFrame:CGRectMake((tabwidth - iamgeW)/2, 15,iamgeW, iamgeW)];
        
        [selfImageView setContentMode:UIViewContentModeScaleToFill];
        
        [selfImageView setClipsToBounds:YES];
        
        [selfImageView setBackgroundColor:[UIColor clearColor]];
        
        [selfImageView setImage:[UIImage imageNamed:[_imagearray objectAtIndex:i]]];
        [btn addSubview:selfImageView];
        
        UILabel *selflab = [[UILabel alloc] init];
        [selflab setBackgroundColor:[UIColor clearColor]];
        [selflab setFrame:CGRectMake(0, 15+iamgeW, tabwidth,labH)];
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
        [self.delegate clickButton:index title:_titlearray[index%100]];
    }

}

@end
