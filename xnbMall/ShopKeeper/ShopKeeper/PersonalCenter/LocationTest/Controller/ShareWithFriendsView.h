//
//  ShareWithFriendsView.h
//  ShopKeeper
//
//  Created by zhough on 16/6/8.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShareWithFriendsDelegate;

@interface ShareWithFriendsView : UIView

-(void)createview;

@property (nonatomic,weak) id<ShareWithFriendsDelegate> delegate;

@end


@protocol ShareWithFriendsDelegate <NSObject>

-(void)shareclickButton:(NSInteger)tag;


@end