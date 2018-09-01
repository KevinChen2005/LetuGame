//
//  FJPromotion.m
//  LetuGame
//
//  Created by admin on 2018/7/31.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJPromotion.h"

@implementation FJPromotion

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id",
             };
}

- (void)setEndDate:(NSDate *)endDate
{
    _endDate = endDate;
    
    _promotionMonth = [endDate formatString:@"yyyy-MM"];
}

- (void)setStartDate:(NSDate *)startDate
{
    _startDate = startDate;
    
//    _promotionMonth = [startDate formatString:@"yyyy-MM"];
}

- (NSString *)promotionMonth
{
    if (_promotionMonth == nil) {
        _promotionMonth = @"";
    }
    
    return _promotionMonth;
}

@end
