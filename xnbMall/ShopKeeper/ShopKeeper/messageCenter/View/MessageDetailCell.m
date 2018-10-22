//
//  MessageDetailCell.m
//  ShopKeeper
//
//  Created by frechai on 16/11/23.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MessageDetailCell.h"
#import "UIFactory.h"
#import "UIColor+_6DataColor.h"
#import "Tool.h"
@interface MessageDetailCell ()


@property (nonatomic,strong)UILabel *comment_user_name ;

@property (nonatomic,strong)UILabel *time ;
//@property (nonatomic,strong)UIButton *clickButton;
@end
@implementation MessageDetailCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        self.comment_user_name  =[UIFactory creatLabelWithtext:@"" textColor:KFontColor(@"#646464") font:12 textAlignment:NSTextAlignmentLeft];
        [self addSubview:self.comment_user_name];
        self.time  =[UIFactory creatLabelWithtext:@"" textColor:KFontColor(@"#646464") font:10 textAlignment:NSTextAlignmentRight];
        [self addSubview:self.time];
        
        
        [self.comment_user_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(25);
            make.right.equalTo(self).offset(-10);
        }];
        [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self.comment_user_name.mas_bottom).offset(5);
            make.right.equalTo(self).offset(-10);
        }];

    }
    return self;
}


-(void)fillCellWithMessageDetailModel:(Model_message_messageDetail_data*)model{
    
    self.comment_user_name.text =[model.content stringByAppendingString:@"   点击进入"];
    
    self.time.text =model.createTime;
    
    
    
}


+(CGFloat)getHeightCellWithMessageDetailModel:(Model_message_messageDetail_data*)model{
    

    CGFloat heith =[Tool getAdaptionSizeWithText:model.content andFont:[UIFont systemFontOfSize:12] andLabelWidth:(SCREEN_WIDTH-20)].height +35;
     CGFloat heith2 =[Tool getAdaptionSizeWithText:model.createTime andFont:[UIFont systemFontOfSize:10] andLabelWidth:(SCREEN_WIDTH-20)].height;
    
    return heith+heith2;
    
}

/*@interface Model_message_messageDetail_data: Model_Interface
 @property (nonatomic,copy)NSString <Optional> *id;
 @property (nonatomic,copy)NSString <Optional> *messageType;
 @property (nonatomic,copy)NSString <Optional> *notify;
 @property (nonatomic,copy)NSString <Optional> *title;
 @property (nonatomic,copy)NSString <Optional> *link;
 @property (nonatomic,copy)NSString <Optional> *summary;
 @property (nonatomic,copy)NSString <Optional> *content;
 @property (nonatomic,copy)NSString <Optional> *sendObject;
 
 @property (nonatomic,copy)NSString <Optional> *state;
 @property (nonatomic,copy)NSString <Optional> *source;
 @property (nonatomic,copy)NSString <Optional> *createBy;
 @property (nonatomic,copy)NSString <Optional> *createTime;
 
 @end
 //请求
 @interface Model_message_messageDetail_Req : Model_Req
 @property (nonatomic,copy)NSString *messageMemberDetailId;
 @end
 //响应
 @interface  Model_message_messageDetail_Rsp : Model_Rsp
 @property (nonatomic,strong)Model_message_messageDetail_data *data;*/
@end
