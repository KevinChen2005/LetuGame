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
    fmt.dateFormat = formatter;
    
    return [fmt stringFromDate:self];
}

- (NSDate*)firstDayOfCurrentMonth
{
    double interval = 0;
    NSDate *firstDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&firstDate interval:&interval forDate:self];
    
    //转换时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    interval = [zone secondsFromGMTForDate: firstDate];
    NSDate *localeDate = [firstDate  dateByAddingTimeInterval: interval];
    
    return localeDate;
}

- (NSDate*)lastDayOfCurrentMonth
{
    NSDate *newDate=self;
    double interval = 0;
    NSDate *firstDate = nil;
    NSDate *lastDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    
    BOOL OK = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&firstDate interval:&interval forDate:newDate];
    
    if (OK) {
        lastDate = [firstDate dateByAddingTimeInterval:interval - 1];
    }
    
    //转换时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    interval = [zone secondsFromGMTForDate: lastDate];
    NSDate *localeDate = [lastDate  dateByAddingTimeInterval: interval];
    
    return localeDate;
}

@end
