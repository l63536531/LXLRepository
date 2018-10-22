/**
 * MASpecificationView.m 16/11/19
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MASpecificationView.h"

#import "JKViews.h"
#import "MASpecBtn.h"

@interface MASpecificationView () {
    
    NSMutableDictionary *_mSelectedSpecDic;         //已选中的规格集合  {@"颜色":"黄色","尺寸":@28}
    
    JKView *_separator;
}

@end

@implementation MASpecificationView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 50.f)];
    if (self != nil) {
        
        CGFloat cellW = SCREEN_WIDTH;
        CGFloat leading = 8.f;
        CGFloat lbaelW = cellW - leading * 2.f;
        
        CGFloat labelH = 21.f;
        
        JKLabel *titleLabel = [[JKLabel alloc] initWithFrame:CGRectMake(leading, 8.f, lbaelW, labelH)];
        titleLabel.font = FONT_HEL(14.f);
        titleLabel.textColor = RGBGRAY(100.f);
        [self addSubview:titleLabel];
        titleLabel.text = @"选择商品规格型号";
        
        _separator = [[JKView alloc] initWithFrame:CGRectMake(0.f, 40.f, SCREEN_WIDTH, 1.f)];
        _separator.backgroundColor = RGBGRAY(240.f);
        [self addSubview:_separator];
        //
        _mSelectedSpecDic = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

/**
 *  @author 黎国基, 16-11-19 09:11
 *
 *  所有规格，如鞋子规格有  尺码（38，39，40，41，42）、颜色（蓝黑红白黄）
 */
- (void)setSpecTypeMapDic:(NSDictionary *)specTypeMapDic {
    
    _specTypeMapDic = specTypeMapDic;
    
    /*
     "specTypeMap":{
     "尺寸":[
     "150*200 4斤",
     "150*200 5斤"
     ]
     }
     */
    
    NSArray *specKeys = [specTypeMapDic allKeys];//所有类型的规格名称
    
    CGFloat specSectionWOrgY = 30.f;
    CGFloat specSectionY = specSectionWOrgY;
    
    NSInteger sectionTag = 100;
    for (NSString *specKey in specKeys) {

        NSArray *specArray = specTypeMapDic[specKey];
        
        JKView *specSection = [self specSectionForKey:specKey specs:specArray];
        specSection.orgY = specSectionY;
        specSection.tag = sectionTag;
        [self addSubview:specSection];
        specSectionY = specSection.maxY;
        
        sectionTag ++;
    }
    
    _separator.orgY = specSectionY;
    
    self.fHeight = _separator.maxY;
}

/**
 *  @author 黎国基, 16-11-19 10:11
 *
 *  对每类规格 生成一个 section
 *
 *  @param key       规格类型
 *  @param specArray 该类型的所有 规格
 *
 *  @return section
 */
- (JKView *)specSectionForKey:(NSString *)key specs:(NSArray *)specArray {
    
    CGFloat leading = 8.f;
    
    
    CGFloat specSectionW = SCREEN_WIDTH - leading * 2.f;
    CGFloat labelH = 24.f;
    
    JKView *specSection = [[JKView alloc] initWithFrame:CGRectMake(leading, 0.f, specSectionW, 0.f)];
    
    //规格类型，如 【颜色】
    JKLabel *typeLabel = [[JKLabel alloc] initWithFrame:CGRectMake(leading, 0.f, specSectionW, labelH)];
    typeLabel.font = FONT_HEL(14.f);
    typeLabel.textColor = RGBGRAY(100.f);
    [specSection addSubview:typeLabel];
    typeLabel.text = [NSString stringWithFormat:@"%@：",key];
    //规格可选尺寸
    UIFont *btnFont = FONT_HEL(13.f);
    CGFloat btnH = 30.f;
    
    CGFloat btnX = 0.f;
    CGFloat btnY = typeLabel.maxY;
    
    for (NSInteger i = 0; i < specArray.count; i++) {
        
        NSString *specValue = specArray[i];
        CGFloat btnW = [JKAutoFitsWidthLabel widthForLabelText:specValue font:btnFont] + 10.f;
        
        if (btnW < 35.f) {
            btnW = 35.f;
        }

        if (btnX + btnW > specSectionW) {
            btnX = 0.f;//这一行放不下这个btn了，移到下一行（不考虑一行放不下一个btn的不合理情况）
            btnY = btnY + btnH + 4.f;
        }
        
        MASpecBtn *specBtn = [MASpecBtn buttonWithType:UIButtonTypeCustom];
        [specBtn setFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        specBtn.titleLabel.font = btnFont;
        [specBtn setTitle:specValue forState:UIControlStateNormal];
        [specBtn addTarget:self action:@selector(specBtn:) forControlEvents:UIControlEventTouchUpInside];
        specBtn.tag = i;
        [specSection addSubview:specBtn];
        specBtn.specState = 1;//初始可选
        
        specBtn.specType = key;
        specBtn.specValue = specValue;
        
        btnX = specBtn.maxX + 4.f;
    }
    
    specSection.fHeight = btnY + btnH + 4.f;
    
    return specSection;
}

- (void)specBtn:(MASpecBtn *)btn {
    
    if (btn.specState == 0) {
        //不可选，不做任何事
    }else if (btn.specState == 1 || btn.specState == 2) {
        //可选||/已选中
        [self didClickSpecBtn:btn withCallBack:YES];
    }
}

/**
 *  @author 黎国基, 16-11-19 11:11
 *
 *  点击一个btn后的操作
 *
 *  @param btnTag     [0-N]
 *  @param sectionTag [100-X]
 */
- (void)didClickSpecBtn:(MASpecBtn *)clickedBtn withCallBack:(BOOL)callBack{
    
    NSArray *specKeys = [_specTypeMapDic allKeys];//所有类型的规格名称
    for (NSInteger i = 0; i < specKeys.count; i++) {
        //遍历section
        UIView *section = [self viewWithTag:100 + i];
        
        if (section == clickedBtn.superview) {
            //点击的button 所在的 section，同类规格，除自身变化state外，已选中的btn要取消选中，其他btn不做任何改变
            for (UIView *view in section.subviews) {
                if ([view isKindOfClass:[MASpecBtn class]]) {
                    MASpecBtn *btn = (MASpecBtn *)view;
                    if (btn != clickedBtn && btn.specState == 2) {
                        btn.specState = 1;
                        [_mSelectedSpecDic removeObjectForKey:btn.specType];/*****************4444444444444444444444相克444444444444，此处必须先执行**********************/
                    }
                }
            }
        }else {
            //与点击的btn的 规格类型不同，在不同的section上
            for (UIView *view in section.subviews) {
                if ([view isKindOfClass:[MASpecBtn class]]) {
                    MASpecBtn *btn = (MASpecBtn *)view;
                    if (btn.specState == 2) {
                        //如果原来是选中，那一定是保持选中的
                    }else {
                        //确定是否可选
                        
                        NSArray *mapKeys = [_specDescMapDic allKeys];
                        
                        BOOL isThisBtnCanBeSelected = NO;
                        
                        for (NSString *mapKey in mapKeys) {
                            NSDictionary *specTeamDic = _specDescMapDic[mapKey];//一组可选的规格
                            
                            NSMutableDictionary *mTempTestDic = [[NSMutableDictionary alloc] initWithDictionary:_mSelectedSpecDic copyItems:YES];
                            [mTempTestDic setObject:btn.specValue forKey:btn.specType];
                            if ([self dictionary:mTempTestDic isSubSetofDic:specTeamDic]) {
                                isThisBtnCanBeSelected = YES;       //这个button的规格 + 已选规格 = 某组可选规格的子集，则表示该button（规格）可被选中
                                break;
                            }
                            mTempTestDic = nil;
                        }
                        
                        btn.specState = isThisBtnCanBeSelected ? 1 : 0;
                    }
                }
            }
        }
    }
    
    //点击的btn state == 1 || 2
    if (clickedBtn.specState == 1) {
        clickedBtn.specState = 2;//选中
        [_mSelectedSpecDic setObject:clickedBtn.specValue forKey:clickedBtn.specType];/*****************4444444444444444444相克4444444444444444444444，此处必须后执行****************/
        
        if (callBack) {
            if (_delegate != nil && [_delegate respondsToSelector:@selector(specificationViewDidChangeSpecification:)]) {
                [_delegate specificationViewDidChangeSpecification:self.specIdDic[@"result"]];
            }
        }
    }else {
        //specState == 2，取消选中
        //需求设计为禁止取消选中。必须选择一个规格。如果要允许取消选择，开放下面两行代码
//        clickedBtn.specState = 1;//取消选中
//        [_mSelectedSpecDic removeObjectForKey:clickedBtn.specType];
    }
}

- (BOOL)dictionary:(NSDictionary *)subDic isSubSetofDic:(NSDictionary *)superDic {
    
    //sub dic
    NSMutableSet *subDicSet = [[NSMutableSet alloc] init];
    
    NSArray *subDicKeys = [subDic allKeys];
    for (NSString *key in subDicKeys) {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@_%@",key,subDic[key]];//把键值对组合成一个string
        [subDicSet addObject:keyValueStr];
    }
    //sup dic
    NSMutableSet *superDicSet = [[NSMutableSet alloc] init];
    
    NSArray *superDicKeys = [superDic allKeys];
    for (NSString *key in superDicKeys) {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@_%@",key,superDic[key]];//把键值对组合成一个string
        [superDicSet addObject:keyValueStr];
    }
    
    return [subDicSet isSubsetOfSet:superDicSet];
}

/**
 *  @author 黎国基, 16-11-21 17:11
 *
 *  getter
 *
 *  @return 规格id
 */
- (NSDictionary *)specIdDic {
    
    NSArray *specKeys = [_specTypeMapDic allKeys];//所有类型的规格名称
    
    NSArray *userSelectedSpecKeys = [_mSelectedSpecDic allKeys];//用户已选择的所有类型的规格名称
    
    for (NSString *key in specKeys) {
        //
        BOOL isKeySelected = NO;    //用户是否选择了这个类型的规格
        for (NSString *selectedKey in userSelectedSpecKeys) {
            if ([key isEqualToString:selectedKey]) {
                isKeySelected = YES;
                break;
            }
        }
        if (!isKeySelected) {
            return @{@"result":key,@"allKeysSelected":[NSNumber numberWithBool:NO]};
        }
    }
    //所有类型的规格都选好了
    NSArray *mapKeys = [_specDescMapDic allKeys];
    
    for (NSString *specID in mapKeys) {
        NSDictionary *specTeamDic = _specDescMapDic[specID];//一组可选的规格
        
        if ([self dictionary:specTeamDic isSubSetofDic:_mSelectedSpecDic] && [self dictionary:_mSelectedSpecDic isSubSetofDic:specTeamDic]) {
            //两个字典互为子集，证明相等--得到了最后的结果
            return @{@"result":specID,@"allKeysSelected":[NSNumber numberWithBool:YES]};
        }
    }
    
    return @{@"result":@"规格错误",@"allKeysSelected":[NSNumber numberWithBool:NO]};
}

/**
 *  @author 黎国基, 16-11-21 17:11
 *
 *  必须先设置_specDescMapDic，才能设置specId，否则没办法该规格id对应的规格组合
 *
 *  @param specId
 */
- (void)setSpecId:(NSString *)specId {
    
    NSArray *mapKeys = [_specDescMapDic allKeys];
    BOOL isSpecIdExsist = NO;
    for (NSString *mapKey in mapKeys) {

        if ([specId isEqualToString:mapKey]) {
            isSpecIdExsist = YES;
            NSDictionary *specTeamDic = _specDescMapDic[mapKey];//一组可选的规格
            
            NSArray *specKeys = [_specTypeMapDic allKeys];//所有类型的规格名称，section count
            for (NSInteger i = 0; i < specKeys.count; i++) {
                //遍历section
                UIView *section = [self viewWithTag:100 + i];
                for (UIView *view in section.subviews) {
                    if ([view isKindOfClass:[MASpecBtn class]]) {
                        MASpecBtn *btn = (MASpecBtn *)view;
                        NSString *defaultSpec = specTeamDic[btn.specType];
                        if ([btn.specValue isEqualToString:defaultSpec]) {
                            //遍历的遇到的btn 是 默认规格选择的 btn
                            [self didClickSpecBtn:btn withCallBack:NO];//选中它。不仅仅是set 其 specState，还要同时设置其他btn的state
                            break;//这个section只选一个规格，继续下一个section
                        }
                    }
                }
            }
            
        }
    }
}

@end
