//
//  FJComment.m
//  LetuGame
//
//  Created by admin on 2018/7/9.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJComment.h"

@implementation FJComment

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id"
             };
}

- (void)setCreatetime:(NSString *)createtime
{
    // 时间字符串转日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:createtime];
    
    // 日期转时间戳字符串
    NSString *timeStamp = [NSString stringWithFormat:@"%lld", (long long)[date timeIntervalSince1970]*1000];
    
    // 时间戳字符串转格式化输出
    _createtime = [timeStamp timeFormat];
}

@end
