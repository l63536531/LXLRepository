//
//  VideoTeachingViewCtrl.h
//  ShopKeeper
//
//  Created by zhough on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface VideoTeachingViewCtrl : MABaseViewController<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView * mianTableView;
    
    NSArray * getVideolist;
    NSString * getimageUrl;
    
}



@end
