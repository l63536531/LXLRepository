//
//  SearchViewCtr.h
//  ShopKeeper
//
//  Created by zhough on 16/6/15.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface SearchViewCtr : MABaseViewController<UISearchBarDelegate,UITextFieldDelegate>

@property (nonatomic,strong) NSString *state;

@end
