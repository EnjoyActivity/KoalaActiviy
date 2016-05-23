//
//  CHDatePickerView.m
//  test
//
//  Created by liuxu on 15/10/28.
//  Copyright (c) 2015年 liuxu. All rights reserved.
//

#import "CHDatePickerView.h"

@interface CHDatePickerView()<UIPickerViewDelegate,UIPickerViewDataSource> {
    NSNumber* _currentYearNum;
    NSNumber* _nextYearNum;
    NSNumber* _thirdYearNum;
}

@property(nonatomic, strong)NSArray* years;
@property(nonatomic, strong)NSArray* months;
@property(nonatomic, strong)NSMutableArray* days;
@property(nonatomic, strong)NSArray* hours;
@property(nonatomic, strong)NSArray* minutes;
@property(nonatomic, strong)UIPickerView* pickView;
@property(nonatomic, strong)UIView* bgView;
@property(nonatomic, weak)UIView* superView;
@property(nonatomic, copy)completeDateInt intBlock;
@property(nonatomic, copy)completeDateStr strBlock;

@end

@implementation CHDatePickerView

- (void)dealloc {
    self.years  = nil;
    self.months = nil;
    self.days   = nil;
    self.hours  = nil;
    self.minutes = nil;
    self.pickView = nil;
    self.intBlock = nil;
    self.strBlock = nil;
}

- (id)initWithSuperView:(UIView*)superView
        completeDateInt:(completeDateInt)intBlock
        completeDateStr:(completeDateStr)strBlock {
    CGRect frame = CGRectMake(0, superView.frame.size.height, superView.bounds.size.width, 225);
    self = [super initWithFrame:frame];
    if (self) {
        [self initDatas];
        self.superView = superView;
        self.intBlock  = intBlock;
        self.strBlock  = strBlock;
        
        //设置蒙板
        self.bgView = [[UIView alloc]initWithFrame:self.superView.bounds];
        self.bgView.backgroundColor = [UIColor blackColor];
        self.bgView.alpha = 0.2;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
        [tapGes addTarget:self action:@selector(closeView)];
        [self.bgView addGestureRecognizer:tapGes];
        [self.superView addSubview:self.bgView];
        
        //设置背景色
        NSInteger rgbValue = 0xd0d0d0;
        UIColor* color = [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
        self.backgroundColor = color;
        
        //上部pickerView
        self.pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-60)];
        self.pickView.delegate = self;
        self.pickView.dataSource = self;
        self.pickView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.pickView];
        
        //下部button
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, frame.size.height-45, frame.size.width, 45)];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        rgbValue = 0xff615d;
        color = [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
        [btn setTitleColor:color forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.0];
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        //设置初始时选中当前时间
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        comps = [calendar components:unitFlags fromDate:[NSDate date]];

        long month  = [comps month];
        long day    = [comps day];
        long hour   = [comps hour];
        long minute = [comps minute];
        UILabel* label = nil;
        [self.pickView selectRow:0 inComponent:0 animated:NO];          //年
        label = (UILabel*)[self.pickView viewForRow:0 forComponent:0];
        label.textColor = [UIColor redColor];
        
        [self.pickView selectRow:month-1 inComponent:1 animated:NO];    //月
        label = (UILabel*)[self.pickView viewForRow:month-1 forComponent:1];
        label.textColor = [UIColor redColor];
        
        [self.pickView selectRow:day-1 inComponent:2 animated:NO];      //日
        label = (UILabel*)[self.pickView viewForRow:day-1 forComponent:2];
        label.textColor = [UIColor redColor];
        
        [self.pickView selectRow:hour inComponent:3 animated:NO];       //时
        label = (UILabel*)[self.pickView viewForRow:hour forComponent:3];
        label.textColor = [UIColor redColor];
        
        [self.pickView selectRow:minute inComponent:4 animated:NO];     //分
        label = (UILabel*)[self.pickView viewForRow:minute forComponent:4];
        label.textColor = [UIColor redColor];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, superView.frame.size.height-225, superView.frame.size.width, 225);
    }];
    
    return self;
}

- (void)initDatas {
    //年（今、明、后）
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps  = [calendar components:NSYearCalendarUnit fromDate:[NSDate date]];
    _currentYearNum = [NSNumber numberWithInteger:comps.year];
    _nextYearNum = [NSNumber numberWithInteger:comps.year+1];
    _thirdYearNum = [NSNumber numberWithInteger:comps.year+2];
    NSString* Current = [[NSString alloc]initWithFormat:@"%@年", _currentYearNum];
    NSString* next = [[NSString alloc]initWithFormat:@"%@年", _nextYearNum];
    NSString* third = [[NSString alloc]initWithFormat:@"%@年", _thirdYearNum];
    _years = @[Current, next, third];
    
    //月
    NSMutableArray* temps = [NSMutableArray array];
    for (int i=1; i<=12; i++) {
        NSString* str = nil;
        if (i < 10) {
            str = [[NSString alloc]initWithFormat:@"0%d月", i];
        }
        else {
            str = [[NSString alloc]initWithFormat:@"%d月", i];
        }
        [temps addObject:str];
    }
    _months = [[NSArray alloc]initWithArray:temps];

    //时
    temps = nil;
    temps = [NSMutableArray array];
    for (int i=0; i<=23; i++) {
        NSString* str = nil;
        if (i < 10) {
            str = [[NSString alloc]initWithFormat:@"0%d时", i];
        }
        else {
            str = [[NSString alloc]initWithFormat:@"%d时", i];
        }
        [temps addObject:str];
    }
    _hours = [[NSArray alloc]initWithArray:temps];
    
    //分
    temps = nil;
    temps = [NSMutableArray array];
    for (int i=0; i<=59; i++) {
        NSString* str = nil;
        if (i < 10) {
            str = [[NSString alloc]initWithFormat:@"0%d分", i];
        }
        else {
            str = [[NSString alloc]initWithFormat:@"%d分", i];
        }
        [temps addObject:str];
    }
    _minutes = [[NSArray alloc]initWithArray:temps];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    UILabel* itemView = (UILabel*)[self.pickView viewForRow:row forComponent:component];
    itemView.textColor = [UIColor redColor];
    itemView.font = [UIFont systemFontOfSize:18.0];
    itemView.text = [self getCurrentItemText:row Component:component];
    NSInteger rgbValue = 0xff615d;
    itemView.textColor = [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
    
    if (component == 0 || component == 1) {
        //刷新月
        _days = nil;
        [self.pickView reloadComponent:2];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor greenColor];
    label.text = [self getCurrentItemText:row Component:component];
    label.font = [UIFont systemFontOfSize:15.0];
    NSInteger rgbValue = 0x535353;
    label.textColor = [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];

    return label;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 5;   //年、月、日、时、分
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger count = 0;
    switch (component) {
        case 0: //年
            count = _years.count;
            break;
        case 1: //月
            count = _months.count;
            break;
        case 2: //日
        {
            _days = [NSMutableArray array];
            int year = 0;
            int month = 0;
            NSInteger yearTemp = [self.pickView selectedRowInComponent:0];
            NSInteger monthTemp = [self.pickView selectedRowInComponent:1];
            if (yearTemp == 0) {
                year = _currentYearNum.intValue;
            }
            else if (yearTemp == 1) {
                year = _nextYearNum.intValue;
            }
            else {
                year = _thirdYearNum.intValue;
            }
            month = (int)monthTemp + 1;
            int totalDays = [self howManyDaysInThisMonth:year month:month];
            for (int i=1; i<=totalDays; i++) {
                NSString* str = nil;
                if (i < 10) {
                    str = [[NSString alloc]initWithFormat:@"0%d日", i];
                }
                else {
                    str = [[NSString alloc]initWithFormat:@"%d日", i];
                }
                [_days addObject:str];
            }
            count = _days.count;
        }
            break;
        case 3: //时
            count = _hours.count;
            break;
        case 4: //分
            count = _minutes.count;
            break;
        default:
            break;
    }
    
    return count;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self getCurrentItemText:row Component:component];
}

- (int)howManyDaysInThisMonth:(int)year month:(int)imonth {
    if ((imonth == 1) || (imonth == 3) || (imonth == 5)  ||
        (imonth == 7) || (imonth == 8) || (imonth == 10) ||
        (imonth == 12)) {
        return 31;
    }
    if ((imonth == 4) || (imonth == 6) || (imonth == 9) || (imonth == 11)) {
        return 30;
    }
    if ((year%4 == 1) || (year%4 == 2) || (year%4 == 3)) {
        return 28;
    }
    if (year%400 == 0) {
        return 29;
    }
    if (year%100 == 0) {
        return 28;
    }
    
    return 29;
}

- (NSString*)getCurrentItemText:(NSInteger)row Component:(NSInteger)component {
    NSString* str = nil;
    switch (component) {
        case 0: //年
            str = [_years objectAtIndex:row];
            break;
        case 1: //月
            str = [_months objectAtIndex:row];
            break;
        case 2: //日
            str = [_days objectAtIndex:row];
            break;
        case 3: //时
            str = [_hours objectAtIndex:row];
            break;
        case 4: //分
            str = [_minutes objectAtIndex:row];
            break;
        default:
            break;
    }
    
    return str;
}

- (void)btnClicked {
    int year = 0;
    int month = 0;
    int day = 0;
    int hours = 0;
    int minute = 0;
    
    NSMutableString* resultStr = [[NSMutableString alloc]init];
    NSInteger yearTemp = [self.pickView selectedRowInComponent:0];
    resultStr = [resultStr stringByAppendingString:[_years objectAtIndex:yearTemp]];
    
    NSInteger monthTemp = [self.pickView selectedRowInComponent:1];
    resultStr = [resultStr stringByAppendingString:[_months objectAtIndex:monthTemp]];
    
    if (yearTemp == 0) {
        year = _currentYearNum.intValue;
    }
    else if (yearTemp == 1) {
        year = _nextYearNum.intValue;
    }
    else {
        year = _thirdYearNum.intValue;
    }
    
    month = (int)monthTemp + 1;
    
    NSInteger dayTemp = [self.pickView selectedRowInComponent:2];
    NSMutableString* str = [_days objectAtIndex:dayTemp];
    resultStr = [resultStr stringByAppendingString:str];
    resultStr = [resultStr stringByAppendingString:@" "];
    
    NSMutableString* temp = (NSMutableString*)[str substringToIndex:str.length-1];
    day = [temp intValue];
    
    NSInteger hoursTemp = [self.pickView selectedRowInComponent:3];
    str = [_hours objectAtIndex:hoursTemp];
    temp = (NSMutableString*)[str substringToIndex:str.length-1];
    resultStr = [resultStr stringByAppendingString:temp];
    resultStr = [resultStr stringByAppendingString:@":"];
    hours = [temp intValue];
    
    NSInteger minuteTemp = [self.pickView selectedRowInComponent:4];
    str = [_minutes objectAtIndex:minuteTemp];
    temp = (NSMutableString*)[str substringToIndex:str.length-1];
    resultStr = [resultStr stringByAppendingString:temp];
    minute = [temp intValue];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, self.superView.frame.size.height, self.superView.frame.size.width, 225);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.bgView removeFromSuperview];
        if (self.intBlock) {
            self.intBlock(year, month, day, hours, minute);
        }
        if (self.strBlock) {
            self.strBlock(resultStr);
        }
    }];
}

- (void)closeView {
    if (self.cancelSeleteDate) {
        self.cancelSeleteDate(YES);
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, self.superView.frame.size.height, self.superView.frame.size.width, 225);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.bgView removeFromSuperview];
    }];
}

@end
