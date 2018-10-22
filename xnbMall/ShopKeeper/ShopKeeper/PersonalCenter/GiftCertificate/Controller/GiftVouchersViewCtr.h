//
//  GiftVouchersViewCtr.h
//  ShopKeeper
//
//  Created by zhough on 16/6/1.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface GiftVouchersViewCtr : MABaseViewController<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView * mianTableView;
    UIView * bgview;
    
    CGFloat totalAmount;//礼券总额
}
@end
