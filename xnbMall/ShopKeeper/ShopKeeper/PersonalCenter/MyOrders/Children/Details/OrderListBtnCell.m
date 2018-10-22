//
//  OrderListBtnCell.m
//  ShopKeeper
//
//  Created by zhough on 16/6/14.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "OrderListBtnCell.h"


@interface OrderListBtnCell()

@property (nonatomic,strong) UILabel * detaillabel;//细节
@property (nonatomic,strong) UILabel * pricelabel;//价钱
@property (nonatomic,strong) UILabel * numberlabel;//数量

@property (nonatomic, strong) UIButton * btn;


@end

@implementation OrderListBtnCell

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
        
        self.detaillabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.detaillabel];
        
        self.pricelabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.pricelabel];
        
        self.numberlabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.numberlabel];
        
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 94, SCREEN_WIDTH, 1)];
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
    
    
    
    CGFloat leftx= 10;
    CGFloat imageW = 40;
    CGFloat detailX = leftx*2 + imageW;
    
    UIImageView* lowimageView = [[UIImageView alloc]initWithFrame:CGRectMake( leftx, leftx,imageW, imageW)];
    [lowimageView setContentMode:UIViewContentModeScaleAspectFill];
    [lowimageView setClipsToBounds:YES];
    NSURL * url = [NSURL URLWithString:_titlearray[0]];
    [lowimageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    [self.contentView addSubview:lowimageView];
    
    
    self.detaillabel.frame = CGRectMake(detailX, leftx, SCREEN_WIDTH - detailX - 80, 40);
    [self.detaillabel setFont:[UIFont systemFontOfSize:12]];
    NSString * title =_titlearray[1];
    
    if (!(title.length>0)) {
        title =@" ";
    }
    
    [self.detaillabel setText:title];
    [self.detaillabel setTextColor:[UIColor grayColor]];
    [self.detaillabel setNumberOfLines:0];
    [self.detaillabel setAdjustsFontSizeToFitWidth:YES];
    [self.detaillabel setTextAlignment:NSTextAlignmentLeft];
    
    //    [Idcardone setContentVerticalAlignment : UIControlContentVerticalAlignmentTop];
    
    self.pricelabel.frame = CGRectMake(SCREEN_WIDTH - 80 , leftx, 65, 15);
    [self.pricelabel setFont:[UIFont systemFontOfSize:12]];
    [self.pricelabel setBackgroundColor:[UIColor whiteColor]];
    [self.pricelabel setTextColor:ColorFromRGB(236, 89, 82)];
    [self.pricelabel setNumberOfLines:0];
    [self.pricelabel setAdjustsFontSizeToFitWidth:YES];
    [self.pricelabel setTextAlignment:NSTextAlignmentRight];
    
    NSString* labtext =[NSString stringWithFormat:@"%@",[_titlearray objectAtIndex:2]] ;
    NSMutableAttributedString *typeStr = [[NSMutableAttributedString alloc] initWithString:labtext];
    [typeStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 3)];
    //    [typeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12]range:NSMakeRange(0, 6)];
    self.pricelabel.text=labtext;
    
    self.numberlabel.frame = CGRectMake(SCREEN_WIDTH - 80 , 35, 65, 15);
    [self.numberlabel setFont:[UIFont systemFontOfSize:12]];
    [self.numberlabel setText:[_titlearray objectAtIndex:3]];
    [self.numberlabel setTextColor:[UIColor grayColor]];
    [self.numberlabel setBackgroundColor:[UIColor whiteColor]];
    [self.numberlabel setNumberOfLines:0];
    [self.numberlabel setAdjustsFontSizeToFitWidth:YES];
    [self.numberlabel setTextAlignment:NSTextAlignmentRight];
    
    _btn= [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setFrame:CGRectMake(SCREEN_WIDTH-105, 60, 90, 25)];
    [_btn setBackgroundColor:[UIColor whiteColor]];
    [_btn setTitle:@"退款" forState:UIControlStateNormal];
    [_btn setTitleColor:ColorFromRGB(236, 89, 82) forState:UIControlStateNormal];
    [_btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_btn.layer setCornerRadius:5];
    [_btn.layer setBorderWidth:1];
    [_btn.layer setBorderColor:ColorFromRGB(236, 89, 82).CGColor];
    [_btn bk_addEventHandler:^(id sender) {
        
        if ([self.delegate respondsToSelector:@selector(clickrow:)]) {
            [self.delegate clickrow:_getrow];
        }

        
        
    } forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_btn];

    
}

@end
