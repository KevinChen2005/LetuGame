//
//  NSString+FJ.h
//  LetuGame
//
//  Created by admin on 2018/7/13.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FJ)

// 是否空字符串
- (BOOL)isNullString;

// 是否满足正则表达式
- (BOOL)isRegularString:(NSString*)regular;

// 正则表达式匹配结果
- (NSArray*)resultForRegularString:(NSString*)regular;

// 是否是电话号码（2018）
- (BOOL)isPhoneNumber;

// 密码是否有效（6-18位）
- (BOOL)isPasswordValid;

// 昵称是否有效（1-20个字符）
- (BOOL)isNicknameValid;

// 验证码是否有效（1-6个字符）
- (BOOL)isAuthcodeValid;

// 格式化时间戳输出
- (NSString *)timeFormat;

//身份证号验证 1900+/2000+的年份日期的正则表达式经过修改
//返回yes位表示格式正确，否则no为错误
-(BOOL)isIDCard;

//银行卡验证
//返回yes位表示格式正确，否则no为错误
- (BOOL)isBankCardNumber;

@end


