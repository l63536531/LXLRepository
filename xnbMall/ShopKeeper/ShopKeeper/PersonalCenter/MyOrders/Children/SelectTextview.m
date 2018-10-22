//
//  SelectTextview.m
//  ShopKeeper
//
//  Created by zhough on 16/6/15.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "SelectTextview.h"

@implementation SelectTextview

@synthesize tv,tableArray,textField,showList;

-(id)initWithFrame:(CGRect)frame
{
    if (frame.size.height<150) {
        frameHeight = 150;
    }else{
        frameHeight = frame.size.height;
    }
    tabheight = frameHeight-30;
    
    frame.size.height = 30.0f;
    
    self=[super initWithFrame:frame];
    
    if(self){
        showList = NO; //默认不显示下拉框
        
        tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, frame.size.width, 0)];
        tv.delegate = self;
        tv.dataSource = self;
        tv.backgroundColor = [UIColor clearColor];
        tv.separatorColor = [UIColor lightGrayColor];
        tv.hidden = YES;
        [self addSubview:tv];
        
        textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 30, 30)];
        [textField setBackgroundColor:[UIColor whiteColor]];
//        textField.borderStyle=UITextBorderStyleRoundedRect;//设置文本框的边框风格
//        [textField addTarget:self action:@selector(dropdown) forControlEvents:UIControlEventAllTouchEvents];
        [self addSubview:textField];
        
        _selectbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectbtn setFrame:CGRectMake(frame.size.width - 30, 0, 30, 30)];
        [_selectbtn setBackgroundColor:[UIColor whiteColor]];
        [_selectbtn setImage:[UIImage imageNamed:@"wodelan"] forState:UIControlStateNormal];
        [_selectbtn addTarget:self action:@selector(dropdown) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_selectbtn];
        
        
    }
    return self;
}
-(void)dropdown{
//    [textField resignFirstResponder];
    if (showList) {//如果下拉框已显示，什么都不做
        showList = NO;
        tv.hidden = YES;
        
        CGRect sf = self.frame;
        sf.size.height = 30;
        
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];//开始准备动画
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];//动画方式UIViewAnimationCurveLinear
        self.frame = sf;
        CGRect frame = tv.frame;
        frame.size.height = 0;
        tv.frame = frame;

        [UIView commitAnimations];//运行动画


        return;
    }else {//如果下拉框尚未显示，则进行显示
        
        CGRect sf = self.frame;
        sf.size.height = frameHeight;
        
        //把dropdownList放到前面，防止下拉框被别的控件遮住
        [self.superview bringSubviewToFront:self];
        tv.hidden = NO;
        showList = YES;//显示下拉框
        
        CGRect frame = tv.frame;
        frame.size.height = 0;
        tv.frame = frame;
        frame.size.height = tabheight;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];//开始准备动画
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];//动画方式UIViewAnimationCurveLinear
        self.frame = sf;
        tv.frame = frame;
        [UIView commitAnimations];//运行动画
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    cell.textLabel.text = [tableArray objectAtIndex:[indexPath row]];
    cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"sgd");
    textField.text = [tableArray objectAtIndex:[indexPath row]];//选择第几行的数
    [textField resignFirstResponder];
    showList = NO;
    tv.hidden = YES;
    
    CGRect sf = self.frame;
    sf.size.height = 30;
    self.frame = sf;
    CGRect frame = tv.frame;
    frame.size.height = 0;
    tv.frame = frame;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{   // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (![textField isExclusiveTouch]) {
        [textField resignFirstResponder];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    UITextField * textview = self.textField;
    [textview resignFirstResponder];
    return YES;
    
}

@end
