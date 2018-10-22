//
//  MsgDetailViewController.m
//  ShopKeeper
//
//  Created by zzheron on 16/6/22.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MsgDetailViewController.h"
#import "ShareUnity.h"
#import "TransDataProxyCenter.h"
#import "SKBaseH5ViewController.h"


@interface MsgDetailViewController () {
    
    JKAutoFitsHeightWithLineSpacingLabel *_titleLabel;
    
    JKAutoFitsHeightWithLineSpacingLabel *_contentLabel;
    
    JKButton *_checkBtn;
    JKLabel *_dateLabel;
}

@end

@implementation MsgDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:self.titleName];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"　"
                                                                             style:(UIBarButtonItemStylePlain)
                                                                            target:nil
                                                                            action:nil];
    [self createUI];
    
    [self requestData];
}

- (void)createUI {
    
    UIView * line = [[UIView alloc] init];
    [line setBackgroundColor:ColorFromRGB(240, 240, 240)];
    
    _titleLabel = [[JKAutoFitsHeightWithLineSpacingLabel alloc] initWithFrame:CGRectMake(8.f, 8.f, SCREEN_WIDTH - 16.f, 21.f) lineSpacing:3.f];
    _titleLabel.font = FONT_HEL(14.f);
    _titleLabel.textColor = RGBGRAY(100.f);
    [self.view addSubview:_titleLabel];
    
    _contentLabel = [[JKAutoFitsHeightWithLineSpacingLabel alloc] initWithFrame:CGRectMake(16.f, _titleLabel.maxY + 10.f, SCREEN_WIDTH - 32.f, 21.f) lineSpacing:3.f];
    _contentLabel.font = FONT_HEL(13.f);
    _contentLabel.textColor = RGBGRAY(100.f);
    [self.view addSubview:_contentLabel];
    
    _checkBtn = [JKButton buttonWithType:UIButtonTypeCustom];
    [_checkBtn setFrame:CGRectMake(0.f, _contentLabel.maxY + 10.f, 150.f, 33.f)];
    _checkBtn.centerX = SCREEN_WIDTH / 2.f;
    [_checkBtn setTitle:@"点此查看详情" forState:UIControlStateNormal];
    [_checkBtn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    [_checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _checkBtn.backgroundColor = THEMECOLOR;
    _checkBtn.layer.cornerRadius = 5.f;
    _checkBtn.hidden = YES;
    [self.view addSubview:_checkBtn];
    
    _dateLabel = [[JKLabel alloc] initWithFrame:CGRectMake(10.f, _titleLabel.maxY + 8.f, SCREEN_WIDTH - 20.f, 21.f)];
    _dateLabel.textColor = RGBGRAY(150.f);
    _dateLabel.font = FONT_HEL(12.f);
    _dateLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_dateLabel];
}

- (void)refreshData {
    
    _titleLabel.text = _dicdata[@"title"];
    
    NSString *summary = [JKTool noNilOrSpaceStringForStr:_dicdata[@"summary"]];
    NSString *content = [JKTool noNilOrSpaceStringForStr:_dicdata[@"content"]];
    
    _contentLabel.orgY = _titleLabel.maxY + 10.f;
    NSString *showContent = [NSString stringWithFormat:@"%@\n%@",summary,content];
    _contentLabel.text = showContent;
    
    NSString * url =  _dicdata[@"link"];
    
    if (url != nil && url.length > 0) {
        _checkBtn.hidden = NO;
        _checkBtn.orgY = _contentLabel.maxY + 10.f;
        _dateLabel.orgY = _checkBtn.maxY + 8.f;
    }else {
        _checkBtn.hidden = YES;
        _dateLabel.orgY = _contentLabel.maxY + 8.f;
    }
    
    _dateLabel.text = _dicdata[@"createTime"];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"cell");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)buttonclick:(id)sender{
    
    SKBaseH5ViewController* vc = [[SKBaseH5ViewController alloc]init];
    vc.dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"link":_dicdata[@"link"]}];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)requestData {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [JKURLSession taskWithMethod:@"message/messageDetail.do" parameter:@{@"messageMemberDetailId":_getmessgeid} token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        [hud hideAnimated:YES];
        if (error == nil) {
            _dicdata = resultDic[@"data"];
            [self refreshData];
        }else {
            [self showAutoDissmissHud:error.localizedDescription];
        }
    }];
}

@end
