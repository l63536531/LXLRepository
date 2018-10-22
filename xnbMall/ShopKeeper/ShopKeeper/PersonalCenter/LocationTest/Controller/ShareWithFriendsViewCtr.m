//
//  ShareWithFriendsViewCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/7/27.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "ShareWithFriendsViewCtr.h"
#import "WXApiRequestHandler.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "JKTool.h"

static NSString *kAPPContentTitle = @"App消息";
static NSString *kAPPContentDescription = @"这种消息只有App自己才能理解，由App指定打开方式";
static NSString *kAppContentExInfo = @"<xml>extend info</xml>";
static NSString *kAppContnetExURL = @"http://image.baidu.com/search/detail?ct=503316480&z=0&ipn=false&word=美女图片&hs=0&pn=0&spn=0&di=0&pi=20905485734&rn=1&tn=baiduimagedetail&is=0%2C172939&ie=utf-8&oe=utf-8&in=3354&cl=2&lm=-1&cs=&os=&simid=&adpicid=0&fr=ala&fm=&sme=&statnum=girl&cg=girl&bdtype=-1&oriquery=&objurl=http%3A%2F%2Fg.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F241f95cad1c8a7866f726fe06309c93d71cf5087.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3B4ztp7_z%26e3Bv54AzdH3Flc9c&gsm=";
static NSString *kAppMessageExt = @"这是第三方带的测试字段";
static NSString *kAppMessageAction = @"<action>dotaliTest</action>";


@interface ShareWithFriendsViewCtr ()<UIGestureRecognizerDelegate, TencentSessionDelegate>

@property(nonatomic,strong) UIImageView * imgView;

@end

@implementation ShareWithFriendsViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        UIImage *orgImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_getimage]]];
        
        thumbImage = [JKTool image:orgImage byScalingToSize:CGSizeMake(170 , 170)]; //分享缩略图大小不能超过32K
        
        dispatch_async(dispatch_get_main_queue(), ^{

            [self createview];
        });
    });
    
    
    UITapGestureRecognizer* singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClickEvent:)];
    singleFingerOne.numberOfTouchesRequired = 1;
    singleFingerOne.numberOfTapsRequired = 1;
    singleFingerOne.delegate = self;
    [self.view addGestureRecognizer:singleFingerOne];

}

-(void)viewClickEvent:(UITapGestureRecognizer*)tap{
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}


-(void)erweima

{
    
    //二维码滤镜
    
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //恢复滤镜的默认属性
    
    [filter setDefaults];
    
    //将字符串转换成NSData
    
    NSData *data=[_geturl dataUsingEncoding:NSUTF8StringEncoding];
    
    //通过KVO设置滤镜inputmessage数据
    
    [filter setValue:data forKey:@"inputMessage"];
    
    //获得滤镜输出的图像
    
    CIImage *outputImage=[filter outputImage];
    
    //将CIImage转换成UIImage,并放大显示
    
    _imgView.image=[self createNonInterpolatedUIImageFormCIImage:outputImage withSize:100.0];
    
    //如果还想加上阴影，就在ImageView的Layer上使用下面代码添加阴影
    
    _imgView.layer.shadowOffset=CGSizeMake(0, 0.5);//设置阴影的偏移量
    
    _imgView.layer.shadowRadius=1;//设置阴影的半径
    
    _imgView.layer.shadowColor=[UIColor blackColor].CGColor;//设置阴影的颜色为黑色
    
    _imgView.layer.shadowOpacity=0.3;
}


//改变二维码大小

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
    
}

-(void)createview{
    
    CGFloat  leftX = SCREEN_WIDTH/6;
    CGFloat  viewWidth = SCREEN_WIDTH - leftX*2;
    CGFloat  imageleft = 10;
    CGFloat  imageWidth = viewWidth - imageleft*2;
    CGFloat labheight = 25 ;
    
    CGFloat labY = imageleft + imageWidth;
    CGFloat lineY = labY+ labheight ;
    CGFloat bgheight = viewWidth/4*5+50;
    UIView * bgroundview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];

    bgroundview.layer.cornerRadius = 4;
    bgroundview.backgroundColor = RGBAGRAY(200, 0.5f);
    
    bgroundview.layer.masksToBounds = YES;
    [self.view addSubview:bgroundview];
    self.view.backgroundColor = [UIColor clearColor];
    
    UIView * bgview = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/6, (SCREEN_HEIGHT - bgheight)/2, SCREEN_WIDTH/6*4, bgheight+10)];//

    [bgview setBackgroundColor:[UIColor whiteColor]];
    [bgview.layer setBorderWidth:0.5];
    bgview.layer.cornerRadius = 5;
    
    bgview.layer.masksToBounds = YES;
    [bgview.layer setBorderColor:ColorFromRGB(240, 240, 240).CGColor];
    [self.view addSubview:bgview];
    
    self.imgView=[[UIImageView alloc]initWithFrame:CGRectMake(imageleft, imageleft,imageWidth, imageWidth)];
    
    [bgview addSubview:_imgView];
    
    UILongPressGestureRecognizer *longpressGesutre=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongpressGesture:)];
     //长按时间为1秒

    longpressGesutre.minimumPressDuration=1;

     //允许15秒中运动

   longpressGesutre.allowableMovement=2;

    //所需触摸1次

    longpressGesutre.numberOfTouchesRequired=1;
    longpressGesutre.delegate = self;
    [bgview addGestureRecognizer:longpressGesutre];
    
    [self erweima];

    UIImageView * imageview = [[UIImageView alloc] init];
    [imageview setFrame:CGRectMake(imageWidth/2 - 10, imageWidth/2-10,20, 20)];

    [imageview setImage:thumbImage];
    [imageview.layer setCornerRadius:3];
    [_imgView addSubview:imageview];
    
    UILabel * labtitle = [[UILabel alloc]init];
    [labtitle setFrame:CGRectMake(0, labY, viewWidth, labheight)];
    [labtitle setBackgroundColor: [UIColor clearColor]];
    [labtitle setText:_gettitle];
    [labtitle setTextColor:ColorFromHex(0x646464)];
    [labtitle setTextAlignment:NSTextAlignmentCenter];
    [labtitle setFont:[UIFont systemFontOfSize:14]];
    [bgview addSubview:labtitle];
    
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, lineY, viewWidth, 1)];
    [line setBackgroundColor:ColorFromRGB(230, 230, 230)];
    [bgview addSubview:line];
    
    
    UILabel * labshare = [[UILabel alloc]init];
    [labshare setFrame:CGRectMake(0, lineY, viewWidth, labheight)];
    [labshare setBackgroundColor: [UIColor clearColor]];
    [labshare setText:@"  分享到"];
    [labshare setTextColor:ColorFromHex(0x646464)];
    [labshare setTextAlignment:NSTextAlignmentLeft];
    [labshare setFont:[UIFont systemFontOfSize:14]];
    [bgview addSubview:labshare];
    
    
    CGFloat btnbgviewheight =  viewWidth/4;
    
    NSArray* titlearray = @[@"微信好友",@"朋友圈",@"QQ好友",@"QQ空间"];
    NSArray* imagArray =  @[@"wxshareicon",@"frshareicon",@"qqshareicon",@"QQ空间"];
    
    for (int i = 0; i< 4; i++) {
        
        UIView * btnbgview = [[UIView alloc] init];
        [btnbgview setBackgroundColor:[UIColor whiteColor]];
        [btnbgview setFrame:CGRectMake( btnbgviewheight*i, lineY+ labheight, btnbgviewheight, btnbgviewheight)];
        [bgview addSubview:btnbgview];
        
        
        UIButton* btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0,btnbgviewheight,  btnbgviewheight)];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setImage:[UIImage imageNamed:imagArray[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i];
        [btnbgview addSubview:btn];
        
        UILabel* labtitle = [[UILabel alloc] init];
        [labtitle setFrame:CGRectMake(0, btnbgviewheight-5, btnbgviewheight, 20)];
        [labtitle setText:titlearray[i]];
        [labtitle setTextAlignment:NSTextAlignmentCenter];
        [labtitle setFont:[UIFont systemFontOfSize:10]];
        [labtitle setAdjustsFontSizeToFitWidth:YES];
        [labtitle setTextColor:[UIColor lightGrayColor]];
        [labtitle setBackgroundColor:[UIColor clearColor]];
        [btnbgview addSubview:labtitle];
    }
}

-(void)btnclick:(id)sender{
    UIButton * btn = sender;
    NSInteger index = btn.tag;

    if (index == 0) {//微信好友
        [MobClick event:@"share_wxfriends" label:@"分享微信好友"];
        NSLog(@"/微信好友");
        [WXApiRequestHandler sendAppContentData:nil
                                        ExtInfo:kAppContentExInfo
                                         ExtURL:_geturl
                                          Title:_gettitle
                                    Description:_getdescription
                                     MessageExt:kAppMessageExt
                                  MessageAction:kAppMessageAction
                                     ThumbImage:thumbImage
                                        InScene:WXSceneSession];//朋友圈WXSceneTimeline//朋友WXSceneSession
        
    }else if (index ==1){//微信圈
        [MobClick event:@"share_wxtimeline" label:@"分享微信朋友圈"];
        [WXApiRequestHandler sendAppContentData:nil
                                        ExtInfo:kAppContentExInfo
                                         ExtURL:_geturl
                                          Title:_gettitle
                                    Description:_getdescription
                                     MessageExt:kAppMessageExt
                                  MessageAction:kAppMessageAction
                                     ThumbImage:thumbImage
                                        InScene:WXSceneTimeline];//朋友圈WXSceneTimeline//朋友WXSceneSession

    
    }else if (index ==2){
        [MobClick event:@"share_qqfriend" label:@"分享qq好友"];
        [self shareToQQBase:SHARE_QQ_TYPE_SESSION];
    }else if (index ==3){
        [MobClick event:@"share_qqzone" label:@"分享qq空间"];
        [self shareToQQBase:SHARE_QQ_TYPE_QZONE];
    }
      NSLog(@"%ld",btn.tag);
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)shareToQQBase:(SHARE_QQ_TYPE)type {
    
    TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:APP_KEY_QQ andDelegate:self];//不执行此句无法打开QQ
    tencentOAuth = nil;


    NSData *imageData = UIImageJPEGRepresentation(thumbImage, SHARE_IMG_COMPRESSION_QUALITY);
    
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:_geturl]//链接
                                title:_gettitle //标题
                                description:_getdescription   //描述
                                previewImageData:imageData]; //图片
    
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
//
    
    if (type == SHARE_QQ_TYPE_SESSION) {
        
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        NSLog(@"QQApiSendResultCode:%d", sent);
        
    }else{
        
        //将内容分享到qzone
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        NSLog(@"Qzone QQApiSendResultCode:%d", sent);
        
    }
}

#pragma mark - TencentSessionDelegate

- (void)tencentDidLogin {
    
    
    
}

-(void)handleLongpressGesture:(UILongPressGestureRecognizer*)tap{

    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"提示"                                                                             message:@"保存照片到相册中"  preferredStyle:UIAlertControllerStyleAlert];
    //添加Button
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];

    [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIGraphicsBeginImageContext(self.view.bounds.size);     //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
        UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
        UIImageWriteToSavedPhotosAlbum(viewImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        //处理点击拍照
    }]];
    
  
    [self presentViewController: alertController animated: YES completion: nil];
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil ];
        [alert show];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil ];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
