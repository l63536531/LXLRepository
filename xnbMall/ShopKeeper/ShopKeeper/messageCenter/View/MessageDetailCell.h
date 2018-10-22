//
//  MessageDetailCell.h
//  ShopKeeper
//
//  Created by frechai on 16/11/23.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailCell : UITableViewCell
-(void)fillCellWithMessageDetailModel:(Model_message_messageDetail_data*)model;
+(CGFloat)getHeightCellWithMessageDetailModel:(Model_message_messageDetail_data*)model;
@end
