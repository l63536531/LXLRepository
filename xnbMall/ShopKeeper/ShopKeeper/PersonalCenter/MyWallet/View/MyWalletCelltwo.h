//
//  MyWalletCelltwo.h
//  ShopKeeper
//
//  Created by zhough on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyWalletCelltwodelegate;

@interface MyWalletCelltwo : UITableViewCell

@property (nonatomic ,copy)NSString* titlestring;

@property (nonatomic,weak) id<MyWalletCelltwodelegate> delegate;

-(void)update:(NSString*)titlestring;
@end


@protocol MyWalletCelltwodelegate <NSObject>

-(void)wallettwoclick;

@end