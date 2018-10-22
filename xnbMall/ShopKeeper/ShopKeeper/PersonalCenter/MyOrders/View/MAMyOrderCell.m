/**
 * MAMyOrderCell.m 16/11/8
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MAMyOrderCell.h"

#import "JKViews.h"
#import "JKTool.h"
#import "SKMACROs.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MAMyOrderCell () {
    
    //section0
    JKLabel *_stateLabel;               //订单状态
    JKLabel *_orderNumberLabel;         //订单编号
    JKButton *_deleteBtn;               //只有待支付、已完成的订单可以删除
    //section2
    JKImageView *_imageView1;
    JKImageView *_imageView2;           //最多显示2张图片
    
    JKLabel *_timeLabel;                //日期
    //section3
    JKLabel *_preAmountLabel;           //文案：应付款/实付款
    JKLabel *_amountLabel;              //付款金额
    
//    JKButton *_operationBtn1;
//    JKButton *_operationBtn2;           //执行的操作是根据订单实际情况而变化的。
    JKView *_section2;
    
    NSInteger _state;
    BOOL _isUserAllReadyConfirmDelay;
    BOOL _isCommented;
}

@end

@implementation MAMyOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat seciton0Height = [MAMyOrderCell seciton0Height];
        CGFloat seciton1Height = [MAMyOrderCell seciton1Height];
        CGFloat seciton2Height = [MAMyOrderCell seciton2Height];
        
        UIFont *font1 = FONT_HEL(12.f);
        UIFont *font2 = FONT_HEL(11.f);
        CGFloat labelH = 21.f;
        CGFloat leading = 8.f;
        CGFloat stateLabelW = [JKAutoFitsWidthLabel widthForLabelText:@"待支付" font:font1] + 10.f;
        UIColor *spColor = RGBGRAY(240.f);
//section0
        JKView *section0 = [[JKView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, seciton0Height)];
        [self.contentView addSubview:section0];
        
        _stateLabel = [[JKLabel alloc] initWithFrame:CGRectMake(leading, 0.f, stateLabelW, labelH)];
        _stateLabel.centerY = section0.fHeight / 2.f;
        _stateLabel.font = font1;
        _stateLabel.textColor = THEMECOLOR;
        [section0 addSubview:_stateLabel];
        
        _orderNumberLabel = [[JKLabel alloc] initWithFrame:CGRectMake(_stateLabel.maxX, 0.f, 200.f, labelH)];
        _orderNumberLabel.centerY = _stateLabel.centerY;
        _orderNumberLabel.font = font1;
        _orderNumberLabel.textColor = RGBGRAY(100.f);
        _orderNumberLabel.text = @"订单编号：";
        [section0 addSubview:_orderNumberLabel];
        
        CGFloat deleteBtnW = 40.f;
        CGFloat deleteBtnH = deleteBtnW;
        _deleteBtn = [JKButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setFrame:CGRectMake(SCREEN_WIDTH - deleteBtnW - 10.f, 0.f, deleteBtnW, deleteBtnH)];
        _deleteBtn.centerY = _stateLabel.centerY;
        [_deleteBtn setImage:[UIImage imageNamed:@"垃圾桶"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [section0 addSubview:_deleteBtn];
        
        JKView *separator0 = [[JKView alloc] initWithFrame:CGRectMake(0.f, section0.fHeight - 1.f, section0.fWidth, 1.f)];
        separator0.backgroundColor = spColor;
        [section0 addSubview:separator0];
//section1
        
        JKView *section1 = [[JKView alloc] initWithFrame:CGRectMake(0.f, section0.maxY, SCREEN_WIDTH, seciton1Height)];
        [self.contentView addSubview:section1];
        
        CGFloat imageViewW = 60;
        CGFloat imageViewH = 80;
        
        _imageView1 = [[JKImageView alloc] initWithFrame:CGRectMake(leading + 15.f, 0.f, imageViewW, imageViewH)];
        _imageView1.centerY = section1.fHeight / 2.f;
        [section1 addSubview:_imageView1];
        
        _imageView2 = [[JKImageView alloc] initWithFrame:CGRectMake(_imageView1.maxX + 4.f, 0.f, imageViewW, imageViewH)];
        _imageView2.centerY = _imageView1.centerY;
        [section1 addSubview:_imageView2];
        
        CGFloat redArrowIconW = 15.f;
        CGFloat redArrowIconH = 20.f;
        CGFloat redArrowIconX = SCREEN_WIDTH - 10.f - redArrowIconW;
        
        JKImageView *redArrowIcon = [[JKImageView alloc] initWithFrame:CGRectMake(redArrowIconX, 0.f, redArrowIconW, redArrowIconH)];
        redArrowIcon.centerY = section1.fHeight / 2.f;
        [redArrowIcon setImage:[UIImage imageNamed:@"redjiantou"]];
        [section1 addSubview:redArrowIcon];
        
        CGFloat timeLabelW = [JKAutoFitsWidthLabel widthForLabelText:@"2016-09-09 14:33:33" font:font2] + 8.f;
        CGFloat timeLabelX = SCREEN_WIDTH - 10.f - timeLabelW;
        CGFloat timeLabelY = section1.fHeight - labelH - 5.f;
        
        _timeLabel = [[JKLabel alloc] initWithFrame:CGRectMake(timeLabelX, timeLabelY, timeLabelW, labelH)];
        _timeLabel.font = font2;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = RGBGRAY(200.f);
        _timeLabel.text = @"";
        [section1 addSubview:_timeLabel];
        
        JKView *separator1 = [[JKView alloc] initWithFrame:CGRectMake(0.f, section1.fHeight - 1.f, section1.fWidth, 1.f)];
        separator1.backgroundColor = spColor;
        [section1 addSubview:separator1];
        
//section2
        JKView *section2 = [[JKView alloc] initWithFrame:CGRectMake(0.f, section1.maxY, SCREEN_WIDTH, seciton2Height)];
        [self.contentView addSubview:section2];
        _section2 = section2;
        
        CGFloat preAmountLabelW = [JKAutoFitsWidthLabel widthForLabelText:@"使用积分：" font:font1] + 12.f;
        _preAmountLabel = [[JKLabel alloc] initWithFrame:CGRectMake(leading, 8.f, preAmountLabelW, labelH)];
        _preAmountLabel.font = font1;
        _preAmountLabel.textColor = RGBGRAY(100.f);
        _preAmountLabel.text = @"";
        [section2 addSubview:_preAmountLabel];
        
        _amountLabel = [[JKLabel alloc] initWithFrame:CGRectMake(_preAmountLabel.maxX, 0.f, 200.f, labelH)];
        _amountLabel.centerY = _preAmountLabel.centerY;
        _amountLabel.font = font1;
        _amountLabel.textColor = THEMECOLOR;
        _amountLabel.text = @"";
        [section2 addSubview:_amountLabel];
        
        UIFont *btnFont = FONT_HEL(13.f);
        CGFloat operationBtnH = 30.f;
        CGFloat operationBtnW = [JKAutoFitsWidthLabel widthForLabelText:@"最多四字" font:btnFont] + 16.f;
        CGFloat operationBtnX4 = section2.fWidth - 10.f - operationBtnW;
        CGFloat operationBtnY = section2.fHeight - 15.f - operationBtnH;
        CGFloat operationBtnSpacing = 10.f;
        CGFloat operationBtnX1 = operationBtnX4 - (operationBtnW + operationBtnSpacing) * 3.f;
        
        for (int i = 0; i < 4; i++) {
            
            CGFloat operationBtnX = operationBtnX1 + (operationBtnW + operationBtnSpacing) * i;
            
            JKButton *operationBtn = [JKButton buttonWithType:UIButtonTypeCustom];
            [operationBtn setFrame:CGRectMake(operationBtnX, operationBtnY, operationBtnW, operationBtnH)];
            operationBtn.titleLabel.font = btnFont;
            operationBtn.layer.borderWidth = 1.f;
            operationBtn.layer.cornerRadius = 4.f;
            operationBtn.tag = 100 + i;
            [operationBtn addTarget:self action:@selector(operationBtn:) forControlEvents:UIControlEventTouchUpInside];
            [section2 addSubview:operationBtn];
        }
        //
        JKView *separator2 = [[JKView alloc] initWithFrame:CGRectMake(0.f, section2.fHeight - 10.f, section2.fWidth, 10.f)];
        separator2.backgroundColor = RGBGRAY(245.f);
        [section2 addSubview:separator2];
    }
    return self;
}

#pragma mark - Touch events

- (void)deleteBtn:(id)sender {
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(tableViewTag:row:operation:state:isdelay:isCommented:)]) {
        [_delegate tableViewTag:_tableViewTag row:_row operation:-1 state:_state isdelay:_isUserAllReadyConfirmDelay isCommented:_isCommented];
    }
}

- (void)operationBtn:(JKButton *)btn {
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(tableViewTag:row:operation:state:isdelay:isCommented:)]) {
        [_delegate tableViewTag:_tableViewTag row:_row operation:btn.tag - 100 state:_state isdelay:_isUserAllReadyConfirmDelay isCommented:_isCommented];
    }
}

#pragma mark - setter

- (void)setOrderInfoDic:(NSDictionary *)orderInfoDic {
    
    //待支付：1     待发货：2,7    待签收：3,8   已完成：4,5,6,99
    //activityType 6是积分订单
    //隐藏底部按钮
    for (UIView *view in _section2.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.hidden = YES;
        }
    }
    _deleteBtn.hidden = YES;
    
    if (orderInfoDic != nil) {
        NSInteger state = [orderInfoDic[@"state"] integerValue];
        _state = state;
        
        NSString *orderNumber = orderInfoDic[@"code"];
        NSArray *goodsList = orderInfoDic[@"goodsList"];
        
/***********************************底部按钮、状态***********************************/
        
        UIColor *btnRedColor = THEMECOLOR;
        UIColor *btnGrayColor = RGBGRAY(240.f);
        UIColor *btnWhiteColor = [UIColor whiteColor];
        
        if (state == 1) {
            _deleteBtn.hidden = NO;
            _stateLabel.text = @"待支付";
            
            //订单追踪
            JKButton *btn3 = (JKButton *)[_section2 viewWithTag:102];
            btn3.hidden = NO;
            btn3.backgroundColor = btnGrayColor;
            btn3.layer.borderColor = btnGrayColor.CGColor;
            [btn3 setTitle:@"订单追踪" forState:UIControlStateNormal];
            [btn3 setTitleColor:btnRedColor forState:UIControlStateNormal];
            //付款按钮
            JKButton *btn4 = (JKButton *)[_section2 viewWithTag:103];
            btn4.hidden = NO;
            btn4.backgroundColor = btnRedColor;
            btn4.layer.borderColor = btnRedColor.CGColor;
            [btn4 setTitle:@"付款" forState:UIControlStateNormal];
            [btn4 setTitleColor:btnWhiteColor forState:UIControlStateNormal];
            
        }else if (state == 2 || state == 7) {
            _deleteBtn.hidden = YES;
            _stateLabel.text = @"待发货";
            
            //订单追踪
            JKButton *btn4 = (JKButton *)[_section2 viewWithTag:103];
            btn4.hidden = NO;
            btn4.backgroundColor = btnGrayColor;
            btn4.layer.borderColor = btnGrayColor.CGColor;
            [btn4 setTitle:@"订单追踪" forState:UIControlStateNormal];
            [btn4 setTitleColor:btnRedColor forState:UIControlStateNormal];
            
        }else if (state == 3 || state == 8) {
            _deleteBtn.hidden = YES;
            _stateLabel.text = @"待签收";
            
            //订单追踪
            JKButton *btn3 = (JKButton *)[_section2 viewWithTag:102];
            btn3.hidden = NO;
            btn3.backgroundColor = btnGrayColor;
            btn3.layer.borderColor = btnGrayColor.CGColor;
            [btn3 setTitle:@"订单追踪" forState:UIControlStateNormal];
            [btn3 setTitleColor:btnRedColor forState:UIControlStateNormal];
            //确认收货 按钮
            JKButton *btn4 = (JKButton *)[_section2 viewWithTag:103];
            btn4.hidden = NO;
            btn4.backgroundColor = btnRedColor;
            btn4.layer.borderColor = btnRedColor.CGColor;
            [btn4 setTitle:@"确认收货" forState:UIControlStateNormal];
            [btn4 setTitleColor:btnWhiteColor forState:UIControlStateNormal];
            
            //计算是否超过了7天：延迟收货按钮：订单state为3并且当前时间大于发货时间+7天 时显示
            NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
            [fomatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSDate *deliveryDate = [fomatter dateFromString:orderInfoDic[@"deliveryDate"]];
            NSTimeInterval interval = -[deliveryDate timeIntervalSinceNow];
            NSTimeInterval sevenDayInterval = 7 * 24 * 60 * 60;
            
            BOOL isDelayMoreThan7Days = interval > sevenDayInterval;
            //超过7天
            if (isDelayMoreThan7Days) {
                //延迟收货
                JKButton *btn2 = (JKButton *)[_section2 viewWithTag:101];
                btn2.hidden = NO;
                [btn2 setTitle:@"延迟收货" forState:UIControlStateNormal];
                
                _isUserAllReadyConfirmDelay = [orderInfoDic[@"isdelay"] boolValue];//是否已经点击过延迟收货
                
                if (_isUserAllReadyConfirmDelay) {
                    //用户已经点击了 【延迟收货】 按钮
                    btn2.backgroundColor = btnGrayColor;
                    btn2.layer.borderColor = btnGrayColor.CGColor;
                    [btn2 setTitleColor:btnRedColor forState:UIControlStateNormal];
                }else {
                    btn2.backgroundColor = btnRedColor;
                    btn2.layer.borderColor = btnRedColor.CGColor;
                    [btn2 setTitleColor:btnWhiteColor forState:UIControlStateNormal];
                }
            }else {
                
                
            }
            
        }else if (state == 4 || state == 5 || state == 6 || state == 99) {
            _deleteBtn.hidden = NO;
            _stateLabel.text = @"已完成";
            
            //订单追踪
            JKButton *btn3 = (JKButton *)[_section2 viewWithTag:102];
            btn3.hidden = NO;
            btn3.backgroundColor = btnGrayColor;
            btn3.layer.borderColor = btnGrayColor.CGColor;
            [btn3 setTitle:@"订单追踪" forState:UIControlStateNormal];
            [btn3 setTitleColor:btnRedColor forState:UIControlStateNormal];
            
            _isCommented = [orderInfoDic[@"allGoodsComment"] boolValue];
            if (_isCommented) {
                //所有商品已经评价
                //已评价按钮
                JKButton *btn4 = (JKButton *)[_section2 viewWithTag:103];
                btn4.hidden = NO;
                btn4.backgroundColor = btnGrayColor;
                btn4.layer.borderColor = btnGrayColor.CGColor;
                [btn4 setTitle:@"已评价" forState:UIControlStateNormal];
                [btn4 setTitleColor:btnRedColor forState:UIControlStateNormal];
            }else {
                //评价按钮
                JKButton *btn4 = (JKButton *)[_section2 viewWithTag:103];
                btn4.hidden = NO;
                btn4.backgroundColor = btnRedColor;
                btn4.layer.borderColor = btnRedColor.CGColor;
                [btn4 setTitle:@"评价" forState:UIControlStateNormal];
                [btn4 setTitleColor:btnWhiteColor forState:UIControlStateNormal];
            }
        }
        
/***********************************编号***********************************/
        _orderNumberLabel.text = [NSString stringWithFormat:@"订单编号：%@",orderNumber];
/***********************************图片***********************************/
        
        if (goodsList.count == 0) {
            //无图片
            _imageView1.hidden = YES;
            _imageView2.hidden = YES;
        }else if (goodsList.count == 1) {
            _imageView1.hidden = NO;
            _imageView2.hidden = YES;
            
            NSDictionary *goodInfoDic = goodsList[0];
            NSString *logoId = goodInfoDic[@"logoId"];
            if (logoId != nil && logoId.length > 0) {
                NSURL *url = [NSURL URLWithString:logoId];
                [_imageView1 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"wodelan"]];
            }
            
        }else if (goodsList.count >= 2) {
            _imageView1.hidden = NO;
            _imageView2.hidden = NO;
            
            NSDictionary *goodInfoDic1 = goodsList[0];
            NSString *logoId1 = goodInfoDic1[@"logoId"];
            
            NSDictionary *goodInfoDic2 = goodsList[1];
            NSString *logoId2 = goodInfoDic2[@"logoId"];
            
            if (logoId1 != nil && logoId1.length > 0) {
                NSURL *url = [NSURL URLWithString:logoId1];
                [_imageView1 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"wodelan"]];
            }
            
            if (logoId2 != nil && logoId2.length > 0) {
                NSURL *url = [NSURL URLWithString:logoId2];
                [_imageView2 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"wodelan"]];
            }
        }
        //
        _timeLabel.text = orderInfoDic[@"settleDate"];
/***********************************订单金额***********************************/
        //activityType 6是积分订单
        NSInteger activityType = [orderInfoDic[@"activityType"] integerValue];
        
        if (state == 1) {
            if (activityType == 6) {
                //积分
                _preAmountLabel.text = @"使用积分：";
                _amountLabel.text = [NSString stringWithFormat:@"%.0f",[orderInfoDic[@"bonus"] floatValue]];
            }else {
                _preAmountLabel.text = @"应付款：";
                _amountLabel.text = [NSString stringWithFormat:@"￥%.2f",[orderInfoDic[@"needPaidAmount"] floatValue]];
            }
        }else {
            if (activityType == 6) {
                //积分
                _preAmountLabel.text = @"使用积分：";
                _amountLabel.text = [NSString stringWithFormat:@"%.0f",[orderInfoDic[@"bonus"] floatValue]];
            }else {
                _preAmountLabel.text = @"实付款：";
                _amountLabel.text = [NSString stringWithFormat:@"￥%.2f",[orderInfoDic[@"paidAmount"] floatValue]];
            }
        }
    }
}

#pragma mark -

+ (CGFloat)cellHeight {
    return [self seciton0Height] + [self seciton1Height] + [self seciton2Height];
}

//状态、订单编号区域
+ (CGFloat)seciton0Height {
    return 40.f;
}

//图片、时间区域
+ (CGFloat)seciton1Height {
    return 100.f;
}

//付款金额、操作按钮区域
+ (CGFloat)seciton2Height {
    return 80.f;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
