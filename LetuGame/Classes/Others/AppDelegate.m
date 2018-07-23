//
//  AppDelegate.m
//  LetuGame
//
//  Created by admin on 2018/7/5.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "AppDelegate.h"
#import "FJTabBarController.h"
#import "IQKeyboardManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // 创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    // 设置窗口的根控制器
    self.window.rootViewController = [[FJTabBarController alloc] init];
    
    // 显示窗口
    [self.window makeKeyAndVisible];
    
    // 开启自动键盘适应
    [IQKeyboardManager sharedManager].enable = YES;
    // 键盘弹出时，点击背景，键盘收回
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    // 启动时检查登录是否过期
    if ([UserAuth shared].isLogin) {
        [HttpTool verifyLoginStateSuccess:^(id retObj) {
            DLog(@"verifyLoginState success retObj = %@", retObj);
            NSDictionary* retDict = retObj;
            NSString* code = [NSString stringWithFormat:@"%@", retDict[@"code"]];
            if ([code isEqualToString:@"1"] == NO) { //1 token有效，其他为无效需删除本地登录状态，重新登录
                [UserAuth clean]; //删除登录状态
            }
        } failure:^(NSError *error) {
            DLog(@"verifyLoginState failed - %@", error);
        }];
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
