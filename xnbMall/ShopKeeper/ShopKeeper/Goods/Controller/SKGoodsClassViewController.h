//
//  SKGoodsClassViewController.h
//  ShopKeeper
//
//  Created by zzheron on 16/6/2.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface SKGoodsClassViewController : MABaseViewController<UITableViewDataSource,
    UITableViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UISearchBarDelegate>

@property(strong,nonatomic ) UITableView * leftTablew;
@property(strong,nonatomic ) UICollectionView * rightCollection;

@property (nonatomic,strong) UISearchBar *searchbar;

@end
