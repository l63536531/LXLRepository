//
//  MembershipCardPrepaidCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/6/3.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MembershipCardPrepaidCtr.h"
#import "BlocksKit.h"
#import "BlocksKit+UIKit.h"
#import "AFHTTPSessionManager+Util.h"
#import "NSString+Utils.h"
#import "Utils.h"
#import "TransDataProxyCenter.h"


@interface MembershipCardPrepaidCtr ()
@property (nonatomic) UIView *bottomView;

@property (nonatomic) UIButton *btn_1;//提交

@property (nonatomic) UITextField *field_name;

@property (nonatomic) NSMutableArray *imglist;
@property (nonatomic) NSMutableArray *imgidlist;
@property (nonatomic) NSInteger ieditindex;
@end

@implementation MembershipCardPrepaidCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员卡充值";
    
    //self.navigationController.navigationBar.barTintColor = HEXCOLOR(0xEE2C2Cff);
    //self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    _imglist = [NSMutableArray new];
    _imgidlist = [NSMutableArray new];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    
    _lastResult = YES;
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    
    __weak UITableView *tableView = self.tableView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    
    
    UIBarButtonItem *rightbar=[[UIBarButtonItem alloc] initWithTitle:@"我的商品" style:UIBarButtonItemStylePlain target:self action:@selector(MyProduct)];
//    self.navigationItem.rightBarButtonItem=rightbar;
    
    
    
    _bottomView = [[UIView alloc] init];
    self.btn_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.btn_1 setTitle:@"提交" forState:UIControlStateNormal];
    self.btn_1.backgroundColor = HEXCOLOR(0xEE2C2Cff);
    self.btn_1.tag = 1;
    [self.btn_1.layer setCornerRadius:5];
    [self.btn_1 addTarget:self action:@selector(AddProductAction:) forControlEvents:UIControlEventTouchDown];
    
    [_bottomView addSubview:self.btn_1];
    
    [_bottomView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400)];
    _bottomView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = _bottomView;

    
    int padding1 = 10;
    [_btn_1 setFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 40)];
    
    
    
    self.field_name = [[UITextField alloc] init];
    self.field_name.placeholder = @"";
    
    [self.field_name sizeToFit];
    self.field_name.returnKeyType = UIReturnKeyDone;  //键盘返回类型
    self.field_name.clearButtonMode = UITextFieldViewModeNever; //编辑时会出现个修改X
    self.field_name.delegate = self;
    self.field_name.keyboardType = UIKeyboardTypeDefault;//键盘显示类型
    
    
    UILabel* labdetail = [[UILabel alloc] init];
    [labdetail setBackgroundColor:[UIColor whiteColor]];
    [labdetail setFrame:CGRectMake(0, 60, SCREEN_WIDTH, 300)];
    [labdetail setText:@"    收款账号一：\n\n    户名：深圳超群高科技有限公司\n\n    开户行：工商银行深圳喜年支行\n\n    账号：4000 0324 1920 0640 179\n\n\n    收款账号二：\n\n    户名：深圳超群高科技有限公司\n\n    开户行：农业银行深圳高新区支行\n\n    账号：4100 3800 0400 00036"];
    [labdetail setTextColor:[UIColor grayColor]];
    [labdetail setNumberOfLines:0];
    [labdetail setAdjustsFontSizeToFitWidth:YES];
    [labdetail setFont:[UIFont systemFontOfSize:14]];
    [labdetail setTextAlignment:NSTextAlignmentLeft];
    [_bottomView addSubview:labdetail];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
    //[self startReading];
    // Do any additional setup after loading the view.
    
}

-(void)MyProduct{


}

-(void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [self.view endEditing:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section==0)
        return 0.0001;
    else
        return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 4;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //计算每个cell的高度
    if(indexPath.section == 0 && indexPath.row == 2){
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }else if (indexPath.row == 0){
        
        return 60;
    }else if (indexPath.row == 1){
        
        return 30;
    }else
        
        
        return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ID = [NSString stringWithFormat:@"ProductCell_%ld_%ld",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row == 0){
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"* 转账金额"];
        [str addAttribute:NSForegroundColorAttributeName
                    value:[UIColor redColor]
                    range:NSMakeRange(0,1)];
        cell.textLabel.attributedText =str;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:self.field_name];

        [self.field_name setPlaceholder:@"需与转账凭证金额一致"];
        [self.field_name setFont:[UIFont systemFontOfSize:14]];
        [self.field_name setTextAlignment:NSTextAlignmentCenter];
        
        [self.field_name setFrame:CGRectMake(90, 0, SCREEN_WIDTH - 120, 60)];
        
        UILabel* lab = [[UILabel alloc] init];
        [lab setBackgroundColor:[UIColor clearColor]];
        [lab setFrame:CGRectMake(SCREEN_WIDTH - 30, 0, 15, 60)];
        [lab setText:@"元"];
        [lab setTextColor:[UIColor grayColor]];
        [lab setFont:[UIFont systemFontOfSize:13]];
        [lab setTextAlignment:NSTextAlignmentRight];
        [cell.contentView addSubview:lab];
        
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(15, 59, SCREEN_WIDTH, 1)];
        [line setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:line];

        
    }else if(indexPath.row == 1){
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"* 转账凭证"];
        [str addAttribute:NSForegroundColorAttributeName
                    value:[UIColor redColor]
                    range:NSMakeRange(0,1)];
        cell.textLabel.attributedText =str;
        cell.textLabel.font = [UIFont systemFontOfSize:12];

    }
    else if(indexPath.row == 2){
        UIView *iv = [self CreateImageAddView];
        [cell.contentView addSubview:iv];
        cell.selected = NO;
        cell.frame = iv.frame;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}





-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result;
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            result = metadataObj.stringValue;
        } else {
            //NSLog(@"不是二维码");
            result = metadataObj.stringValue;
        }
        
        [self performSelectorOnMainThread:@selector(reportScanResult:) withObject:result waitUntilDone:NO];
    }
}

- (void)reportScanResult:(NSString *)result
{
    if (!_lastResult) {
        return;
    }
    _lastResult = NO;
    
    
    [self.tableView reloadData];
    // 以下处理了结果，继续下次扫描
    _lastResult = YES;
}




//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint origin = textField.frame.origin;
    CGPoint point = [textField.superview convertPoint:origin toView:self.tableView];
    float navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGPoint offset = self.tableView.contentOffset;
    
    if(point.y > (self.view.frame.size.height-navBarHeight-256)){
        offset.y = (point.y - (self.view.frame.size.height-navBarHeight-256) + 22);
        [self.tableView setContentOffset:offset animated:YES];
        
    }
    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}








-(id)CreateImageAddView{
    
    float ivhight = (((int)_imglist.count/4)+1) *(SCREEN_WIDTH/4);
    float ivsize = (SCREEN_WIDTH/4) - 20;
    float ivedge = 10;
    
    UIView *iv =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ivhight+20)];
    
    
    for(int i = 0; i < [_imglist count] + 1; i++)
    {
        if(i<[_imglist count]){
            UIImageView *av = [[UIImageView alloc] initWithImage:[_imglist objectAtIndex:i]];
            
            float ix = ivedge + (i%4)*(ivsize+20);
            float iy = ivedge + (i/4)*(ivsize+20);
            
            av.frame = CGRectMake(ix, iy, ivsize, ivsize);
            av.userInteractionEnabled = YES;
            av.tag = 100+i+1;
            [av addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPortrait:)]];
            [iv addSubview:av];
        }else{
            UIImageView *av = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shangchuan"]];
            
            float ix = ivedge + (i%4)*(ivsize+20);
            float iy = ivedge + (i/4)*(ivsize+20);
            
            av.frame = CGRectMake(ix, iy, ivsize, ivsize);
            av.userInteractionEnabled = YES;
            av.tag = 100;
            [av addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPortrait:)]];
            [iv addSubview:av];
            
            UILabel *label_1 = [[UILabel alloc] initWithFrame:CGRectMake(ix, iy+ivsize+2, ivsize, 15)];
            label_1.font = [UIFont systemFontOfSize:12];
            label_1.text = @"添加图片";
            label_1.textAlignment = NSTextAlignmentCenter;
            [iv addSubview:label_1];
        }
        
    }
    return iv;
}

-(void)tapPortrait:(id)sender{
    
    //NSLog(@"tapPortrait:%ld",[sender tag]);
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    NSInteger itag = [singleTap view].tag;
    NSLog(@"tapPortrait:%ld",itag);
    
    if(_imglist.count >= 3 && itag == 100){
        UIAlertView *alertView = [[UIAlertView alloc] bk_initWithTitle:@"提示" message:@"最大只允许上次3张图片！"];
        [alertView bk_setCancelButtonWithTitle:@"确定" handler:nil];
        //[alertView bk_addButtonWithTitle:@"确定" handler:nil];
        [alertView bk_setDidDismissBlock:^(UIAlertView *alert, NSInteger index) {
            
        }];
        [alertView show];
        return;
    }
    
    _ieditindex = itag - 100;
    if(_ieditindex == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择图片" message:nil delegate:self
                                                  cancelButtonTitle:@"取消" otherButtonTitles:@"摄像头", @"相册", nil];
        alertView.tag = 2;
        
        [alertView show];
        
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除图片" message:nil delegate:self
                                                  cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 3;
        
        [alertView show];
        
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger itag = [alertView tag];
    if (buttonIndex == alertView.cancelButtonIndex) {return;}
    
    if (buttonIndex == 1) {
        if(itag == 3){
            if(_imglist.count>0 && _ieditindex>0 && _imglist.count>=_ieditindex){
                [_imglist removeObjectAtIndex:(_ieditindex-1)];
                [_imgidlist removeObjectAtIndex:(_ieditindex-1)];
                [self.tableView reloadData];
            }
            _ieditindex = 0;
        }else{
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Device has no camera"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
                
                [alertView show];
            } else {
                UIImagePickerController *imagePickerController = [UIImagePickerController new];
                imagePickerController.delegate = self;
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.allowsEditing = YES;
                imagePickerController.showsCameraControls = YES;
                imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
                
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
            
        }
        
    } else if(buttonIndex == 2){
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing = YES;
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }else{
        
    }
}

#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //NSLog(@"imagePickerController");
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^ {
        //[self updatePortrait];
        if(_imglist.count>0 && _ieditindex>0 && _imglist.count>=_ieditindex){
            [_imglist replaceObjectAtIndex:_ieditindex-1 withObject:image];
            [_imgidlist replaceObjectAtIndex:_ieditindex-1 withObject:image];
            [self.tableView reloadData];
        }else{
            [self ImageUpload:image];
        }
        _ieditindex = 0;
        
    }];
}


//用户取消拍照
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //NSLog(@"imagePickerControllerDidCancel");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

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
            [_imgidlist addObject:retdata[@"data"][@"fileId"]];
            [_imglist addObject:img];
            [self.tableView reloadData];
            
        }else{
            [SVProgressHUD showErrorWithStatus:retdata[@"msg"]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
    }];
}



-(void)AddProductAction : (id) sender{
    
    NSInteger itag = [sender tag];
    //do something
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"数据上传中..."];
  
    NSString * money = _field_name.text;
    
    if (money.length>0) {
        if (_imgidlist.count>0) {
            
            NSString * string = [_imgidlist componentsJoinedByString:@","];
            NSLog(@"stringstring = %@",string);
            
            [[TransDataProxyCenter shareController] ystmemberrechargeaId:_aid chargeAmount:money PhotoId:string block:^(NSDictionary *dic, NSError *error) {
                
                NSNumber * code = dic[@"code"];
                NSString * msg = dic[@"msg"];
                if ([code intValue] == 200) {
                    [SVProgressHUD showWithStatus:msg];
                    [SVProgressHUD dismissWithDelay:1];
                    
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self bk_performBlock:^(id obj) {
                         [self.navigationController popViewControllerAnimated:YES];
                     } afterDelay:1];
                 });
                    
                    
                }else{
                    [SVProgressHUD showWithStatus:msg];
                    [SVProgressHUD dismissWithDelay:1];
                
                }
               
            }];
            
        }else{
            
            [SVProgressHUD showWithStatus:@"请选择照片"];
            [SVProgressHUD dismissWithDelay:1];

        }

        
    }else{
        [SVProgressHUD showWithStatus:@"请输入金额"];
        [SVProgressHUD dismissWithDelay:1];
        
    }
    
    
   
//    [SVProgressHUD dismiss];

    
}

@end
