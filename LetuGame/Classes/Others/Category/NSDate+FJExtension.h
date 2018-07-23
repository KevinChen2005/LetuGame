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

@end
