//
//  MsgViewCell.m
//  ShopKeeper
//
//  Created by zzheron on 16/6/21.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MsgViewCell.h"

@implementation MsgViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        _title = [[UILabel alloc] init];
        _subtitle = [[UILabel alloc] init];
        _datelabel = [[UILabel alloc] init];
        [self addSubview:_title];
        [self addSubview:_datelabel];
        [self addSubview:_subtitle];
        
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self).offset(-70);
        make.height.mas_equalTo(@(30));
    }];
    
    [self.datelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self.title.mas_right).offset(5);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.mas_equalTo(@(25));
    }];
    
    [self.subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(1);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.mas_equalTo(@(30));
    
    }];
    
    
    self.readed = [_data[@"readed"] integerValue];
    if (self.readed  == 0) {
        self.subtitle.textColor = [UIColor colorWithHexString:@"#646464"];
        self.title.textColor = [UIColor colorWithHexString:@"#646464"];
        self.datelabel.textColor = [UIColor colorWithHexString:@"#646464"];
    }else{
        
        self.subtitle.textColor = [UIColor colorWithHexString:@"#BEBEBE"];
        self.title.textColor = [UIColor colorWithHexString:@"#BEBEBE"];
        self.datelabel.textColor = [UIColor colorWithHexString:@"#BEBEBE"];
    }

//    NSNumber * getread = _data[@"readed"];
//    if ([getread intValue] != 1) {
//        
//        self.subtitle.textColor = [UIColor colorWithHexString:@"#646464"];
//        self.title.textColor = [UIColor colorWithHexString:@"#646464"];
//        self.datelabel.textColor = [UIColor colorWithHexString:@"#646464"];
//    }else{
//        
//        self.subtitle.textColor = [UIColor colorWithHexString:@"#BEBEBE"];
//        self.title.textColor = [UIColor colorWithHexString:@"#BEBEBE"];
//        self.datelabel.textColor = [UIColor colorWithHexString:@"#BEBEBE"];
//    
//    }
    
    self.title.font = [UIFont systemFontOfSize:14];
    self.subtitle.font = [UIFont systemFontOfSize:12];
    [self.subtitle setNumberOfLines:2];
    self.datelabel.font = [UIFont systemFontOfSize:12];
   
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
