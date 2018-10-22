//
//  ChangeAddressViewCtr.h
//  ShopKeeper
//
//  Created by zhough on 16/6/1.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"


@protocol SkGetDefultAddressDelegate <NSObject>
- (void)GetNewDefultAddress;
@end


@interface ChangeAddressViewCtr : MABaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,UIPopoverPresentationControllerDelegate,UIAlertViewDelegate>{
    
    
    
    UITableView * mianTableView;
    
    
    
    
    
   
    
    UITextView *textFieldeditor;
    NSMutableArray * geteareArray;
    
    NSInteger getstrNumber;//
    
}

@property (nonatomic,strong) UITextField * phonetext;
@property (nonatomic,strong) UITextField * nametext;
@property (nonatomic,strong) UITextView * Idcardone;
@property (nonatomic,strong)  UITextField * eareText;




@property (nonatomic,strong) NSDictionary * getAreaDic;




@property (nonatomic, strong) NSArray * eareArray;


@property (nonatomic, strong) NSString * getphonestring;
@property (nonatomic,strong)  NSString * getnamestring;
@property (nonatomic, strong) NSString * getareaId;
@property (nonatomic,strong)  NSString * ridstring;
@property (nonatomic,strong)  NSString * isDefault;

//导航栏外部设置
@property (nonatomic, copy)NSString *borneTitle;

@property (nonatomic,strong)  NSString * detailearestring;





//rid:"唯一id 更新的时候需要提供"，
//    contactName："联系人姓名"，
//    contactPhone"："联系人电话"，
//    areaId ："选择的地区id"
//    address ："详细地址"
//    isDefault ："是否设置为默认 （0，否，1是"）


@property (nonatomic,weak) id<SkGetDefultAddressDelegate> delegate;

@end
