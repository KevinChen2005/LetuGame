//
//  FJProgressHUB.m
//  LetuGame
//
//  Created by admin on 2018/7/13.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJProgressHUB.h"

#import "SVProgressHUD.h"

@implementation FJProgressHUB

+ (void)setStyle
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
}

+ (void)showWithMessage:(NSString*)message
{
    [self setStyle];
    [SVProgressHUD showWithStatus:message];
}

+ (void)showWithMaskMessage:(NSString *)message
{
    [self setStyle];
    [SVProgressHUD showWithStatus:message];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

+ (void)dismiss
{
    [SVProgressHUD dismiss];
}

+ (void)showWithMessage:(NSString*)message withTimeInterval:(CGFloat)time
{
    [self setStyle];
    [SVProgressHUD setMinimumDismissTimeInterval:time];
    [SVProgressHUD showWithStatus:message];
    
    [SVProgressHUD dismissWithDelay:time];
}

+ (void)showSuccessWithMessage:(NSString*)message withTimeInterval:(CGFloat)time
{
    [self setStyle];
    [SVProgressHUD setMinimumDismissTimeInterval:time];
    [SVProgressHUD showSuccessWithStatus:message];
    
    [SVProgressHUD dismissWithDelay:time];
}

+ (void)showErrorWithMessage:(NSString*)message withTimeInterval:(CGFloat)time
{
    [self setStyle];
    [SVProgressHUD setMinimumDismissTimeInterval:time];
    [SVProgressHUD showErrorWithStatus:message];
    
    [SVProgressHUD dismissWithDelay:time];
}

+ (void)showInfoWithMessage:(NSString*)message withTimeInterval:(CGFloat)time
{
    [self setStyle];
    [SVProgressHUD setMinimumDismissTimeInterval:time];
    [SVProgressHUD showInfoWithStatus:message];
    
    [SVProgressHUD dismissWithDelay:time];
}

@end
