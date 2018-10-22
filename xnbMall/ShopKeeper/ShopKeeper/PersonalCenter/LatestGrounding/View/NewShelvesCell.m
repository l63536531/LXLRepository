//
//  NewShelvesCell.m
//  ShopKeeper
//
//  Created by zhough on 16/6/21.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "NewShelvesCell.h"

@interface NewShelvesCell ()

@end

@implementation NewShelvesCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        
        
        
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(1, 1, CGRectGetWidth(self.frame)-2, CGRectGetWidth(self.frame)-2)];
        self.imgView.backgroundColor = ColorFromRGB(230, 230, 230);
        
        [self.imgView setContentMode:UIViewContentModeScaleAspectFill];
        [self.imgView setClipsToBounds:YES];
        
        [self addSubview:self.imgView];
        
        self.imgViewtap = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.imgViewtap.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.imgViewtap setContentMode:UIViewContentModeScaleAspectFill];
        [self.imgViewtap setClipsToBounds:YES];
        [self addSubview:self.imgViewtap];
        
        self.text = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.imgView.frame), CGRectGetWidth(self.frame)-10, 30)];
        [self.text setFont:[UIFont systemFontOfSize:12]];
        [self.text setNumberOfLines:0];
        self.text.backgroundColor = [UIColor whiteColor];
        [self.text setTextColor:[UIColor grayColor]];

        self.text.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.text];
        
        self.text1 = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.text.frame), CGRectGetWidth(self.frame)-10, 20)];
        self.text1.backgroundColor = [UIColor whiteColor];
        [self.text1 setTextColor:ColorFromRGB(235, 89, 82)];
        [self.text1 setFont:[UIFont systemFontOfSize:12]];
        

        self.text1.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.text1];

        self.text2 = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.text1.frame), CGRectGetWidth(self.frame)-10, 20)];
        self.text2.backgroundColor = [UIColor whiteColor];
        [self.text2 setFont:[UIFont systemFontOfSize:14]];
        [self.text2 setTextColor:ColorFromRGB(235, 89, 82)];
        [self.text2 setAdjustsFontSizeToFitWidth:YES];
        self.text2.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.text2];

        self.text3 = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.text2.frame), CGRectGetWidth(self.frame)/2, 20)];
        self.text3.backgroundColor = [UIColor whiteColor];
        [self.text3 setFont:[UIFont systemFontOfSize:12]];
        [self.text3 setTextColor:[UIColor grayColor]];
        [self.text3 setAdjustsFontSizeToFitWidth:YES];

        self.text3.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.text3];

        self.text4 = [[UILabel alloc]initWithFrame:CGRectMake(5+CGRectGetWidth(self.frame)/2, CGRectGetMaxY(self.text2.frame), CGRectGetWidth(self.frame)/2-10, 20)];
        [self.text4 setFont:[UIFont systemFontOfSize:12]];
        [self.text4 setTextColor:[UIColor grayColor]];
        [self.text4 setAdjustsFontSizeToFitWidth:YES];

        self.text4.backgroundColor = [UIColor whiteColor];
        self.text4.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.text4];

        
        
    }
    return self;
}

@end
