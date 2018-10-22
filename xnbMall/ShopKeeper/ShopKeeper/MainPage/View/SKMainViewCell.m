//
//  SKMainViewCell.m
//  ShopKeeper
//
//  Created by zzheron on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "SKMainViewCell.h"

@implementation SKMainViewCell

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
        [self addSubview:_bv_1];
        [self addSubview:_bv_2];
        
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    float lheight = self.frame.size.height-10;
    float lwidth = (self.frame.size.width - 15) /2;
    
    [_bv_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).insets(UIEdgeInsetsMake(5,5,0,0));
        make.width.equalTo(@(lwidth));
        make.height.equalTo(@(lheight));
    }];
    _bv_1.layer.cornerRadius = 3.0;
    //_btn_1.backgroundColor = [UIColor lightGrayColor];
    _bv_1.backgroundColor = [UIColor whiteColor];
    //if(_data_1 != nil){
        [self makeCellLeftView];
    //}
    
    //if(_data_2 != nil){
        [_bv_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bv_1.mas_right).offset(5);
            make.top.equalTo(self).offset(5);
            make.width.equalTo(@(lwidth));
            make.height.equalTo(@(lheight));
        }];
        _bv_2.layer.cornerRadius = 3.0;
        _bv_2.backgroundColor = [UIColor whiteColor];
        [self makeCellRightView];
    //}
    
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
    UILabel *line = [UILabel new];
    UILabel *price_1 = [UILabel new];
    UILabel *price_2 = [UILabel new];
    UILabel *price_3 = [UILabel new];
    UILabel *label_5 = [UILabel new];
    [_bv_1 addSubview:label_1 ];
    [_bv_1 addSubview:line ];
    [_bv_1 addSubview:price_1 ];
    [_bv_1 addSubview:price_2 ];
    [_bv_1 addSubview:price_3 ];
    [_bv_1 addSubview:label_5 ];
    
    
    [label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(img.mas_bottom).offset(2);
        make.left.equalTo(_bv_1).offset(2);
        make.right.equalTo(_bv_1.mas_right).offset(-2);
        make.height.mas_equalTo(@(40));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label_1.mas_bottom).offset(2);
        make.left.equalTo(_bv_1).offset(0);
        make.right.equalTo(_bv_1.mas_right).offset(0);
        make.height.mas_equalTo(@(1));
    }];
    
    
    
    NSDictionary *goodsPrice = _data_1[@"goodsPrice"];
    
    NSInteger pricetype = [_user GetPriceType:goodsPrice];
    if(pricetype == 2 || pricetype == 4){
        [price_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(2);
            make.left.equalTo(_bv_1).offset(2);
            make.right.equalTo(_bv_1.mas_right).offset(-2);
            make.height.mas_equalTo(@(20));
        }];
        
        [price_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(price_1.mas_bottom).offset(2);
            make.left.equalTo(_bv_1).offset(2);
            make.right.equalTo(_bv_1.mas_right).offset(-2);
            make.height.mas_equalTo(@(20));
        }];
        
        [price_3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(price_2.mas_bottom).offset(2);
            make.left.equalTo(_bv_1).offset(2);
            make.right.equalTo(_bv_1.mas_right).offset(-2);
            make.height.mas_equalTo(@(20));
        }];
        [label_5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(price_3.mas_bottom).offset(2);
            make.left.equalTo(_bv_1).offset(2);
            make.right.equalTo(_bv_1.mas_right).offset(-2);
            make.height.mas_equalTo(@(20));
        }];//销售量
        
        
    }
    
    if(pricetype == 1 || pricetype == 3 || pricetype == 5 ){
        [price_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(5);
            make.left.equalTo(_bv_1).offset(2);
            make.right.equalTo(_bv_1.mas_right).offset(-2);
            make.height.mas_equalTo(@(20));
        }];
        
        [price_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(price_1.mas_bottom).offset(5);
            make.left.equalTo(_bv_1).offset(2);
            make.right.equalTo(_bv_1.mas_right).offset(-2);
            make.height.mas_equalTo(@(20));
        }];
        
        
        [label_5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(price_2.mas_bottom).offset(5);
            make.left.equalTo(_bv_1).offset(2);
            make.right.equalTo(_bv_1.mas_right).offset(-2);
            make.height.mas_equalTo(@(20));
        }];//销售量
    }
    
    
    
    
    [img sd_setImageWithURL:_data_1[@"thumbnailUrl"] placeholderImage:[UIImage imageNamed:@"commonPlaceHolderIcon"] completed:nil];
    
    //label_1.backgroundColor=HEXCOLOR(0x698B69ff);
    label_1.text=_data_1[@"title"];
    label_1.font = [UIFont systemFontOfSize:14];
    label_1.numberOfLines = 2;
    [label_1 sizeToFit];
    
    price_1.font = [UIFont systemFontOfSize:12];
    price_1.textColor = [UIColor grayColor];
    price_2.font = [UIFont systemFontOfSize:12];
    price_2.textColor = [UIColor grayColor];
    price_3.font = [UIFont systemFontOfSize:12];
    price_3.textColor = [UIColor grayColor];
    
    UIColor *clor = HEXCOLOR(0xEE2C2Cff);
    
    NSDictionary *attrline = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    
    float costPrice  = [goodsPrice[@"costPrice"] floatValue];
    NSString *strlabel_1 = [NSString stringWithFormat:@"进货价 : ¥%.2f",costPrice];
    NSMutableAttributedString *attr_1 = [[NSMutableAttributedString alloc] initWithString:strlabel_1];
    NSRange range_1 = [strlabel_1 rangeOfString:@":"];
    [attr_1 addAttribute:NSForegroundColorAttributeName
                   value:clor
                   range:NSMakeRange(range_1.location+1, [strlabel_1 length] - range_1.location-1)];
    price_1.attributedText =attr_1 ;
    
    if(pricetype == 1 || pricetype == 3 || pricetype == 5){
        float retailPrice  = [goodsPrice[@"retailPrice"] floatValue];
        NSString *strlabel_2 = [NSString stringWithFormat:@"建议售价 : ¥%.2f",retailPrice];
        NSMutableAttributedString *attr_2 = [[NSMutableAttributedString alloc] initWithString:strlabel_2];
        NSRange range_2 = [strlabel_2 rangeOfString:@":"];
        [attr_2 addAttribute:NSForegroundColorAttributeName
                       value:clor
                       range:NSMakeRange(range_2.location+1, [strlabel_2 length] - range_2.location-1)];
        [attr_2 addAttributes:attrline
                        range:NSMakeRange(0,[strlabel_2 length])];
        price_2.attributedText = attr_2;
    }else if(pricetype == 2 || pricetype == 4 ){
        NSString *stationPrice = @"";
        
        if(goodsPrice[@"stationPrice"] == nil){
            stationPrice = @"未提供";
        }else{
            stationPrice = [NSString stringWithFormat:@"¥%.2f",
                            [goodsPrice[@"stationPrice"] floatValue]];
        }
        NSString *strlabel_2 = [NSString stringWithFormat:@"服务站价 : %@",stationPrice];
        NSMutableAttributedString *attr_2 = [[NSMutableAttributedString alloc] initWithString:strlabel_2];
        NSRange range_2 = [strlabel_2 rangeOfString:@":"];
        [attr_2 addAttribute:NSForegroundColorAttributeName
                       value:clor
                       range:NSMakeRange(range_2.location+1, [strlabel_2 length] - range_2.location-1)];
        [attr_2 addAttributes:attrline
                        range:NSMakeRange(0,[strlabel_2 length])];
        price_2.attributedText = attr_2;
        
        
        float retailPrice  = [goodsPrice[@"retailPrice"] floatValue];
        NSString *strlabel_3 = [NSString stringWithFormat:@"建议售价 : ¥%.2f",retailPrice];
        NSMutableAttributedString *attr_3 = [[NSMutableAttributedString alloc] initWithString:strlabel_3];
        NSRange range_3 = [strlabel_3 rangeOfString:@":"];
        [attr_3 addAttribute:NSForegroundColorAttributeName
                       value:clor
                       range:NSMakeRange(range_3.location+1, [strlabel_3 length] - range_3.location-1)];
        [attr_3 addAttributes:attrline
                        range:NSMakeRange(0,[strlabel_3 length])];
        price_3.attributedText = attr_3;
        
    }
    
    
    //label_5.backgroundColor=HEXCOLOR(0x76EEC6ff);
    NSInteger saleNumber = [_data_1[@"saleNumber"] integerValue];
    label_5.text=[NSString stringWithFormat:@"已售 %ld",saleNumber];
    label_5.font = [UIFont systemFontOfSize:12];
    label_5.textColor = HEXCOLOR(0xEE2C2Cff);
    
    
    line.backgroundColor=HEXCOLOR(0xCFCFCFff);
    
    if(goodsPrice.count == 0){
        UILabel *label_6 = [UILabel new];
        [_bv_1 addSubview:label_6 ];
        label_6.textColor = HEXCOLOR(0xEE2C2Cff);
        label_6.text = @"暂无货";
        label_6.font = [UIFont systemFontOfSize:16];
        [label_6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label_1.mas_bottom).offset(25);
            make.left.equalTo(_bv_1).offset(2);
            make.right.equalTo(_bv_1.mas_right).offset(-2);
            make.height.mas_equalTo(@(20));
        }];
        [price_1 setHidden:YES];
        [price_2 setHidden:YES];
        [price_3 setHidden:YES];
    }

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
    UILabel *line = [UILabel new];
    UILabel *price_1 = [UILabel new];
    UILabel *price_2 = [UILabel new];
    UILabel *price_3 = [UILabel new];
    UILabel *label_5 = [UILabel new];
    [_bv_2 addSubview:label_1 ];
    [_bv_2 addSubview:line ];
    [_bv_2 addSubview:price_1 ];
    [_bv_2 addSubview:price_2 ];
    [_bv_2 addSubview:price_3 ];
    [_bv_2 addSubview:label_5 ];
    
    
    [label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(img.mas_bottom).offset(2);
        make.left.equalTo(_bv_2).offset(2);
        make.right.equalTo(_bv_2.mas_right).offset(-2);
        make.height.mas_equalTo(@(40));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label_1.mas_bottom).offset(2);
        make.left.equalTo(_bv_2).offset(0);
        make.right.equalTo(_bv_2.mas_right).offset(0);
        make.height.mas_equalTo(@(1));
    }];
    


    NSDictionary *goodsPrice = _data_2[@"goodsPrice"];

    NSInteger pricetype = [_user GetPriceType:goodsPrice];
    
    
    if(pricetype == 2 || pricetype == 4){
        [price_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(2);
            make.left.equalTo(_bv_2).offset(2);
            make.right.equalTo(_bv_2.mas_right).offset(-2);
            make.height.mas_equalTo(@(20));
        }];
        
        [price_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(price_1.mas_bottom).offset(2);
            make.left.equalTo(_bv_2).offset(2);
            make.right.equalTo(_bv_2.mas_right).offset(-2);
            make.height.mas_equalTo(@(20));
        }];
        
        [price_3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(price_2.mas_bottom).offset(2);
            make.left.equalTo(_bv_2).offset(2);
            make.right.equalTo(_bv_2.mas_right).offset(-2);
            make.height.mas_equalTo(@(20));
        }];
        [label_5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(price_3.mas_bottom).offset(2);
            make.left.equalTo(_bv_2).offset(2);
            make.right.equalTo(_bv_2.mas_right).offset(-2);
            make.height.mas_equalTo(@(20));
        }];//销售量
        
        
    }
    
    if(pricetype == 1 || pricetype == 3 || pricetype == 5 ){
        [price_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(5);
            make.left.equalTo(_bv_2).offset(2);
            make.right.equalTo(_bv_2.mas_right).offset(-2);
            make.height.mas_equalTo(@(20));
        }];
        
        [price_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(price_1.mas_bottom).offset(5);
            make.left.equalTo(_bv_2).offset(2);
            make.right.equalTo(_bv_2.mas_right).offset(-2);
            make.height.mas_equalTo(@(20));
        }];
        
        
        [label_5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(price_2.mas_bottom).offset(5);
            make.left.equalTo(_bv_2).offset(2);
            make.right.equalTo(_bv_2.mas_right).offset(-2);
            make.height.mas_equalTo(@(20));
        }];//销售量
    }
    

    
    
    [img sd_setImageWithURL:_data_2[@"thumbnailUrl"] placeholderImage:[UIImage imageNamed:@"commonPlaceHolderIcon"] completed:nil];
    
    //label_1.backgroundColor=HEXCOLOR(0x698B69ff);
    label_1.text=_data_2[@"title"];
    label_1.font = [UIFont systemFontOfSize:14];
    label_1.numberOfLines = 2;
    [label_1 sizeToFit];
    
    price_1.font = [UIFont systemFontOfSize:12];
    price_1.textColor = [UIColor grayColor];
    price_2.font = [UIFont systemFontOfSize:12];
    price_2.textColor = [UIColor grayColor];
    price_3.font = [UIFont systemFontOfSize:12];
    price_3.textColor = [UIColor grayColor];

    UIColor *clor = HEXCOLOR(0xEE2C2Cff);

    NSDictionary *attrline = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    
    float costPrice  = [goodsPrice[@"costPrice"] floatValue];
    NSString *strlabel_1 = [NSString stringWithFormat:@"进货价 : ¥%.2f",costPrice];
    NSMutableAttributedString *attr_1 = [[NSMutableAttributedString alloc] initWithString:strlabel_1];
    NSRange range_1 = [strlabel_1 rangeOfString:@":"];
    [attr_1 addAttribute:NSForegroundColorAttributeName
                value:clor
                range:NSMakeRange(range_1.location+1, [strlabel_1 length] - range_1.location-1)];
    price_1.attributedText =attr_1 ;
    
    if(pricetype == 1 || pricetype == 3 || pricetype == 5){
        float retailPrice  = [goodsPrice[@"retailPrice"] floatValue];
        NSString *strlabel_2 = [NSString stringWithFormat:@"建议售价 : ¥%.2f",retailPrice];
        NSMutableAttributedString *attr_2 = [[NSMutableAttributedString alloc] initWithString:strlabel_2];
        NSRange range_2 = [strlabel_2 rangeOfString:@":"];
        [attr_2 addAttribute:NSForegroundColorAttributeName
                       value:clor
                       range:NSMakeRange(range_2.location+1, [strlabel_2 length] - range_2.location-1)];
        [attr_2 addAttributes:attrline
                        range:NSMakeRange(0,[strlabel_2 length])];
        price_2.attributedText = attr_2;
    }else if(pricetype == 2 || pricetype == 4 ){
        NSString *stationPrice = @"";
        
        if(goodsPrice[@"stationPrice"] == nil){
            stationPrice = @"未提供";
        }else{
            stationPrice = [NSString stringWithFormat:@"¥%.2f",
                            [goodsPrice[@"stationPrice"] floatValue]];
        }
        NSString *strlabel_2 = [NSString stringWithFormat:@"服务站价 : %@",stationPrice];
        NSMutableAttributedString *attr_2 = [[NSMutableAttributedString alloc] initWithString:strlabel_2];
        NSRange range_2 = [strlabel_2 rangeOfString:@":"];
        [attr_2 addAttribute:NSForegroundColorAttributeName
                       value:clor
                       range:NSMakeRange(range_2.location+1, [strlabel_2 length] - range_2.location-1)];
        [attr_2 addAttributes:attrline
                        range:NSMakeRange(0,[strlabel_2 length])];
        price_2.attributedText = attr_2;
        
        
        float retailPrice  = [goodsPrice[@"retailPrice"] floatValue];
        NSString *strlabel_3 = [NSString stringWithFormat:@"建议售价 : ¥%.2f",retailPrice];
        NSMutableAttributedString *attr_3 = [[NSMutableAttributedString alloc] initWithString:strlabel_3];
        NSRange range_3 = [strlabel_3 rangeOfString:@":"];
        [attr_3 addAttribute:NSForegroundColorAttributeName
                       value:clor
                       range:NSMakeRange(range_3.location+1, [strlabel_3 length] - range_3.location-1)];
        [attr_3 addAttributes:attrline
                        range:NSMakeRange(0,[strlabel_3 length])];
        price_3.attributedText = attr_3;

    }
    
    
    //label_5.backgroundColor=HEXCOLOR(0x76EEC6ff);
    NSInteger saleNumber = [_data_2[@"saleNumber"] integerValue];
    label_5.text=[NSString stringWithFormat:@"已售 %ld",saleNumber];
    label_5.font = [UIFont systemFontOfSize:12];
    label_5.textColor = HEXCOLOR(0xEE2C2Cff);
    
    
    line.backgroundColor=HEXCOLOR(0xCFCFCFff);
    
    if(goodsPrice.count == 0){
        UILabel *label_6 = [UILabel new];
        [_bv_2 addSubview:label_6 ];
        label_6.textColor = HEXCOLOR(0xEE2C2Cff);
        label_6.text = @"暂无货";
        label_6.font = [UIFont systemFontOfSize:16];
        [label_6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label_1.mas_bottom).offset(25);
            make.left.equalTo(_bv_2).offset(2);
            make.right.equalTo(_bv_2.mas_right).offset(-2);
            make.height.mas_equalTo(@(20));
        }];
        [price_1 setHidden:YES];
        [price_2 setHidden:YES];
        [price_3 setHidden:YES];
    }

    
}

@end
