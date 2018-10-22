//
//  ShareWithFriendsViewCtr.h
//  ShopKeeper
//
//  Created by zhough on 16/7/27.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"



#define APP_KEY_QQ    @"1103606024"
#define SHARE_IMG_COMPRESSION_QUALITY 0.5

//  分享到QQ的类型
typedef NS_ENUM(NSInteger, SHARE_QQ_TYPE){
    
    //  QQ会话
    SHARE_QQ_TYPE_SESSION,
    
    //  QQ空间
    SHARE_QQ_TYPE_QZONE
    
};
@interface ShareWithFriendsViewCtr : MABaseViewController<UIAlertViewDelegate>{

    UIImage *thumbImage;
}

@property (nonatomic,strong) NSString * gettitle;
@property (nonatomic,strong) NSString * geturl;
@property (nonatomic,strong) NSString * getimage;
@property (nonatomic,strong) NSString * getdescription;



@end
