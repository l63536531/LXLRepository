//
//  GoodsListMallViewCell.m
//  ShopKeeper
//
//  Created by zzheron on 2016/10/9.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "GoodsListMallViewCell.h"

@implementation GoodsListMallViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setSeparatorInset:UIEdgeInsetsZero];
        [self setLayoutMargins:UIEdgeInsetsZero];
        _bv_1 = [[UIView alloc] init];
        _bv_2 = [[UIView alloc] init];
        [self.contentView addSubview:_bv_1];
        [self.contentView addSubview:_bv_2];
        
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    float lheight = self.frame.size.height-10;
    float lwidth = (self.frame.size.width - 15) /2;
    
    [_bv_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).insets(UIEdgeInsetsMake(5,5,0,0));
        make.width.equalTo(@(lwidth));
        make.height.equalTo(@(lheight));
    }];
    _bv_1.layer.cornerRadius = 3.0;
    //_btn_1.backgroundColor = [UIColor lightGrayColor];
    _bv_1.backgroundColor = [UIColor whiteColor];
    //if(_data_1 != nil){
    [self makeCellLeftView];
    //}
    
    if(_data_2 != nil){
        [_bv_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bv_1.mas_right).offset(5);
            make.top.equalTo(self.contentView).offset(5);
            make.width.equalTo(@(lwidth));
            make.height.equalTo(@(lheight));
        }];
        _bv_2.layer.cornerRadius = 3.0;
        _bv_2.backgroundColor = [UIColor whiteColor];
        [self makeCellRightView];
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)makeCellLeftView{
    
    float lwidth = (self.frame.size.width - 15) /2;
    float lheight = self.frame.size.height-10;
    
    //NSLog(@"lwidth:%f  lheight:%f  ",lwidth ,lheight);
    //NSLog(@"----lwidth:%f  lheight:%f  ",lwidth-4 ,lheight-(lwidth-4));
    
    UIImageView *img = [UIImageView new];
    
    img.contentMode = UIViewContentModeScaleToFill;
    [_bv_1 addSubview:img ];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bv_1).with.insets(UIEdgeInsetsMake(2, 2, lheight-(lwidth-4), 2));
    }];
    UILabel *label_1 = [UILabel new];
    UILabel *label_2 = [UILabel new];
    UILabel *label_3 = [UILabel new];
    UILabel *label_5 = [UILabel new];
    [_bv_1 addSubview:label_1 ];
    [_bv_1 addSubview:label_2 ];
    [_bv_1 addSubview:label_3 ];
    [_bv_1 addSubview:label_5 ];
    
    
    [label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(img.mas_bottom).offset(4);
        make.left.equalTo(_bv_1).offset(2);
        make.right.equalTo(_bv_1.mas_right).offset(-2);
        make.height.mas_equalTo(@(30));
    }];
    
    
    [label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label_1.mas_bottom).offset(3);
        make.left.equalTo(_bv_1).offset(2);
        make.right.equalTo(_bv_1.mas_right).offset(-2);
        make.height.mas_equalTo(@(30));
    }];
    
    [label_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label_2.mas_bottom).offset(2);
        make.left.equalTo(_bv_1).offset(2);
        make.right.equalTo(_bv_1.mas_right).offset(-2);
        make.height.mas_equalTo(@(20));
    }];
    
    [label_5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label_3.mas_bottom).offset(2);
        make.left.equalTo(_bv_1).offset(2);
        make.right.equalTo(_bv_1.mas_right).offset(-2);
        make.height.mas_equalTo(@(20));
    }];
    
    [img sd_setImageWithURL:_data_1[@"thumbnailUrl"] placeholderImage:[UIImage imageNamed:@"commonPlaceHolderIcon"] completed:nil];
    
    //label_1.backgroundColor=HEXCOLOR(0x698B69ff);
    label_1.text=_data_1[@"title"];
    label_1.font = [UIFont systemFontOfSize:12];
    label_1.numberOfLines = 2;
    [label_1 sizeToFit];
    label_2.text=_data_1[@"subTitle"];
    label_2.font = [UIFont systemFontOfSize:12];
    label_2.numberOfLines = 2;
    label_2.textColor = [UIColor lightGrayColor];
    [label_2 sizeToFit];
    
    NSDictionary *goodsPrice = _data_1[@"goodsPrice"];
    float retailPrice  = [goodsPrice[@"retailPrice"] floatValue];
    label_3.text=[NSString stringWithFormat:@"售价 : ¥%.2f",retailPrice];
    label_3.textColor = HEXCOLOR(0xEE2C2Cff);
    label_3.font = [UIFont systemFontOfSize:14];

    if(goodsPrice.count == 0){
        UILabel *label_6 = [UILabel new];
        [_bv_1 addSubview:label_6 ];
        label_6.textColor = HEXCOLOR(0xEE2C2Cff);
        label_6.text = @"暂无货";
        [label_6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label_2.mas_bottom).offset(10);
            make.left.equalTo(_bv_1).offset(2);
            make.right.equalTo(_bv_1.mas_right).offset(-2);
            make.height.mas_equalTo(@(20));
        }];
        
        [label_3 setHidden:YES];
    }
    
    
    //label_5.backgroundColor=HEXCOLOR(0x76EEC6ff);
    NSInteger saleNumber = [_data_1[@"saleNumber"] integerValue];
    label_5.text=[NSString stringWithFormat:@"已售 %ld",saleNumber];
    label_5.font = [UIFont systemFontOfSize:12];
    label_5.textColor = HEXCOLOR(0xEE2C2Cff);
}

-(void)makeCellRightView{
    
    float lwidth = (self.frame.size.width - 15) /2;
    float lheight = self.frame.size.height-10;
    
    UIImageView *img = [UIImageView new];
    
    img.contentMode = UIViewContentModeScaleToFill;
    [_bv_2 addSubview:img ];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bv_2).with.insets(UIEdgeInsetsMake(2, 2, lheight-(lwidth-4), 2));
    }];
    UILabel *label_1 = [UILabel new];
    UILabel *label_2 = [UILabel new];
    UILabel *label_3 = [UILabel new];
    UILabel *label_5 = [UILabel new];
    [_bv_2 addSubview:label_1 ];
    [_bv_2 addSubview:label_2 ];
    [_bv_2 addSubview:label_3 ];
    [_bv_2 addSubview:label_5 ];
    
    
    [label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(img.mas_bottom).offset(4);
        make.left.equalTo(_bv_2).offset(2);
        make.right.equalTo(_bv_2.mas_right).offset(-2);
        make.height.mas_equalTo(@(30));
    }];
    
    
    [label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label_1.mas_bottom).offset(2);
        make.left.equalTo(_bv_2).offset(2);
        make.right.equalTo(_bv_2.mas_right).offset(-2);
        make.height.mas_equalTo(@(30));
    }];
    
    [label_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label_2.mas_bottom).offset(2);
        make.left.equalTo(_bv_2).offset(2);
        make.right.equalTo(_bv_2.mas_right).offset(-2);
        make.height.mas_equalTo(@(20));
    }];
    
    [label_5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label_3.mas_bottom).offset(2);
        make.left.equalTo(_bv_2).offset(2);
        make.right.equalTo(_bv_2.mas_right).offset(-2);
        make.height.mas_equalTo(@(20));
    }];
    
    
    [img sd_setImageWithURL:_data_2[@"thumbnailUrl"] placeholderImage:[UIImage imageNamed:@"commonPlaceHolderIcon"] completed:nil];
    
    //label_1.backgroundColor=HEXCOLOR(0x698B69ff);
    label_1.text=_data_2[@"title"];
    label_1.font = [UIFont systemFontOfSize:12];
    label_1.numberOfLines = 2;
    [label_1 sizeToFit];
    label_2.text=_data_2[@"subTitle"];
    label_2.font = [UIFont systemFontOfSize:12];
    label_2.numberOfLines = 2;
    label_2.textColor = [UIColor lightGrayColor];
    [label_2 sizeToFit];
    
    NSDictionary *goodsPrice = _data_2[@"goodsPrice"];
    
    float retailPrice  = [goodsPrice[@"retailPrice"] floatValue];
    label_3.text=[NSString stringWithFormat:@"售价 : ¥%.2f",retailPrice];
    label_3.textColor = HEXCOLOR(0xEE2C2Cff);
    label_3.font = [UIFont systemFontOfSize:14];
    
    
    if(goodsPrice.count == 0){
        UILabel *label_6 = [UILabel new];
        [_bv_2 addSubview:label_6 ];
        label_6.textColor = HEXCOLOR(0xEE2C2Cff);
        label_6.text = @"暂无货";
        [label_6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label_2.mas_bottom).offset(10);
            make.left.equalTo(_bv_2).offset(2);
            make.right.equalTo(_bv_2.mas_right).offset(-2);
            make.height.mas_equalTo(@(20));
        }];
        
        [label_3 setHidden:YES];
    }
    
    //label_5.backgroundColor=HEXCOLOR(0x76EEC6ff);
    NSInteger saleNumber = [_data_2[@"saleNumber"] integerValue];
    label_5.text=[NSString stringWithFormat:@"已售 %ld",saleNumber];
    label_5.font = [UIFont systemFontOfSize:12];
    label_5.textColor = HEXCOLOR(0xEE2C2Cff);
    
}

@end
