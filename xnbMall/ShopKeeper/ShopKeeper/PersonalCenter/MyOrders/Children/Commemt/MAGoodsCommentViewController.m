/**
 * MAGoodsCommentViewController.m 16/11/26
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MAGoodsCommentViewController.h"

#import "MAGoodsCommentCell.h"

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "VPImageCropperViewController.h"

@interface MAGoodsCommentViewController ()<UITableViewDataSource, UITableViewDelegate, MAGoodsCommentCellDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, VPImageCropperDelegate> {
    
    JKTableView *_tableView;
    JKView *_bottomView;
    JKButton *_commitBtn;
    
    NSArray *_mCommentArray;
    
    NSMutableArray *_mUserLocalCommentsArray;   //用户编辑的数据
    NSInteger _oprationRow;
    
    CGFloat _tvBottom;
}

@end

@implementation MAGoodsCommentViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"订单匿名评价"];
    //初始化数据
    [self initData];
    //创建UI界面
    [self createUI];
    
    [self requestOrderGoodsComments];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  @author 黎国基, 16/11/26
 *
 *  初始化数据
 */
- (void)initData {
    _mUserLocalCommentsArray = [[NSMutableArray alloc] init];
    
    
}

/**
 *  @author 黎国基, 16/11/26
 *
 *  创建UI界面
 */
- (void)createUI {
    
    [self createBottomView];//如果有 未评价的商品，则显示提交按钮
    
    CGFloat tableViewH = SCREEN_HEIGHT - 64.f;
    
    _tableView =  [[JKTableView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, tableViewH) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = RGBGRAY(245.f);
}

- (void)createBottomView {
    
    _bottomView = [[JKView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 500.f)];
    _bottomView.backgroundColor = RGBGRAY(245.f);
    
    _commitBtn = [JKButton buttonWithType:UIButtonTypeCustom];
    [_commitBtn setFrame:CGRectMake(0.f, 30.f, 200.f, 35.f)];
    _commitBtn.centerX = SCREEN_WIDTH / 2.f;
    [_commitBtn addTarget:self action:@selector(commitBtn) forControlEvents:UIControlEventTouchUpInside];
    _commitBtn.backgroundColor = THEMECOLOR;
    _commitBtn.layer.cornerRadius = 4.f;
    _commitBtn.clipsToBounds = YES;
    [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_bottomView addSubview:_commitBtn];
    _commitBtn.hidden = YES;
}

#pragma mark - Touch events

- (void)commitBtn {
    
    NSMutableArray *mLocalCommentDataArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _mCommentArray.count; i++) {
        
        NSDictionary *commentDic=  _mCommentArray[i];//第i个商品的评价
        
        NSDictionary *goodsDic= commentDic[@"orderGoodsVO"];
        NSDictionary *commentInfoDic= commentDic[@"goodsCommentVO"];
        
        if ([MAGoodsCommentCell isAlreadyCommented:commentInfoDic]) {
            //已评价的，不用管
        }else {
            //未评价
            NSDictionary *userEdittingDataDic = _mUserLocalCommentsArray[i];
            NSInteger starCount = [userEdittingDataDic[@"starnum"] integerValue];
            if (starCount > 0) {
                //pop out，需要提交的数据
                NSMutableDictionary *mCellCommentDic = [[NSMutableDictionary alloc] init];
                
                //必填信息********************
                //星级
                [mCellCommentDic setObject:[NSString stringWithFormat:@"%zd",starCount] forKey:@"starnum"];
                //
                [mCellCommentDic setObject:_orderId forKey:@"orderId"];
                //
                [mCellCommentDic setObject:goodsDic[@"goodsId"] forKey:@"goodsId"];
                //
                [mCellCommentDic setObject:goodsDic[@"goodsSpecificationId"] forKey:@"goodsSpecId"];
                //可选信息********************
                //mark
                NSString *marks = [self localMarksAtRow:i];
                [mCellCommentDic setObject:marks forKey:@"mark"];
                //content
                NSString *message = userEdittingDataDic[@"message"];
                if (message != nil && message.length > 0) {
                    [mCellCommentDic setObject:message forKey:@"content"];
                }
                //images
                NSDictionary *imagesDic = userEdittingDataDic[@"userImages"];
                NSArray *imageIds = [imagesDic allKeys];
                if (imageIds != nil && imageIds.count > 0) {
                    NSString *imageIdsStr = @"";
                    for (NSString *imageId in imageIds) {
                        imageIdsStr = [imageIdsStr stringByAppendingString:imageId];
                        imageIdsStr = [imageIdsStr stringByAppendingString:@","];
                    }
                    if (imageIdsStr.length > 0) {
                        imageIdsStr = [imageIdsStr substringToIndex:imageIdsStr.length - 1];
                        [mCellCommentDic setObject:imageIdsStr forKey:@"images"];
                    }
                }
                [mLocalCommentDataArray addObject:mCellCommentDic];
            }
        }
    }
    
    if (mLocalCommentDataArray.count > 0) {
        [self requestCommitGoodsComments:mLocalCommentDataArray];
    }else {
        [self showAutoDissmissHud:@"没有可提交的评价信息"];
    }
}

- (NSString *)localMarksAtRow:(NSInteger)row {
    /*注mark值表：
     {1，质量不错；2，价格优惠；3，物流快；4，服务态度不错；5，包装好；
     6，质量不好；7，价格不合理；8，物流太慢；9，服务态度不好；10，包装破损}*/
    
    NSDictionary *userEdittingDataDic = _mUserLocalCommentsArray[row];
    NSInteger starCount = [userEdittingDataDic[@"starnum"] integerValue];
    
    NSDictionary *userMarks = userEdittingDataDic[@"markIndexs"];
    NSArray *markKeys = [userMarks allKeys];//[0-4]
    
    NSString *resultMakrs = @"";
    
    for (NSString *key in markKeys) {
        NSNumber *number = userMarks[key];//key 是 【0-4】的值，是本地点击选中的标签btn的index
        
        NSInteger mark = 0;
        if (starCount < 3) {
            //差评
            mark = [key integerValue] + 6;//key 0 -- mark 6
        }else {
            //好评
            mark = [key integerValue] + 1;//key 0 -- mark 1
        }
        
        NSString *markStr = [NSString stringWithFormat:@"%zd",mark];
        if ([number integerValue] == 1) {
            resultMakrs = [resultMakrs stringByAppendingString:markStr];
            resultMakrs = [resultMakrs stringByAppendingString:@","];
        }
    }
    
    if (resultMakrs.length > 0) {
        resultMakrs = [resultMakrs substringToIndex:resultMakrs.length - 1];
    }
    return resultMakrs;
}

#pragma mark - Custom tasks

- (void)checkCommitBtnState {
    
    BOOL isAllGoodsCommented = YES;
    
    for (NSDictionary *commentDic in _mCommentArray) {
        
        NSDictionary *commentInfoDic= commentDic[@"goodsCommentVO"];
        
        if (![MAGoodsCommentCell isAlreadyCommented:commentInfoDic]) {
            //有一个未评价的商品
            isAllGoodsCommented = NO;
        }
    }
    _commitBtn.hidden = isAllGoodsCommented;
}

- (NSMutableDictionary *)createUserEdittingDataDic {
 
    NSMutableDictionary *userEdittingDataDic = [[NSMutableDictionary alloc] init];

    [userEdittingDataDic setObject:[NSNumber numberWithInteger:0] forKey:@"starnum"];//默认不展开，为0不展开isPopOut = NO
//    [userEdittingDataDic setObject:@"" forKey:@"message"];//留言,默认无留言
    NSMutableDictionary *markIndexs = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < 5; i++) {
        [markIndexs setObject:[NSNumber numberWithInteger:0] forKey:[NSString stringWithFormat:@"%zd",i]];
    }
    [userEdittingDataDic setObject:markIndexs forKey:@"markIndexs"];//默认不选择任何标签，【0-4】
    
    //图片dic格式  {imageId:image,..}
    NSMutableDictionary *userImagesDic = [[NSMutableDictionary alloc] init];
    [userEdittingDataDic setObject:userImagesDic forKey:@"userImages"];//默认无图片
    
    return userEdittingDataDic;
}

- (void)requestTakePhoto {
    
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
    }else if (status ==AVAuthorizationStatusNotDetermined) //第一次使用，则会弹出是否打开权限
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
}

#pragma mark --使用相机

-(void)useTheCamera{
    
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
    controller.mediaTypes = mediaTypes;
    
    controller.delegate = self;
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    
//    [appDelegate.window.rootViewController presentViewController:controller
//                                                        animated:YES
//                                                      completion:^(void){
//                                                          NSLog(@"Picker View Controller is presented");
//                                                      }];
    
    [self presentViewController:controller animated:YES completion:^{ }];
}

-(void)useTheImage{

    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
    controller.mediaTypes = mediaTypes;
    controller.delegate = self;
        
    [self presentViewController:controller animated:YES completion:^{ }];
        
//        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//        [appDelegate.window.rootViewController presentViewController:controller
//                                                            animated:YES
//                                                          completion:^(void){
//                                                              NSLog(@"Picker View Controller is presented");
//                                                              
//                                                          }];
}

#pragma mark - 照片回调

#pragma mark - UIImagePickerControllerDelegate
//成功获得相片还是视频后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [JKTool image:portraitImg byScalingToSize:CGSizeMake(300, 300)];//100 000
        
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
        
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, SCREEN_WIDTH, SCREEN_WIDTH) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
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

#pragma mark - VPImageCropperDelegate 

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    [self requestUploadImage:editedImage];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{ }];
}

#pragma mark - keyboard notification

- (void)keboardShow:(NSNotification *)notification{
    
    //键盘高度发生变化时也会被执行
    NSDictionary *userDic = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userDic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardH = keyboardF.size.height;
    
    CGFloat contentHeight = SCREEN_HEIGHT - 64.f;
    
    NSLog(@"tfBottom = %f,contentHeight = %f",_tvBottom,contentHeight);
    NSLog(@"keyboardF.h = %f",keyboardF.size.height);
    
    if (_tvBottom + keyboardH > contentHeight) {
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat indent = (_tvBottom + keyboardH - contentHeight);
            NSLog(@"indent = %f",indent);
            
            CGSize size = _tableView.contentSize;
            size.height = size.height + indent;
            [_tableView setContentSize:size];
            
            [_tableView setContentOffset:CGPointMake(0.f, indent) animated:YES];
        });
    }
}

- (void)keboardHide:(NSNotification *)notification{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_mCommentArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];//重新计算contentsize
    });
}

#pragma mark - MAGoodsCommentCellDelegate

- (void)starViewDidSetStarCount:(NSInteger)starCount atRow:(NSInteger)row {
    
    NSMutableDictionary *userEdittingDataDic = _mUserLocalCommentsArray[row];
    
    [userEdittingDataDic setObject:@(starCount) forKey:@"starnum"];//行高变了，展开。需要reload
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)starViewDidSetMark:(NSInteger)mark opration:(NSInteger)opration atRow:(NSInteger)row {
    
    NSMutableDictionary *userEdittingDataDic = _mUserLocalCommentsArray[row];
    
    NSMutableDictionary *markIndexs = userEdittingDataDic[@"markIndexs"];
    
    if (opration == 0) {
        //删除
        [markIndexs setObject:[NSNumber numberWithInteger:0] forKey:[NSString stringWithFormat:@"%zd",mark]];
    }else {
        //添加
        [markIndexs setObject:[NSNumber numberWithInteger:1] forKey:[NSString stringWithFormat:@"%zd",mark]];
    }
}

- (void)starViewDidSetMessage:(NSString *)message atRow:(NSInteger)row {
    
    NSMutableDictionary *userEdittingDataDic = _mUserLocalCommentsArray[row];
    if (message != nil) {
        
        [userEdittingDataDic setObject:message forKey:@"message"];
    }else {
        [userEdittingDataDic removeObjectForKey:@"message"];
    }
}

- (void)starViewRemoveMarkIndexsAtRow:(NSInteger)row{
    
    NSMutableDictionary *userEdittingDataDic = _mUserLocalCommentsArray[row];
    
    NSMutableDictionary *markIndexs = userEdittingDataDic[@"markIndexs"];
    
    for (int i = 0; i < 5; i++) {
        [markIndexs setObject:[NSNumber numberWithInteger:0] forKey:[NSString stringWithFormat:@"%zd",i]];
    }
}

- (void)addImageAtRow:(NSInteger)row {
    
    _oprationRow = row;
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil  preferredStyle:UIAlertControllerStyleActionSheet];
    //添加Button
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self requestTakePhoto];
    }]];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"从相册选择" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self useTheImage];
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated: YES completion: nil];
}

- (void)removeImageByImageId:(NSString *)imageId atRow:(NSInteger)row {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定删除图片？"  preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSMutableDictionary *userEdittingDataDic = _mUserLocalCommentsArray[row];
        NSMutableDictionary *userImagesDic = userEdittingDataDic[@"userImages"];
        
        [userImagesDic removeObjectForKey:imageId];
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    [self presentViewController: alertController animated: YES completion: nil];
}

- (void)activeTextViewBottomPoint:(CGPoint)origin forCell:(UITableViewCell *)cell {
    
    CGPoint point = [cell convertPoint:origin toView:_tableView];
    
    _tvBottom =  point.y + 5.f;
}

#pragma mark - 获取照片

#pragma mark - Http request

- (void)requestOrderGoodsComments {
    
    if (_orderId != nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [JKURLSession taskWithMethod:@"order/queryGoodsByOrder.do" parameter:@{@"orderId":_orderId} token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
            [hud hideAnimated:YES];
            if (error == nil) {
                
                _mCommentArray = resultDic[@"data"][@"goodsList"];
                [self checkCommitBtnState];
                
                [_mUserLocalCommentsArray removeAllObjects];
                
                for (int i = 0; i < _mCommentArray.count; i++) {
                    [_mUserLocalCommentsArray addObject:[self createUserEdittingDataDic]];
                }
                
                [_tableView reloadData];
            }else {
                [self showAutoDissmissHud:error.localizedDescription];
            }
        }];
    }
}

/**
 *  @author 黎国基, 16-11-26 22:11
 *
 *  提交评价
 */
- (void)requestCommitGoodsComments:(NSArray *)commentsArray {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [JKURLSession taskWithMethod:@"comment/appraise.do" parameter:@{@"comments":commentsArray} token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        [hud hideAnimated:YES];
        if (error == nil) {
            [self requestOrderGoodsComments];
            
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:@"评论成功！"  preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController: alertController animated: YES completion: nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderCommentStateChanged" object:nil];
        }else {
            [self showAutoDissmissHud:error.localizedDescription];
        }
    }];
}

#pragma mark 图片上传

-(void)requestUploadImage:(UIImage*)image{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTManager];
    NSString *surl = [NSString stringWithFormat:@"%@/file/appUpload.do",SERVER_ADDR];
    NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSInteger randnum = [Utils getRandomNumber:0 to:9999];
    NSString *fileName = @"";
    if (UIImagePNGRepresentation(image)==nil){
        fileName = [NSString stringWithFormat:@"file%@%04li.jpg",[formatter stringFromDate:[NSDate date]], randnum];
    }else{
        fileName = [NSString stringWithFormat:@"file%@%04li.png",[formatter stringFromDate:[NSDate date]], randnum];
    }
    [manager.requestSerializer setValue:fileName forHTTPHeaderField:@"x_file_name"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:surl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData * imageData = nil;
        
        if (UIImagePNGRepresentation(image)==nil) {
            //            imageData = UIImageJPEGRepresentation(img, 1.0);
            imageData = [MyUtile imageData:image];
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        }else{
            //            imageData = UIImagePNGRepresentation(img);
            imageData = [MyUtile imageData:image];
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
            
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        
        [hud hideAnimated:YES];
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            //上传成功
            NSString *fieldId = retdata[@"data"][@"fileId"];
            
            NSMutableDictionary *userEdittingDataDic = _mUserLocalCommentsArray[_oprationRow];
            NSMutableDictionary *userImagesDic = userEdittingDataDic[@"userImages"];
            [userImagesDic setObject:image forKey:fieldId];
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_oprationRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            [self showAutoDissmissHud:retdata[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [self showAutoDissmissHud:@"图片上传失败"];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mCommentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    
    MAGoodsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MAGoodsCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    
    NSDictionary *commentDic=  _mCommentArray[indexPath.row];
    
    NSDictionary *goodsDic= commentDic[@"orderGoodsVO"];
    NSDictionary *commentInfoDic= commentDic[@"goodsCommentVO"];
    
    cell.row = indexPath.row;
    cell.titleStr = goodsDic[@"title"];
    cell.imageUrlStr = goodsDic[@"logoId"];
    //
    BOOL isPopOut = YES;
    NSMutableDictionary *userEdittingDataDic = _mUserLocalCommentsArray[indexPath.row];
    if (![MAGoodsCommentCell isAlreadyCommented:commentInfoDic]) {
        //未评价
        isPopOut = [userEdittingDataDic[@"starnum"] integerValue] > 0;
    }
    
    [cell setCommentInfoDic:commentInfoDic isPopOut:isPopOut userLocalData:userEdittingDataDic];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *commentDic=  _mCommentArray[indexPath.row];
    
    NSDictionary *commentInfoDic= commentDic[@"goodsCommentVO"];
    
    BOOL isPopOut = YES;
    if (![MAGoodsCommentCell isAlreadyCommented:commentInfoDic]) {
        //未评价
        NSMutableDictionary *userEdittingDataDic = _mUserLocalCommentsArray[indexPath.row];
        isPopOut = [userEdittingDataDic[@"starnum"] integerValue] > 0;
    }
    
    CGFloat cellH = [MAGoodsCommentCell cellHeightForCommentInfoDic:commentInfoDic isPopOut:isPopOut];
    return cellH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 170.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return _bottomView;
}

@end
