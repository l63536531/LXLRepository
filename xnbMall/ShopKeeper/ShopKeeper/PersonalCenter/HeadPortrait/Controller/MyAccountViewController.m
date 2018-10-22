//
//  MyAccountViewController.m
//  Roam
//
//  Created by zhough on 16/1/12.
//  Copyright © 2016年 cmcc. All rights reserved.
//

#import "MyAccountViewController.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "AppDelegate.h"
#import "BlocksKit.h"
#import "BlocksKit+UIKit.h"

#import "AFHTTPSessionManager+Util.h"
#import "NSString+Utils.h"
#import "Utils.h"

#import "NicknameChangeCtrl.h"//昵称

#import "TransDataProxyCenter.h"
#import "LocationView.h"//定位





#define ORIGINAL_MAX_WIDTH 128.0f
#define LEFT_WIDTH 10
#define CELL_LEFT 25
@interface MyAccountViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate,VPImageCropperDelegate,UIAlertViewDelegate,UIApplicationDelegate>
{
    LocationView * lacationVC;
    
    //SKLocationViewController *_locationVC; //弹出的定位/地区选择控制器
    
}
@property (nonatomic, strong) UIImageView *portraitImageView;


@end

@implementation MyAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    _gender = @"";
    _nickname = @"昵称";
    _region = @"";
    
    return self;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"个人信息"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"　"
                                                                             style:(UIBarButtonItemStylePlain)
                                                                            target:nil
                                                                            action:nil];
    
    CGRect rect = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT);
    
    myTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    myTableView.scrollEnabled = YES;
    myTableView.bounces = NO;
    myTableView.delegate = (id<UITableViewDelegate>)self;
    myTableView.dataSource = (id<UITableViewDataSource>)self;
    [myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    myTableView.allowsSelection = YES;
    myTableView.showsVerticalScrollIndicator = NO;
    [myTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:myTableView];
    
    
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(getLocationData) name:@"determineLocation" object:nil];
    
    
}


// 8.6.0 设置用户的居住地区 user/setregion.do
-(void)getLocationData{
    
    
    NSString * getaere = nil;
    NSString* _proNameStr = lacationVC.proNameStr;
    NSString* _cityNameStr = lacationVC.cityNameStr;
    NSString* _areaNameStr= lacationVC.areaNameStr;
    NSString* _streetNameStr = lacationVC.streetNameStr;
    
    NSString *  _proIdStr = lacationVC.proIdStr;
    NSString *  _cityIdStr = lacationVC.cityIdStr;
    NSString * _areaIdStr = lacationVC.areaIdStr;
    NSString * _streetIdStr = lacationVC.streetIdStr;
    
    
    
    NSString * getlastid = nil;
    
    if (_proIdStr != nil&&_proIdStr.length>0) {
        getlastid = _proIdStr;
        getaere = _proNameStr;
        if (_cityIdStr != nil&&_cityIdStr.length>0) {
            getlastid = _cityIdStr;
            
            getaere = [NSString stringWithFormat:@"%@_%@",_proNameStr,_cityNameStr];
            if (_areaIdStr != nil&&_areaIdStr.length>0) {
                getaere = [NSString stringWithFormat:@"%@_%@_%@",_proNameStr,_cityNameStr,_areaNameStr];
                
                getlastid = _areaIdStr;
                
                if (_streetIdStr != nil&&_streetIdStr.length>0) {
                    getaere = [NSString stringWithFormat:@"%@_%@_%@_%@",_proNameStr,_cityNameStr,_areaNameStr,_streetNameStr];
                    
                    getlastid = _streetIdStr;
                }
            }
        }
    }else{
        
        getlastid = @"";
    }
    
    [self showWaitingView:self.view];
    [[NetWorkManager shareManager]netWWorkWithReqUrl:@"user/setregion.do" ReqParam:@{@"areaId":getlastid} BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
        [self hideWaitingView];
        if(fail_success){ //网络成功
            if ([dicStr[@"code"] intValue] == 200) {
                
                [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:ARWANAME object:getaere];
              //  [self showAutoDissmissHud:@"设置成功"];
                [myTableView reloadData];
                
            }else {
                
             //   [self showAutoDissmissHud:dicStr[@"msg"]];
            }
            
        }else{
           // [self showAutoDissmissHud:@"设置失败!"];
        }
    }];
    [myTableView reloadData];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [myTableView reloadData];
    
    
}


-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
    
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    } return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}



- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(indexPath.section == 0&&indexPath.row == 0){//头像
        
        static NSString *CellIdentifier1 = @"CellIdentifier2";
        UITableViewCell *cell = [myTableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            [cell.contentView addSubview:[self tableheaderview]];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
    }
    else if(indexPath.section == 1){//设置密码
        
        static NSString *CellIdentifier1 = @"CellIdentifier7";
        UITableViewCell *cell = [myTableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        }
        
        NSArray* celltilte = @[@"昵称",@"性别",@"地区"];
        
        NSString * username = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:NETWORKNAME];
        NSString * usergender = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:GENDER];
        NSString * usereare = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:ARWANAME];
        
        if (username==nil||!(username.length>0)) {
            username = @"";
        }
        if (usergender==nil||!(usergender.length>0)) {
            usergender = @"男";
        }
        if (usereare==nil||!(usereare.length>0)) {
            usereare = @"未设置";
        }
        NSArray* deatialtext = @[[NSString stringWithFormat:@"%@",username],[NSString stringWithFormat:@"%@",usergender],[NSString stringWithFormat:@"%@",usereare]];
        
        [cell.contentView addSubview:[self viewcell:[celltilte objectAtIndex:indexPath.row] deatial:[deatialtext objectAtIndex:indexPath.row]]];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
        
        
    }
    
    
    else return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0://昵称
            {
                NicknameChangeCtrl *nickvc = [[NicknameChangeCtrl alloc] init];
                nickvc.nickname = _nickname;
                [self.navigationController pushViewController:nickvc animated:YES];
            }
                break;
            case 1://性别
                
            {
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil                                                                            message:nil  preferredStyle:UIAlertControllerStyleActionSheet];
                //添加Button
                
                [alertController addAction: [UIAlertAction actionWithTitle: @"男" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self changeGender:@"男"];
                }]];
                
                [alertController addAction: [UIAlertAction actionWithTitle: @"女" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self changeGender:@"女"];
                }]];
                [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
                
                [self presentViewController: alertController animated: YES completion: nil];
            }
                break;
            case 2://地区
                
            {
                lacationVC = [[LocationView alloc] init];
                
                lacationVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                lacationVC.preferredContentSize = CGSizeMake(300, 300);
                lacationVC.popoverPresentationController.sourceView = self.navigationItem.titleView;//self.button;
                lacationVC.popoverPresentationController.sourceRect = self.navigationItem.titleView.bounds;
                
                UIPopoverPresentationController *pop = lacationVC.popoverPresentationController;
                pop.delegate = self;
                pop.permittedArrowDirections = UIPopoverArrowDirectionAny;
                
                [self presentViewController:lacationVC animated:YES completion:nil];
                
                
            }
                
                break;
            default:
                break;
        }
        
    }else if (indexPath.section == 0){
        
        [self editPortrait];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



#pragma  - mark 设置性别

-(void)changeGender:(NSString*)gender{
    
    __block NSString * getgender = gender;
    [self showWaitingView:self.view];
    [[NetWorkManager shareManager]netWWorkWithReqUrl:@"user/setgender.do" ReqParam:@{@"gender":getgender} BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
        [self hideWaitingView];
        if(fail_success){ //网络成功
            
            
            if ([dicStr[@"code"] intValue] == 200) {
                
                [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:GENDER object:getgender];
              //  [self showAutoDissmissHud:@"设置成功"];
                [myTableView reloadData];
                
            }else {
                
               // [self showAutoDissmissHud:dicStr[@"msg"]];
            }
            
        }else{
           // [self showAutoDissmissHud:@"设置失败!"];
        }
    }];
    [myTableView reloadData];
    
}





#pragma mark  头像
-(UIView*)tableheaderview{
    CGFloat headh = 50 ;
    
    headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headh)];
    [headerview setBackgroundColor:[UIColor clearColor]];
    
    
    //       用户名
    label = [[UILabel alloc]initWithFrame:CGRectMake(12, 16, SCREEN_WIDTH/2,  17)];
    [label setTextColor:[UIColor grayColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    label.text = @"头像";
    [label setTextAlignment:NSTextAlignmentLeft];
    label.font = [UIFont fontWithName:@"FZLTZHK--GBK1-0" size:16];
    [headerview addSubview:label];
    
    //    头像
    
    NSString * userurl = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGOURL];
    if (userurl == nil) {
        userurl = @"123";
    }
    NSURL* url = [[NSURL alloc]initWithString:userurl];
    [self.portraitImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"commonPlaceHolderIcon"]];
    [headerview addSubview:self.portraitImageView];//图片显示
    
    UIView* Line = [[UIView alloc]initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH , 1)];
    [Line setBackgroundColor:ColorFromRGB(230, 230, 230)];
    [headerview addSubview:Line];
    
    return headerview;
    
    
}

#pragma mark - phoneviewcell
-(UIView*)viewcell:(NSString*)lbatitle deatial:(NSString*)deatial{
    UIView* cell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 50)];
    [cell setBackgroundColor:[UIColor whiteColor]];
    UILabel *titleOne = [[UILabel alloc] init];
    titleOne.text = lbatitle;
    titleOne.textAlignment = NSTextAlignmentLeft;
    titleOne.textColor = [UIColor grayColor];
    titleOne.font = [UIFont systemFontOfSize:16];
    titleOne.frame = CGRectMake(12, 0, 120, 49);
    [cell addSubview:titleOne];
    
    titlephone = [[UILabel alloc] init];
    titlephone.text = deatial;
    titlephone.textAlignment = NSTextAlignmentRight;
    titlephone.textColor = [UIColor grayColor];
    titlephone.font = [UIFont systemFontOfSize:15];
    titlephone.numberOfLines = 1;
    titlephone.frame = CGRectMake(SCREEN_WIDTH/3 - 47, 0, SCREEN_WIDTH*2/3, 49);
    [cell addSubview:titlephone];
    
    
    UIView* Line = [[UIView alloc]initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH , 1)];
    [Line setBackgroundColor:ColorFromRGB(230, 230, 230)];
    [cell addSubview:Line];
    return cell;
}



#pragma mark -- 图片更换加入程序（以下都是）


- (void)editPortrait {
    
    
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles: @"拍照",@"从相册选择" ,nil];
    [choiceSheet showInView:self.view];
    
    
    
}


#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"数据上传中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTManager];
    NSString *surl = [NSString stringWithFormat:@"%@/file/appUpload.do",SERVER_ADDR];
    NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSInteger randnum = [Utils getRandomNumber:0 to:9999];
    NSString *fileName = @"";
    if (UIImagePNGRepresentation(editedImage)==nil){
        fileName = [NSString stringWithFormat:@"file%@%04li.jpg",[formatter stringFromDate:[NSDate date]], randnum];
    }else{
        fileName = [NSString stringWithFormat:@"file%@%04li.png",[formatter stringFromDate:[NSDate date]], randnum];
    }
    
    [manager.requestSerializer setValue:fileName forHTTPHeaderField:@"x_file_name"];
    
    [manager POST:surl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData * imageData = nil;
        
        if (UIImagePNGRepresentation(editedImage)==nil) {
            //            imageData = UIImageJPEGRepresentation(img, 1.0);
            imageData = [MyUtile imageData:editedImage];
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        }else{
            //            imageData = UIImagePNGRepresentation(img);
            imageData = [MyUtile imageData:editedImage];
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
            
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        NSLog(@"retdata:%@",retdata);
        
        if(code == 200){
            
            NSString* fileid = retdata[@"data"][@"fileId"];
            
            [[NetWorkManager shareManager]netWWorkWithReqUrl:@"user/setphoto.do" ReqParam:@{@"logoId":fileid} BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
                [SVProgressHUD dismiss];
                if(fail_success){ //网络成功
                    
                    if ([dicStr[@"code"] intValue] == 200) {
                        
                        self.portraitImageView.image = [self cutimage:editedImage];
                        //获取最新修改的用户信息
                        [[NetWorkManager shareManager]netWWorkWithReqUrl:@"user/info.do" ReqParam:nil BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
                            NSDictionary *dic = dicStr[@"data"];
                            if ([dicStr[@"code"] intValue] == 200) {
                                //保存到偏好设置
                                [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:LOGOURL object: dic[@"logoUrl"]];
                                
                            }
                            
                        }];
                        
                    }else {
                        
                      //  [self showAutoDissmissHud:dicStr[@"msg"]];
                    }
                    
                }else{
                    //[self showAutoDissmissHud:@"设置失败!"];
                }
            }];
            
        }else{
            [SVProgressHUD showErrorWithStatus:retdata[@"msg"]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
    }];
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
        // TO DO
    }];
}

#pragma mark 图片上传
-(void)ImageUpload:(UIImage*)img{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"数据上传中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTManager];
    NSString *surl = [NSString stringWithFormat:@"%@/file/appUpload.do",SERVER_ADDR];
    NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSInteger randnum = [Utils getRandomNumber:0 to:9999];
    NSString *fileName = @"";
    if (UIImagePNGRepresentation(img)==nil){
        fileName = [NSString stringWithFormat:@"file%@%04li.jpg",[formatter stringFromDate:[NSDate date]], randnum];
    }else{
        fileName = [NSString stringWithFormat:@"file%@%04li.png",[formatter stringFromDate:[NSDate date]], randnum];
    }
    
    [manager.requestSerializer setValue:fileName forHTTPHeaderField:@"x_file_name"];
    
    [manager POST:surl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData * imageData = nil;
        
        if (UIImagePNGRepresentation(img)==nil) {
            //            imageData = UIImageJPEGRepresentation(img, 1.0);
            imageData = [MyUtile imageData:img];
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        }else{
            //            imageData = UIImagePNGRepresentation(img);
            imageData = [MyUtile imageData:img];
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
            
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        NSLog(@"retdata:%@",retdata);
        if(code == 200){
            [SVProgressHUD dismiss];
            
            
        }else{
            [SVProgressHUD showErrorWithStatus:retdata[@"msg"]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {//取消
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
        //判断相机是否能够使用
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if (status ==AVAuthorizationStatusRestricted || status ==AVAuthorizationStatusDenied) //用户关闭了权限
        {
            
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"提示"                                                                             message:@"需要获得访问“相机”或“照片”的权限。"  preferredStyle:UIAlertControllerStyleAlert];
            //添加Button
            
            [alertController addAction: [UIAlertAction actionWithTitle: @"马上设置" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];//跳到系统设置页面
                
                //处理点击拍照
            }]];
            [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
            
            
            [self presentViewController: alertController animated: YES completion: nil];
            
            
            
            return ;
            
        }
        else if (status ==AVAuthorizationStatusNotDetermined) //第一次使用，则会弹出是否打开权限
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted)
                {
                    [self useTheCamera];
                    
                }
            }];
        }
        else if (status ==AVAuthorizationStatusAuthorized)
        {
            [self useTheCamera];
        }
        
        
        
        
        
        
    } else
        if (buttonIndex == 1) {
            
            //            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            //            if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
            ////                无权限
            //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
            //                                                                message:@"无忧行需要获得访问“相机”或“照片”的权限。"
            //                                                               delegate:self
            //                                                      cancelButtonTitle:@"知道了"
            //                                                      otherButtonTitles:@"马上设置",nil];
            //                alert.tag = 202;
            //
            //                [alert show];
            //                return;
            //
            //            }else{
            // 从相册中选取
            [self useTheImage];
            
            //            }
            
            
        }
    
    
}
#pragma mark --使用相机

-(void)useTheCamera{
    
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([self isFrontCameraAvailable]) {
            controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        
        controller.delegate = self;
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [appDelegate.window.rootViewController presentViewController:controller
                                                            animated:YES
                                                          completion:^(void){
                                                              NSLog(@"Picker View Controller is presented");
                                                          }];
    }
    
}

#pragma mark --使用相册

-(void)useTheImage{
    if ([self isPhotoLibraryAvailable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.window.rootViewController presentViewController:controller
                                                            animated:YES
                                                          completion:^(void){
                                                              NSLog(@"Picker View Controller is presented");
                                                              
                                                          }];
    }
    
}

#pragma mark - UIImagePickerControllerDelegate
//成功获得相片还是视频后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        
        
        //2015.4.1拍照转向问题解决
        NSString* mediaType=[info objectForKey:UIImagePickerControllerMediaType];
        if([mediaType isEqualToString:(NSString*)kUTTypeImage])//@"public.image"
        {
            
            UIImageOrientation imageOrientation=portraitImg.imageOrientation;
            if(imageOrientation!=UIImageOrientationUp)
            {
                // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
                // 以下为调整图片角度的部分
                UIGraphicsBeginImageContext(portraitImg.size);
                [portraitImg drawInRect:CGRectMake(0, 0, portraitImg.size.width, portraitImg.size.height)];
                portraitImg = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                // 调整图片角度完毕
            }
        }
        
        
        // 裁剪
        AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, appDelegate.window.frame.size.width, appDelegate.window.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        
        
        
        
        
        
        [appDelegate.window.rootViewController presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}
//取消照相机的回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
//设备是否支持前置摄像头闪光灯／后置摄像头闪光灯
// 后面的摄像头是否可用
- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}
// 前面的摄像头是否可用
- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}
// 检查摄像头是否支持拍照
- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}
// 相册是否可用
- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
// 是否可以在相册中选择视频
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
// 是否可以在相册中选择视频
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
// 判断是否支持某种多媒体类型：拍照，视频
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    
    
    
    return sourceImage;
}

-(UIImage*)cutimage:(UIImage*)getimage{
    CGSize targetSize;
    targetSize.width = 160;
    targetSize.height = 160;
    UIImage *newImage = nil;
    CGSize imageSize = getimage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [getimage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark portraitImageView getter
- (UIImageView *)portraitImageView {//图片大小位置设置
    if (!_portraitImageView) {
        
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 2,46, 46)];
        [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
        [_portraitImageView.layer setMasksToBounds:YES];
        [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_portraitImageView setClipsToBounds:YES];
        //        _portraitImageView.layer.shadowColor = [UIColor clearColor].CGColor;
        //        _portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
        //        _portraitImageView.layer.shadowOpacity = 0.5;
        //        _portraitImageView.layer.shadowRadius = 2.0;
        //        _portraitImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        //        _portraitImageView.layer.borderWidth = 2.5f;
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_portraitImageView addGestureRecognizer:portraitTap];
        
    }
    
    
    return _portraitImageView;
    
}

#pragma MBProgressHUDDelegate
-(void)HUDaddviewtitle:(NSString*)HUDstring{
    if (HUD) {
        [HUD removeFromSuperview];
        HUD = nil;
        
    }
    NSString *tet = HUDstring;
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = tet;
    HUD.labelFont = [UIFont systemFontOfSize:15];
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:3];
    
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"determineLocation" object:nil];
    
}

@end
