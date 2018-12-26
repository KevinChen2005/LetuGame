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

//身份证号验证 1900+/2000+的年份日期的正则表达式经过修改
//返回yes位表示格式正确，否则no为错误
-(BOOL)isIDCard
{
    NSString* value = self;
    
    //stringByTrimmingCharactersInSet ：去除字符串中的特殊字符
    //[NSCharacterSet whitespaceAndNewlineCharacterSet] 空格
    //自定义要去除的特殊字符
    //NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (!value) {
        return NO;
    }
    
    NSInteger length = value.length;
    if (length !=15 && length !=18) {
        return NO;
    }
    
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41",@"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    NSString *valueStart2 = [value substringToIndex:2];
    
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return NO;
    }
    
    //生日部分的编码
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    NSInteger year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(8,2)].intValue +1900;
            if (year %400 ==0 || (year %100 !=0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];//判断出生日期的合法性
            } else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];//判断出生日期的合法性
            }
            
            //numberofMatch:匹配到得字符串的个数
            numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
            if(numberofMatch >0) {
                return YES;
            } else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %400 ==0 || (year %100 !=0 && year %4 ==0)) {
                //原来的@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//判断出生日期的合法性
            } else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//判断出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
            //验证校验位
            if(numberofMatch >0) {
                
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                } else {
                    return NO;
                }
            } else {
                return NO;
            }
        default:
            return NO;
    }
    
    return NO;
}

/*
 银行卡号判断，一般使用了Luhn算法
 Luhn算法步骤：
 1、从卡号的末位开始，逆向将奇数位相加；
 2、从卡号的末位开始，逆向将偶数位先乘2，如果得到的数为两位数则减9，再将得到的数求和；
 3、将奇数位的和与偶数位的和相加得到的数除以10，如果可以被10整除，则这个卡号是合法的。
 */
- (BOOL)isBankCardNumber
{
    NSString* cardNumber = self;
    
    int oddSum = 0;     // 奇数和
    int evenSum = 0;    // 偶数和
    int allSum = 0;     // 总和
    // 循环加和
    for (NSInteger i = 1; i <= cardNumber.length; i++){
        NSString *theNumber = [cardNumber substringWithRange:NSMakeRange(cardNumber.length-i, 1)];
        int lastNumber = [theNumber intValue];
        if (i%2 == 0){
            // 偶数位
            lastNumber *= 2;
            if (lastNumber > 9){
                lastNumber -=9;
            }
            evenSum += lastNumber;
        }
        else{
            // 奇数位
            oddSum += lastNumber;
        }
    }
    allSum = oddSum + evenSum;
    // 是否合法
    if (allSum%10 == 0){
        return YES;
    }
    else{
        return NO;
    }
}

@end
