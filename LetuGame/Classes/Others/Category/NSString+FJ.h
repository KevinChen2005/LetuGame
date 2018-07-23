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

@end


