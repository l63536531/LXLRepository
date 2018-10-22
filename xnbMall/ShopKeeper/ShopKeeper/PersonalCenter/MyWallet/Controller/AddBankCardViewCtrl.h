//
//  AddBankCardViewCtrl.h
//  ShopKeeper
//
//  Created by zhough on 16/5/31.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"

enum card_items{
    
    
    BANK_CARD = 0,//卡号
    BANK_NAME,//银行
    CARD_NAME,//开户名
    NAME_IDONE,//身份证
    NAME_IDTWO  

};


@interface AddBankCardViewCtrl : MABaseViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{


    UITableView * mianTableView;
    
    UITextField *bankcardtext;
    UITextField * banktext;
    UITextField * nametext;
    UITextField * Idcardone;
    UITextField * Idcardtwo;
    
    

}

@property(nonatomic ,strong) NSString * getid;


@end
