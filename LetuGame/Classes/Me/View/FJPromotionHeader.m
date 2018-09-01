//
//  FJPromotionHeader.m
//  LetuGame
//
//  Created by admin on 2018/7/30.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJPromotionHeader.h"
#import "PGDatePickManager.h"

@interface FJPromotionHeader() <PGDatePickerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnSelectDate; // 日期选择按钮

@property (strong, nonatomic) NSDate* selectedDate; //选择的日期期（DateComponents）

@end

@implementation FJPromotionHeader

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectedDate = [NSDate date]; //初始化选择日期为now
    
    NSString* infoEnd = [self.selectedDate formatString:@"yyyy-MM"];
    [self.btnSelectDate setTitle:infoEnd forState:UIControlStateNormal];
}

+ (instancetype)header
{
    return [[[NSBundle mainBundle]loadNibNamed:@"FJPromotionHeader" owner:nil options:nil] firstObject];
}

- (IBAction)onClickSelectDate:(id)sender
{
    [self showDatePickerWithTitle:@"选择查询月份" defaultDate:self.selectedDate];
}

- (void)showDatePickerWithTitle:(NSString*)title defaultDate:(NSDate*)defaultDate
{
    //弹出日期选择器
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackgroud = true;
    datePickManager.style = PGDatePickManagerStyle1;
    datePickManager.titleLabel.text = title;//;
    
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGPickerViewType1;
    datePicker.datePickerMode = PGDatePickerModeYearAndMonth;
    datePicker.maximumDate = [NSDate date];
    [datePicker setDate:defaultDate];
    
    UIViewController* rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC presentViewController:datePickManager animated:false completion:nil];
}

- (IBAction)onClickSearch:(id)sender
{
    NSDate* beginDate = [self.selectedDate firstDayOfCurrentMonth];
    NSDate* endDate = [self.selectedDate lastDayOfCurrentMonth];
    
    // 回调选择的起始/结束时间
    if ([self.delegate respondsToSelector:@selector(promotionHeader:onClickSearchWithBeginDate:endDate:)]) {
        [self.delegate promotionHeader:self onClickSearchWithBeginDate:beginDate endDate:endDate];
    }
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents
{
    NSString* info = [NSString stringWithFormat:@"%ld-%02ld", (long)dateComponents.year, (long)dateComponents.month];
    [self.btnSelectDate setTitle:info forState:UIControlStateNormal];
    
    self.selectedDate = [self dateFromComponents:dateComponents];
    NSLog(@"selectedDate = %@", self.selectedDate);
}

- (NSDate*)dateFromComponents:(NSDateComponents*)dateComponents
{
    NSDateComponents* components = dateComponents;
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone systemTimeZone];
    
    if (components.month == 4 || components.month == 6 ||
        components.month == 9 || components.month == 11) {
        if (components.day >= 31) {
            components.day = 30;
        }
    } else if (components.month == 2) {
        if ([self leapYear:components.year] == YES && components.day >= 30) {
            components.day = 29;
        }
        
        if ([self leapYear:components.year] == NO && components.day >= 29) {
            components.day = 28;
        }
    } else {
        if (components.day >= 32) {
            components.day = 31;
        }
    }
    
    return [calendar dateFromComponents:dateComponents];
}

// 判断闰年
- (BOOL)leapYear:(NSInteger)year
{
    if (year <= 0 || year >= 9999) {
        return NO;
    }
    
    if ((year%4 == 0 && year % 100 !=0) || year%400==0) {
        return YES;
    }else {
        return NO;
    }
    
    return NO;
}

@end

