//
//  SelectTextview.h
//  ShopKeeper
//
//  Created by zhough on 16/6/15.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTextview : UIView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    UITableView *tv;//下拉列表
    NSArray *tableArray;//下拉列表数据
    UITextField *textField;//文本输入框
    // BOOL showList;//是否弹出下拉列表
    CGFloat tabheight;//table下拉列表的高度
    CGFloat frameHeight;//frame的高度
    
    
}

@property (nonatomic,retain) UITableView *tv;
@property (nonatomic,retain) NSArray *tableArray;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,assign) BOOL showList;
@property (nonatomic,strong) UIButton * selectbtn;


@end
