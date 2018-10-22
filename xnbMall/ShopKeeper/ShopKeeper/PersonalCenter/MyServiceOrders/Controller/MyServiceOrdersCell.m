//
//  MyServiceOrdersCell.m
//  ShopKeeper
//
//  Created by zhough on 16/6/14.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MyServiceOrdersCell.h"


@interface MyServiceOrdersCell()


@property (nonatomic,strong) UILabel * arderlabel;//时间



@property (nonatomic,strong) UILabel * timelabel;//时间


@property (nonatomic,strong) UILabel * paylabel;//实付款

@end
@implementation MyServiceOrdersCell

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
        
        
        self.arderlabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.arderlabel];
        
        
        self.timelabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.timelabel];
        
        
        self.paylabel =[[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.paylabel];
        
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
        [line setBackgroundColor:ColorFromRGB(240, 240, 240)];
        [self.contentView addSubview:line];
        
        UIImage* imageright = [UIImage imageNamed:@"redjiantou"];
        UIImageView * imageviewright = [[UIImageView alloc] init];
        [imageviewright setBackgroundColor:[UIColor clearColor]];
        [imageviewright setContentMode:UIViewContentModeScaleAspectFill];
        [imageviewright setClipsToBounds:YES];
        [imageviewright setImage:imageright];
        [imageviewright setFrame:CGRectMake(SCREEN_WIDTH - 30, 80, 15, 20)];
        [self.contentView addSubview:imageviewright];
        
        
        UIView * line_0 = [[UIView alloc] initWithFrame:CGRectMake(0, 140, SCREEN_WIDTH, 1)];
        [line_0 setBackgroundColor:ColorFromRGB(240, 240, 240)];
        [self.contentView addSubview:line_0];
        
        
        UIView * line_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 185, SCREEN_WIDTH, 10)];
        [line_1 setBackgroundColor:ColorFromRGB(240, 240, 240)];
        [self.contentView addSubview:line_1];
        
        
    }
    
    return self;
    
}
-(void)update:(MyOrderModel*)model{
    _getmodel  = model;
    
    [self layoutSubviews];
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    
    NSDictionary * dic =nil;
    
    
    if (_getmodel.goodsList.count>0) {
        dic = _getmodel.goodsList[0];
    }
    
    CGFloat leftx= 15;
    CGFloat timelabheight = 40;
    
    self.arderlabel.frame = CGRectMake(leftx, 0, SCREEN_WIDTH-60, timelabheight);
    [self.arderlabel setFont:[UIFont systemFontOfSize:15]];
    [self.arderlabel setTextColor:[UIColor lightGrayColor]];
    [self.arderlabel setNumberOfLines:0];
    [self.arderlabel setAdjustsFontSizeToFitWidth:YES];
    [self.arderlabel setTextAlignment:NSTextAlignmentLeft];
    
    NSString * orderstate = _getmodel.orderStateDes;
    
    
    NSString* timetext =[NSString stringWithFormat:@"%@ 订单编号：%@",orderstate,_getmodel.code] ;
    NSMutableAttributedString *timetypeStr = [[NSMutableAttributedString alloc] initWithString:timetext];
    [timetypeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, orderstate.length)];
    //    [timetypeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12]range:NSMakeRange(0, 6)];
    self.arderlabel.attributedText=timetypeStr;
    
    CGFloat imageW = 60;
    CGFloat iamgeH = 80;
    
    NSArray * imageay = _getmodel.goodsList;
    NSInteger getcount = 0;
    if (2>imageay.count > 0) {
        getcount = imageay.count;
    }else if(imageay.count>=2){
        
        getcount = 2;
    }
    
    for (int i = 0 ; i<getcount; i++) {
        NSDictionary * getdic = imageay[i];
        UIImageView * imageview = [[UIImageView alloc] init];
        [imageview setBackgroundColor:[UIColor clearColor]];
        [imageview setContentMode:UIViewContentModeScaleToFill];
        [imageview setClipsToBounds:YES];
        NSURL * imageurl = [NSURL URLWithString:getdic[@"logoId"]];
        [imageview sd_setImageWithURL:imageurl placeholderImage:[UIImage imageNamed:@"wodelan"]];
        [imageview setFrame:CGRectMake(leftx+(imageW+leftx)*i, 50, imageW, iamgeH)];
        [self.contentView addSubview:imageview];
        
    }

    //    时间
    self.timelabel.frame = CGRectMake(0, 110, SCREEN_WIDTH - leftx, 30);
    [self.timelabel setFont:[UIFont systemFontOfSize:14]];
    [self.timelabel setBackgroundColor:[UIColor clearColor]];
    [self.timelabel setTextColor:[UIColor lightGrayColor]];
    self.timelabel.adjustsFontSizeToFitWidth = YES;
    [self.timelabel setTextAlignment:NSTextAlignmentRight];
    [self.timelabel setText:[NSString stringWithFormat:@"%@",_getmodel.lastUpdatedDate]];
    
    
    
    self.paylabel.frame = CGRectMake(leftx, 150, SCREEN_WIDTH -leftx, 30);
    [self.paylabel setFont:[UIFont systemFontOfSize:14]];
    [self.paylabel setTextColor:[UIColor redColor]];
    [self.paylabel setBackgroundColor:[UIColor clearColor]];
    [self.paylabel setNumberOfLines:0];
    [self.paylabel setTextAlignment:NSTextAlignmentLeft];
    
    NSString* labtext1 = nil;
    if (_getmodel.activityType == 6) {
        
        if (_getindex == 1) {
            labtext1 = [NSString stringWithFormat:@"应付款：%ld分",_getmodel.bonus] ;
            
        }else{
            labtext1 = [NSString stringWithFormat:@"实付款：%ld分",_getmodel.bonus] ;
            
            
        }
    }else{
        if (_getindex == 1) {
            labtext1 = [NSString stringWithFormat:@"应付款：¥%.2f",_getmodel.paidAmount] ;
            
        }else{
            labtext1 = [NSString stringWithFormat:@"实付款：¥%.2f",_getmodel.paidAmount] ;
            
            
        }
    
    }
    
   
    NSMutableAttributedString *typeStr1 = [[NSMutableAttributedString alloc] initWithString:labtext1];
    [typeStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 4)];
    //    [typeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12]range:NSMakeRange(0, 6)];
    self.paylabel.attributedText=typeStr1;    CGFloat btnWidth = 70;
    NSArray* btntitlearray = @[@"订单追踪"];
    
    for (int i = 0 ; i< 1; i++) {
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(SCREEN_WIDTH-(5+btnWidth) *(1+i) - 10 , 150, btnWidth, 25)];
        
        
        [btn setTitle:[btntitlearray objectAtIndex:i] forState:UIControlStateNormal];
        
        [btn setBackgroundColor:ColorFromRGB(230, 230, 230)];
        [btn setTitleColor:ColorFromRGB(233, 43, 43) forState:UIControlStateNormal];
       
        [btn setTag:i+200];
        [btn.layer setCornerRadius:5];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
 
    }
 
}

-(void)clickbutton:(id)sender{
    
    UIButton* btn = sender;
    NSInteger index = btn.tag + 200;
    
    if ([self.delegate respondsToSelector:@selector(clickButton:row:)]) {
        [self.delegate clickButton:index row:_getindexrow];
    }
    NSLog(@"%d",(int)btn.tag);
}

@end
