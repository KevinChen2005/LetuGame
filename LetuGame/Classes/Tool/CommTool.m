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
        NSString* data = [NSString stringWithFormat:@"%@", retDict[@"data"]];//ios包的下载地址
        if ([code isEqualToString:@"1"]) { //成功
            [self openDownloadUrl:data];
        } else {
            [FJProgressHUB showInfoWithMessage:message withTimeInterval:1.5f];
        }
    } failure:^(NSError *error) {
        DLog(@"wantPlayGame send error - %@", error);
        [FJProgressHUB showInfoWithMessage:@"请求失败！" withTimeInterval:1.5f];
    }];
    
//    [HttpTool wantPlayGameWithId:gameId Success:^(id retObj) {
//        DLog(@"wantPlayGame send retObj - %@", retObj);
//        NSDictionary* retDict = retObj;
//        NSString* code = [NSString stringWithFormat:@"%@", retDict[@"code"]];
//        NSString* message = [NSString stringWithFormat:@"%@", retDict[@"message"]];
//        if ([code isEqualToString:@"1"]) { //成功
//            [FJProgressHUB showInfoWithMessage:@"请求成功，游戏信息将以短信形式下发，请注意查收！" withTimeInterval:3.0f];
//        } else {
//            [FJProgressHUB showInfoWithMessage:message withTimeInterval:1.5f];
//        }
//    } failure:^(NSError *error) {
//        DLog(@"wantPlayGame send error - %@", error);
//        [FJProgressHUB showInfoWithMessage:@"请求失败！" withTimeInterval:1.5f];
//    }];
}

+ (void)openDownloadUrl:(NSString*)url
{
    [FJPopView showConfirmViewWithTitle:@"温馨提示" message:@"是否前往浏览器打开游戏下载页面？" okTitle:@"前往" cancelTitle:@"取消" okBlock:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    } cancelBlock:nil];
}

+ (UIButton*)wantPlayGameButtonWithTitle:(NSString*)title image:(NSString*)image Target:(id)target Action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setTitleColor:FJWhiteColor forState:UIControlStateNormal];
    [button sizeToFit];
    [button.titleLabel setFont:FJNavbarItemFont];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button setImageEdgeInsets:UIEdgeInsetsMake(-16, 35, 0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -16, 0)];
    
    return button;
}

+ (UIButton*)wantPlayGameButtonWithTarget:(id)target Action:(SEL)action
{
    return [self wantPlayGameButtonWithTitle:@"我要玩" image:@"tu_ic_woyaowan" Target:target Action:action];
}

+ (UIButton*)submitButtonWithTarget:(id)target Action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"tu_ic_tijiao"] forState:UIControlStateNormal];
    [button setTitleColor:FJWhiteColor forState:UIControlStateNormal];
    [button sizeToFit];
    [button.titleLabel setFont:FJNavbarItemFont];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button setImageEdgeInsets:UIEdgeInsetsMake(-16, 25, 0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -16, 0)];
    button.frame = CGRectMake(0, 0, 50, 45);
    
    return button;
    
//    return [self wantPlayGameButtonWithTitle:@"提交" image:@"tu_ic_tijiao" Target:target Action:action];
}

+ (UIButton*)insertImageWithTarget:(id)target Action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"插入图片" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"tu_ic_charutupian"] forState:UIControlStateNormal];
    [button setTitleColor:FJWhiteColor forState:UIControlStateNormal];
    [button sizeToFit];
    [button.titleLabel setFont:FJNavbarItemFont];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button setImageEdgeInsets:UIEdgeInsetsMake(-20, 35, 0, -10)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -16, -18)];
    button.frame = CGRectMake(0, 0, 60, 40);
    
    return button;
    
//    return [self wantPlayGameButtonWithTitle:@"插入图片" image:@"tu_ic_charutupian" Target:target Action:action];
}

+ (NSInteger)timeIntervalOfTwoData:(NSDate*)startDate endDate:(NSDate*)endDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitMinute;//只计算分
    NSDateComponents *compas = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    
    NSLog(@"minute = %ld", (long)compas.minute);
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

/**
 *  获取当前的keyWindow
 */
+ (UIWindow*)getCurrentWindow
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    if (window && window.windowLevel == UIWindowLevelNormal) {
        return window;
    }
    
    NSArray* windows = [[UIApplication sharedApplication] windows];
    for (UIWindow* w in windows) {
        if (w.windowLevel == UIWindowLevelNormal) {
            window = w;
            break;
        }
    }
    
    return window;
}

/**
 *  获取当前keyWindow的rootViewController
 */
+ (UIViewController*)getCurrentWindowRootVC
{
    return [self getCurrentWindow].rootViewController;
}

@end
