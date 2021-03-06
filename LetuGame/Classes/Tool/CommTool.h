//
//  CommTool.h
//  LetuGame
//
//  Created by admin on 18/7/13.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommTool : NSObject

/**
 弹出登录界面
 */
+ (BOOL)isLogined;

/**
 弹出登录界面
 */
+ (void)showLoginPageWithNavVC:(UINavigationController*)navVC;

/**
 发送“我要玩”请求
 */
+ (void)wantPlayGame:(NSString*)gameId;

/**
 构建导航栏按钮（如：“我要玩”）
 */
+ (UIButton*)wantPlayGameButtonWithTitle:(NSString*)title image:(NSString*)image Target:(id)target Action:(SEL)action;

/**
 构建导航栏“我要玩”按钮
 */
+ (UIButton*)wantPlayGameButtonWithTarget:(id)target Action:(SEL)action;

/**
 构建导航栏写攻略“提交”按钮
 */
+ (UIButton*)submitButtonWithTarget:(id)target Action:(SEL)action;

/**
 构建导航栏写攻略“插入图片”按钮
 */
+ (UIButton*)insertImageWithTarget:(id)target Action:(SEL)action;

/**
 获得view所在的控制器
 */
+ (UIViewController*)getViewControllerOfView:(UIView*)view;

/**
 安全化字符串，nil转为@""
 */
+ (NSString*)safeString:(NSString*)srcString;

/**
 计算单行文字的size
 */
+ (CGSize)sizeWithText:(NSString *)text withFont:(UIFont *)font;

/**
 计算多行文字的CGRect
 */
+ (CGRect)boundingRectWithString:(NSString *)str withSize:(CGSize)size withFont:(UIFont *)font;

/**
 获取两个日期间隔分钟数
 */
+ (NSInteger)timeIntervalOfTwoData:(NSDate*)startDate endDate:(NSDate*)endDate;

/**
 获取文件路径
 */
+ (NSString*)pathForFileName:(NSString*)filename ofType:(NSString*)type;

/**
 获取文件内容
 */
+ (NSString*)contentForFileName:(NSString*)filename ofType:(NSString*)type;

/**
 *  获取当前的keyWindow
 */
+ (UIWindow*)getCurrentWindow;

/**
 *  获取当前keyWindow的rootViewController
 */
+ (UIViewController*)getCurrentWindowRootVC;

@end
