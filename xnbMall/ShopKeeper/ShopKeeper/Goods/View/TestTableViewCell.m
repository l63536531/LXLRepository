//
//  TestTableViewCell.m
//  ShopKeeper
//
//  Created by zzheron on 16/8/1.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "TestTableViewCell.h"

@interface TestTableViewCell()

@property(nonatomic,strong)UILabel *label;
@end




@implementation TestTableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        self.label = [UILabel new];
        
        [self.contentView addSubview:self.label];
        
        
        
        
        
        
        
        return self;
    }
    return nil;
    
}


-(CGFloat)height{
    
    
    
    
    
    return self.contentView.frame.size.height;
    
    
    
}

-(void)computeHeight{
    
    self.label.text = self.data[@"content"];
    
    [self.label sizeToFit];
    
    // CGFloat height = self.label.frame.size.height;
    
    self.contentView.frame = self.label.frame;
    
    
    
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    self.label.text = self.data[@"content"];
    
    [self.label sizeToFit];
    
   // CGFloat height = self.label.frame.size.height;
    
    self.contentView.frame = self.label.frame;
    
    
    
    
    
    
    
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
