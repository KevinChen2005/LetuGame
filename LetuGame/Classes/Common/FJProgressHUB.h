//
//  FJProgressHUB.h
//  LetuGame
//
//  Created by admin on 2018/7/13.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTimeHubInfo 1.5f
#define kTimeHubSuccess 1.5f
#define kTimeHubError 1.5f

@interface FJProgressHUB : NSObject

+ (void)showWithMessage:(NSString*)message;

+ (void)showWithMaskMessage:(NSString *)message;

+ (void)dismiss;

+ (void)showWithMessage:(NSString*)message withTimeInterval:(CGFloat)time;

+ (void)showSuccessWithMessage:(NSString*)message withTimeInterval:(CGFloat)time;

+ (void)showErrorWithMessage:(NSString*)message withTimeInterval:(CGFloat)time;

+ (void)showInfoWithMessage:(NSString*)message withTimeInterval:(CGFloat)time;

@end
