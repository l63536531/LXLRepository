//
//  GoodsClassViewCell.m
//  ShopKeeper
//
//  Created by zzheron on 16/6/2.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "GoodsClassViewCell.h"

@implementation GoodsClassViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        self.imgView = [[UIImageView alloc] init];
        //self.imgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.imgView];
        
        self.title = [[UILabel alloc] init];
        self.title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.title];
        
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(2);
            make.left.equalTo(self).offset(2);
            make.right.equalTo(self.mas_right).offset(-2);
            make.height.mas_equalTo(@(frame.size.height*0.8 - 4));
        }];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(0);
            make.left.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
            make.height.mas_equalTo(@(frame.size.height*0.2));
        }];

        
    }
    return self;
}


@end
