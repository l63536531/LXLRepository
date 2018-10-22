//
//  ImageSelectingview.m
//  ShopKeeper
//
//  Created by zhough on 16/8/3.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "ImageSelectingview.h"


#define windowContentWidth  ([[UIScreen mainScreen] bounds].size.width)
#define SFQRedColor [UIColor colorWithRed:255/255.0 green:92/255.0 blue:79/255.0 alpha:1]
#define MAX_TitleNumInWindow 4

@implementation ImageSelectingview

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(!self){
        return self;
        
    }
    
    return self;
    
}


-(void)titles:(NSArray *)titleArray clickBlick:(btnClickBlock)block{
    _btn_w=0.0;
    if (titleArray.count<MAX_TitleNumInWindow+1) {
        _btn_w=self.frame.size.width/titleArray.count;
    }else{
        _btn_w=self.frame.size.width/MAX_TitleNumInWindow;
    }
    _titles=titleArray;
    _defaultIndex=1;
    _titleFont=[UIFont systemFontOfSize:15];
    _btns=[[NSMutableArray alloc] initWithCapacity:0];
    _titleNomalColor= KFontColor(@"#646464");
    _titleSelectColor=SFQRedColor;
    
    
    _bgScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width , self.frame.size.height)];
    _bgScrollView.backgroundColor=[UIColor whiteColor];
    
    _bgScrollView.bounces = NO;
    _bgScrollView.scrollsToTop = YES;
    _bgScrollView.userInteractionEnabled = YES;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    _bgScrollView.showsVerticalScrollIndicator = NO;
    _bgScrollView.delegate = self;
    _bgScrollView.contentSize=CGSizeMake(_btn_w*titleArray.count,0);
    [self addSubview:_bgScrollView];
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, _btn_w*titleArray.count, 1)];
    line.backgroundColor=[UIColor lightGrayColor];
    [_bgScrollView addSubview:line];
    
    _selectLine=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2, _btn_w, 2)];
    _selectLine.backgroundColor=_titleSelectColor;
    [_bgScrollView addSubview:_selectLine];
    
    for (int i=0; i<titleArray.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(_btn_w*i, 0, _btn_w, self.frame.size.height-2);
        btn.tag=i+1;
        UIImage* image = [UIImage imageWithData:[NSData
                                                 dataWithContentsOfURL:[NSURL URLWithString:titleArray[i]]]];
        
        [btn setImage:image forState:UIControlStateNormal];
//        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn.titleLabel setNumberOfLines:0];
        [btn setTitleColor:_titleNomalColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.titleLabel.font=_titleFont;
        [_bgScrollView addSubview:btn];
        [_btns addObject:btn];
        if (i==0) {
            _titleBtn=btn;
            btn.selected=YES;
        }
        self.block=block;
        
    }
    
}

-(void)btnClick:(UIButton *)btn{
    
    if (self.block) {
        self.block(btn.tag);
    }
    
    if (btn.tag==_defaultIndex) {
        return;
    }else{
        _titleBtn.selected=!_titleBtn.selected;
        _titleBtn=btn;
        _titleBtn.selected=YES;
        _defaultIndex=btn.tag;
    }
    
    //计算偏移量
    CGFloat offsetX=btn.frame.origin.x - 2*_btn_w;
    if (offsetX<0) {
        offsetX=0;
    }
    CGFloat maxOffsetX= _bgScrollView.contentSize.width-self.frame.size.width;
    if (offsetX>maxOffsetX) {
        offsetX=maxOffsetX;
    }
    
    [UIView animateWithDuration:.2 animations:^{
        
        [_bgScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        _selectLine.frame=CGRectMake(btn.frame.origin.x, self.frame.size.height-2, btn.frame.size.width, 2);
        
    } completion:^(BOOL finished) {
        
    }];
    
}



-(void)setTitleNomalColor:(UIColor *)titleNomalColor{
    _titleNomalColor=titleNomalColor;
    [self updateView];
}

-(void)setTitleSelectColor:(UIColor *)titleSelectColor{
    _titleSelectColor=titleSelectColor;
    [self updateView];
}

-(void)setTitleFont:(UIFont *)titleFont{
    _titleFont=titleFont;
    [self updateView];
}

-(void)setDefaultIndex:(NSInteger)defaultIndex{
    _defaultIndex=defaultIndex;
    [self updateView];
}

-(void)updateView{
    for (UIButton *btn in _btns) {
        [btn setTitleColor:_titleNomalColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
        btn.titleLabel.font=_titleFont;
        _selectLine.backgroundColor=_titleSelectColor;
        
        if (btn.tag-1==_defaultIndex-1) {
            _titleBtn=btn;
            btn.selected=YES;
        }else{
            btn.selected=NO;
        }
    }
}

@end
