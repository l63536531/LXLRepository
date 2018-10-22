//
//  MABaseViewController.m
//  InnWaiter
//
//  Created by xnb on 16/7/27.
//  Copyright © 2016年 51xnb. All rights reserved.
//

#import "MABaseViewController.h"

@interface MABaseViewController ()

@end

@implementation MABaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initBaseData];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.backBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *className = NSStringFromClass([self class]);
    [MobClick beginLogPageView:className];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSString *className = NSStringFromClass([self class]);
    [MobClick endLogPageView:className];
}

#pragma mark - Touch events

#pragma mark - 

- (void)initBaseData {
    
    _requestCount = 0;
}

#pragma mark - Custom tasks

- (void)showAutoDissmissHud:(NSString *)text {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *nonilStr = [JKTool NoNilStringForString:text];
        MBProgressHUD *temHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        temHUD.mode = MBProgressHUDModeText;
        temHUD.detailsLabel.text = nonilStr;
        temHUD.detailsLabel.font = FONT_HEL(12.f);
        [temHUD hideAnimated:YES afterDelay:1];
    });
}

- (CGFloat)naviControllerContentHeight
{
    CGFloat contentH = SCREEN_HEIGHT - 64.f;
    
    return contentH;
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
