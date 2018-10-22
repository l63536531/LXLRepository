//
//  NewShelvesCtr.h
//  ShopKeeper
//
//  Created by zhough on 16/6/21.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

@interface NewShelvesCtr : MABaseViewController<UICollectionViewDataSource,UICollectionViewDelegate>{
    UIView * bgview;

    NSMutableArray *_cellArray;     //collectionView数据
    NSInteger page;
    
}

@property (nonatomic, strong) UICollectionView *collectionView;
@end
