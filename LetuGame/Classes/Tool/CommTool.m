//
//  CommTool.m
//  LetuGame
//
//  Created by admin on 18/7/13.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "CommTool.h"
#import "FJLoginViewController.h"

@implementation CommTool

/**
 弹出登录界面
 */
+ (BOOL)isLogined
{
    return [UserAuth shared].isLogin;
}

/**
 弹出登录界面
 */
+ (void)showLoginPageWithNavVC:(UINavigationController*)navVC
{
    FJLoginViewController* loginVC = [FJLoginViewController new];
    [navVC pushViewController:loginVC animated:YES];
}

/**
 获得view所在的控制器
 */
+ (UIViewController*)getViewControllerOfView:(UIView*)view
{
    id target = view;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            return target;
        }
    }
    return nil;
}

+ (NSString *)safeString:(NSString *)srcString
{
    return srcString==nil ? @"" : srcString;
}

/**
 计算单行文字的size
 
 @parms  文本
 @parms  字体
 
 @return  字体的CGSize
 */

+ (CGSize)sizeWithText:(NSString *)text withFont:(UIFont *)font
{
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    
    return size;
}

/**
 计算多行文字的CGRect
 
 @parms  文本
 @parms  字体
 
 @return  字体的CGRect
 */
+ (CGRect)boundingRectWithString:(NSString *)str withSize:(CGSize)size withFont:(UIFont *)font
{
    CGRect rect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    
    return rect;
}

+ (void)wantPlayGame:(NSString*)gameId
{
    [HttpTool wantPlayGameWithId:gameId Success:^(id retObj) {
        DLog(@"wantPlayGame send retObj - %@", retObj);
        NSDictionary* retDict = retObj;
        NSString* code = [NSString stringWithFormat:@"%@", retDict[@"code"]];
        NSString* message = [NSString stringWithFormat:@"%@", retDict[@"message"]];
        if ([code isEqualToString:@"1"]) { //成功
            [FJProgressHUB showInfoWithMessage:@"请求成功，游戏信息将以短信形式下发，请注意查收！" withTimeInterval:2.0f];
        } else {
            [FJProgressHUB showInfoWithMessage:message withTimeInterval:1.5f];
        }
    } failure:^(NSError *error) {
        DLog(@"wantPlayGame send error - %@", error);
        [FJProgressHUB showInfoWithMessage:@"请求失败！" withTimeInterval:1.5f];
    }];
}

+ (NSInteger)timeIntervalOfTwoData:(NSDate*)startDate endDate:(NSDate*)endDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitMinute;//只计算分
    NSDateComponents *compas = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    
    NSLog(@"minute = %ld", compas.minute);
    return compas.minute;
}

/**
 获取文件路径
 */
+ (NSString*)pathForFileName:(NSString*)filename ofType:(NSString*)type
{
    return [[NSBundle mainBundle] pathForResource:filename ofType:type];
}

/**
 获取文件内容
 */
+ (NSString*)contentForFileName:(NSString*)filename ofType:(NSString*)type
{
    NSString* path = [[NSBundle mainBundle] pathForResource:filename ofType:type];
    
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
}

@end
