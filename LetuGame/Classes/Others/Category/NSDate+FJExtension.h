//
//  NSDate+FJExtension.h
//  LetuGame
//
//  Created by  admin on 18/5/17.
//  Copyright © 2018年  admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (FJExtension)

/**
 *  比较from跟self的时间差
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;

/**
 *  是否为今年
 */
- (BOOL)isThisYear;

/**
 *  是否为今天
 */
- (BOOL)isToday;

/**
 *  是否为昨天
 */
- (BOOL)isYesterday;

/**
 格式化输出
 */
- (NSString*)formatString:(NSString*)formatter;

/**
 返回当前月的第一天零点时刻
 */
- (NSDate*)firstDayOfCurrentMonth;

/**
 返回当前月的最后一天最后一秒钟时刻
 */
- (NSDate*)lastDayOfCurrentMonth;

/**
 返回当前月的最后一天最后一秒钟时刻
 */
+ (NSDate*)dateFromComponents:(NSDateComponents*)dateComponents;

@end
