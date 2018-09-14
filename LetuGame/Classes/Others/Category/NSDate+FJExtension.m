//
//  NSDate+FJExtension.m
//  LetuGame
//
//  Created by  admin on 18/5/17.
//  Copyright © 2018年  admin. All rights reserved.
//

#import "NSDate+FJExtension.h"

@implementation NSDate (FJExtension)

- (NSDateComponents *)deltaFrom:(NSDate *)from {

    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:from toDate:self options:0];
}

- (BOOL)isThisYear {
    
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    
    return nowYear == selfYear;
}

- (BOOL)isToday {
    /*
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year && nowCmps.month == selfCmps.month && nowCmps.day == selfCmps.day;
     */
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *nowTime = [fmt stringFromDate:[NSDate date]];
    NSString *selfTime = [fmt stringFromDate:self];
    
    return [nowTime isEqualToString:selfTime];
}

- (BOOL)isYesterday {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *nowTime = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfTime = [fmt dateFromString:[fmt stringFromDate:self]];
    
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *cmps = [calendar components:unit fromDate:selfTime toDate:nowTime options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}

- (NSString *)formatString:(NSString *)formatter
{
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.timeZone = [NSTimeZone systemTimeZone];
    fmt.dateFormat = formatter;
    
    return [fmt stringFromDate:self];
}

- (NSDate*)firstDayOfCurrentMonth
{
    double interval = 0;
    NSDate *firstDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&firstDate interval:&interval forDate:self];
    
    return firstDate;
    
    //转换时区
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    interval = [zone secondsFromGMTForDate: firstDate];
//    NSDate *localeDate = [firstDate  dateByAddingTimeInterval: interval];
//    return localeDate;
}

- (NSDate*)lastDayOfCurrentMonth
{
    NSDate *newDate=self;
    double interval = 0;
    NSDate *firstDate = nil;
    NSDate *lastDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    BOOL OK = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&firstDate interval:&interval forDate:newDate];
    
    if (OK) {
        lastDate = [firstDate dateByAddingTimeInterval:interval - 1];
    }
    
    return lastDate;
    
    //转换时区
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    interval = [zone secondsFromGMTForDate: lastDate];
//    NSDate *localeDate = [lastDate  dateByAddingTimeInterval: interval];
//
//    return localeDate;
}

+ (NSDate*)dateFromComponents:(NSDateComponents*)dateComponents
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
+ (BOOL)leapYear:(NSInteger)year
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
