//
//  WithdrawalRecordCell.m
//  ShopKeeper
//
//  Created by zhough on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "WithdrawalRecordCell.h"
@interface WithdrawalRecordCell()


@property (nonatomic,strong) UILabel * timelabel;//时间

@property (nonatomic,strong) UILabel * accountlabel;//处理结果

@property (nonatomic,strong) UILabel * personlabel;//处理结果

@property (nonatomic,strong) UILabel * balancelabel;//余额


@property (nonatomic,strong) UILabel * servicelabel;//备注

@end

@implementation WithdrawalRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        self.accountlabel =[[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.accountlabel];
        
        self.timelabel =[[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.timelabel];
        
        self.personlabel =[[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.personlabel];
        
        self.balancelabel =[[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.balancelabel];
        
        self.servicelabel =[[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.servicelabel];
        
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 1)];
        [line setBackgroundColor:ColorFromRGB(240, 240, 240)];
        [self.contentView addSubview:line];
        
        UIView * line_0 = [[UIView alloc] initWithFrame:CGRectMake(0, 110, SCREEN_WIDTH, 1)];
        [line_0 setBackgroundColor:ColorFromRGB(240, 240, 240)];
        [self.contentView addSubview:line_0];

        
        UIView * line_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 140, SCREEN_WIDTH, 10)];
        [line_1 setBackgroundColor:ColorFromRGB(240, 240, 240)];
        [self.contentView addSubview:line_1];
        
        
    }
    
    return self;
    
}
-(void)update:(WithdrawalRecordModel*)titlearray{
    _withmodel  = titlearray;
    
    [self layoutSubviews];
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    

    CGFloat leftx= 15;
    
    self.timelabel.frame = CGRectMake(leftx, 0, SCREEN_WIDTH/2, 30);
    [self.timelabel setFont:[UIFont systemFontOfSize:15]];
    [self.timelabel setText:[NSString stringWithFormat:@"%@",_withmodel.submittingDate]];
    [self.timelabel setTextColor:[UIColor lightGrayColor]];
    [self.timelabel setNumberOfLines:0];
    [self.timelabel setTextAlignment:NSTextAlignmentLeft];

    
    
    self.accountlabel.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2 - leftx, 30);
    [self.accountlabel setFont:[UIFont systemFontOfSize:15]];
    [self.accountlabel setTextColor:ColorFromRGB(74, 195, 37)];
    [self.accountlabel setNumberOfLines:0];
    [self.accountlabel setTextAlignment:NSTextAlignmentRight];
    
    
    
    self.personlabel.frame = CGRectMake(leftx, 30, SCREEN_WIDTH*2/3, 80);
    [self.personlabel setFont:[UIFont systemFontOfSize:16]];
    
    NSString* stringcard = _withmodel.bankAccount;
    
    NSString* getchangestring;
    
    if (stringcard.length<10) {
        getchangestring  =  stringcard;

    }else{
        getchangestring  =  [stringcard stringByReplacingCharactersInRange:NSMakeRange(6,  stringcard.length- 10) withString:@"****"];

    }
    
    //提现人
    NSString *submitternameN =  _withmodel.submittername;
    if (submitternameN == nil) {
        submitternameN = @"";
    }
    //开户行
    NSString *bankN =  _withmodel.bank;
    if (bankN == nil) {
        bankN = @"";
    }
    [self.personlabel setText:[NSString stringWithFormat:@"提现人：%@\n开户行：%@\n银行卡号：%@",submitternameN,bankN,getchangestring]];
    [self.personlabel setTextColor:[UIColor grayColor]];
    [self.personlabel setNumberOfLines:0];
    [self.personlabel setTextAlignment:NSTextAlignmentLeft];
  
    //备注
    self.balancelabel.frame = CGRectMake(SCREEN_WIDTH*2/3+20, 30, SCREEN_WIDTH/3 - 35, 80);
    [self.balancelabel setFont:[UIFont systemFontOfSize:30]];
    [self.balancelabel setBackgroundColor:[UIColor clearColor]];
    [self.balancelabel setTextColor:ColorFromRGB(74, 195, 37)];
    self.balancelabel.adjustsFontSizeToFitWidth = YES;
    [self.balancelabel setTextAlignment:NSTextAlignmentRight];
    
     NSString *amountN = _withmodel.amount;
    if (amountN == nil) {
        amountN = @"";
    }
    [self.balancelabel setText:[NSString stringWithFormat:@"%@",amountN]];
    
    
    
    self.servicelabel.frame = CGRectMake(leftx, 110, SCREEN_WIDTH -leftx, 30);
    [self.servicelabel setFont:[UIFont systemFontOfSize:14]];
    [self.servicelabel setTextColor:TEXTVICE_COLOR];
    [self.servicelabel setBackgroundColor:[UIColor clearColor]];
    [self.servicelabel setNumberOfLines:0];
    [self.servicelabel setTextAlignment:NSTextAlignmentLeft];
    
    NSString*  getnote = _withmodel.notes;
    if (!(getnote.length>0)) {
        getnote = @"";
    }
    
    NSString* labtext1 =[NSString stringWithFormat:@"备注：%@",getnote] ;
    NSMutableAttributedString *typeStr1 = [[NSMutableAttributedString alloc] initWithString:labtext1];
    [typeStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 3)];
    //    [typeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12]range:NSMakeRange(0, 6)];
    self.servicelabel.attributedText=typeStr1;
    
    
    NSString* getresult = nil;
    NSString *processResult = _withmodel.processResult;
    //#warning processResult 数据无返回 导致都是成功
    
    if ([processResult isEqualToString:@"1"]) {  //processResult
        getresult = @"提现成功";
        [self.accountlabel setTextColor:[UIColor redColor]];
        [self.balancelabel setTextColor:[UIColor redColor]];
        
    }else if ([_withmodel.processResult isEqualToString:@"0"]){
        
        getresult = @"提现失败";
        
        
    }else if ([processResult isEqualToString:@"-1"] || _withmodel.processResult == nil){
        
        getresult =@"尚未处理";
        
    }else{
        getresult =@"尚未处理";
        
        
    }
    
    NSString* labtext =[NSString stringWithFormat:@"处理结果：%@",getresult] ;
    NSMutableAttributedString *typeStr = [[NSMutableAttributedString alloc] initWithString:labtext];
    [typeStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 5)];
    self.accountlabel.attributedText=typeStr;

}


@end
