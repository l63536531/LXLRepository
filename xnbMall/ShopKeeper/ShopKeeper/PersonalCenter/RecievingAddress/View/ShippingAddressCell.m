//
//  ShippingAddressCell.m
//  ShopKeeper
//
//  Created by zhough on 16/6/1.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "ShippingAddressCell.h"
@interface ShippingAddressCell()

@property (nonatomic,strong) UILabel * namelabel;//
@property (nonatomic,strong) UILabel * phonelabel;//
@property (nonatomic,strong) UILabel * defaultlabel;//默认


@property (nonatomic,strong) UIButton * choosebtn;//银行卡选择
@property (nonatomic,strong) UIButton * deletebtn;//删除



@end

@implementation ShippingAddressCell

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
        
        self.namelabel =[[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.namelabel];
        
        self.phonelabel =[[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.phonelabel];
        
        self.defaultlabel  =[[ UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.defaultlabel];
        
        
        self.choosebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.choosebtn];
        
        self.deletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.deletebtn];
  
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 69, SCREEN_WIDTH, 1)];
        [line setBackgroundColor:ColorFromHex(0xe5e5e5)];
        [self.contentView addSubview:line];
        
        UIView * line_0 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 42 , 15, 1, 20)];
        [line_0 setBackgroundColor:ColorFromHex(0xe5e5e5)];
        [self.contentView addSubview:line_0];

    }
    
    return self;
    
}
-(void)update:(ShipingAdderssModel*)titlearray{
    _shipingmodel  = titlearray;
    
    [self layoutSubviews];
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    
    CGFloat leftx= 15;
    
    
    
    
    self.namelabel.frame = CGRectMake(leftx, 5, SCREEN_WIDTH - 100, 30);
    [self.namelabel setFont:[UIFont systemFontOfSize:16]];
    [self.namelabel setText:[NSString stringWithFormat:@"%@  %@",_shipingmodel.contactName,_shipingmodel.contactPhone]];
    [self.namelabel setTextColor:[UIColor grayColor]];
    [self.namelabel setBackgroundColor:[UIColor clearColor]];
    [self.namelabel setNumberOfLines:0];
    self.namelabel.adjustsFontSizeToFitWidth = YES;
    [self.namelabel setTextAlignment:NSTextAlignmentLeft];
    
    
    self.phonelabel.frame = CGRectMake(leftx, 35, SCREEN_WIDTH - 60 , 30);
    [self.phonelabel setFont:[UIFont systemFontOfSize:14]];
    [self.phonelabel setBackgroundColor:[UIColor clearColor]];
    [self.phonelabel setTextColor:[UIColor grayColor]];
    [self.phonelabel setNumberOfLines:0];
    self.phonelabel.adjustsFontSizeToFitWidth = YES;
    [self.phonelabel setTextAlignment:NSTextAlignmentLeft];
    
    
    NSString * pr = _shipingmodel.provincename;
    NSString * city = _shipingmodel.cityname;
    NSString * country = _shipingmodel.countyname;
    NSString * street = _shipingmodel.streetname;
    NSString * address = _shipingmodel.address;
    
    if (pr==nil||pr.length==0) {
        pr =@"";
    }
    if (city==nil||city.length==0) {
        city =@"";
    }
    if (country==nil||country.length==0) {
        country =@"";
    }
    if (street==nil||street.length==0) {
        street =@"";
    }
    if (address==nil||address.length==0) {
        address =@"";
    }
    
    
    
    
    NSString* stringcard = [NSString stringWithFormat:@"%@%@%@%@%@",pr,city,country,street,address] ;
    [self.phonelabel setText:stringcard];
    
    
    self.defaultlabel.frame = CGRectMake(SCREEN_WIDTH - 40, 40, 40, 20);
    [self.defaultlabel setFont:[UIFont systemFontOfSize:14]];
    [self.defaultlabel setText:@"默认"];
    [self.defaultlabel setTextColor:[UIColor redColor]];
    [self.defaultlabel setBackgroundColor:[UIColor clearColor]];
    [self.defaultlabel setNumberOfLines:0];
    self.defaultlabel.adjustsFontSizeToFitWidth = YES;
    [self.defaultlabel setHidden:YES];
    if (_shipingmodel.isDefault.intValue == 1) {
        [self.defaultlabel setHidden:NO];

    }
    [self.defaultlabel setTextAlignment:NSTextAlignmentLeft];
    
    
    [self.choosebtn setFrame:CGRectMake(SCREEN_WIDTH -  85, 0, 40, 40)];
    self.choosebtn.backgroundColor = [UIColor clearColor];
    [self.choosebtn.layer setShadowColor:[UIColor clearColor].CGColor];
    [self.choosebtn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.choosebtn setImage:[UIImage imageNamed:@"收获编辑"] forState:UIControlStateNormal];
    [self.choosebtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.choosebtn setTag:101];
    [self.choosebtn.imageView setClipsToBounds:YES];
    
    
    
    [self.deletebtn setFrame:CGRectMake(SCREEN_WIDTH - 40, 0, 40, 40)];
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
    
    if ([self.delegate respondsToSelector:@selector(clickButton:index:)]) {
        [self.delegate clickButton:index index:_index];
    }
    

    NSLog(@"buttonclick");
    
}

@end
