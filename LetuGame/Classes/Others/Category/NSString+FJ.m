//
//  NSString+FJ.m
//  LetuGame
//
//  Created by admin on 2018/7/13.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "NSString+FJ.h"

@implementation NSString (FJ)

- (BOOL)isNullString
{
    if (self == nil || [self isEqualToString:@""]) {
        return YES;
    }
    
    NSString* temp = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([temp isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isRegularString:(NSString*)regular
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regular options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    if (result) {
        return YES;
    } else {
        return NO;
    }
}

- (NSArray*)resultForRegularString:(NSString*)regular
{
    return nil;
}

- (BOOL)isPhoneNumber
{
    if (self.length != 11) {
        return NO;
    }
    
    NSString* regular = @"^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199|(147))\\d{8}$";
    
    return [self isRegularString:regular];
}

- (BOOL)isPasswordValid
{
    return (self.length >= 6 && self.length <= 18);
}

- (BOOL)isNicknameValid
{
    return (self.length >= 1 && self.length <= 20);
}

- (BOOL)isAuthcodeValid
{
    return (self.length >= 1 && self.length <= 6);
}

- (NSString *)timeFormat
{
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime =[self floatValue]/1000;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:createTime];
    
    //秒转分钟
    NSInteger small = time / 60;
    if (small == 0 || time <= 0) { //time <= 0 的情况可能是服务器创建时间比客户端时间快
        return [NSString stringWithFormat:@"刚刚"];
    }
    
    if (small < 60) {
        return [NSString stringWithFormat:@"%ld分钟前",(long)small];
    }
    
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",(long)hours];
    }
    
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前",(long)days];
    }
    
    //秒转月
    NSInteger months = time/3600/24/30;
    if (months < 12) {
//        [df setDateFormat:@"yyyy-MM-dd"];
//        return [df stringFromDate:beDate];
        
        return [NSString stringWithFormat:@"%ld月前",(long)months];
    }
    
    //秒转年
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld年前",(long)years];
}



@end
