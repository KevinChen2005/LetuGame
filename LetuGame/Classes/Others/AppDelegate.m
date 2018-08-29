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

@property (nonatomic, strong)UIView* launchView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // 创建窗口、设置窗口的根控制器
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.rootViewController = [[FJTabBarController alloc] init];
    
    // 显示窗口
    [self.window makeKeyAndVisible];
    
    // 设置IQkeyBoard
    [self setIQkeyBoardConfig];
    
    //加入网络状态监听
    [self startNetworkMonitor];
    
    // 启动时检查登录是否过期
    [self checkLoginState];
    
    // 启动时检查版本更新
    [self checkAppVersion];
    
    //加载闪屏动画(广告)
    [self launchAnimation];
    
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

#pragma mark - 设置IQkeyBoard
- (void)setIQkeyBoardConfig
{
    // 开启自动键盘适应
    [IQKeyboardManager sharedManager].enable = YES;
    // 键盘弹出时，点击背景，键盘收回
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

#pragma mark - 监听网络状态
- (void)startNetworkMonitor
{
    [HttpTool networkStatusWithBlock:^(FJNetworkStatusType networkStatus) {
        switch (networkStatus) {
            case FJNetworkStatusNotReachable:
                [self showHubMessage:@"无网络"];
                break;
            case FJNetworkStatusReachableViaWWAN:
//                [self showHubMessage:@"已切换到手机数据网络"];
                break;
            case FJNetworkStatusReachableViaWiFi:
//                [self showHubMessage:@"已切换到Wi-Fi网络"];
                break;
            default:
//                [self showHubMessage:@"未知网络"];
                break;
        }
    }];
}

- (void)showHubMessage:(NSString*)message
{
    if ([NSThread isMainThread]) {
        [FJProgressHUB showInfoWithMessage:message withTimeInterval:kTimeHubInfo];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [FJProgressHUB showInfoWithMessage:message withTimeInterval:kTimeHubInfo];
        });
    }
}

#pragma mark - 判断登录状态
- (void)checkLoginState
{
    if ([UserAuth shared].isLogin == NO) {
        return;
    }
    
    [HttpTool verifyLoginStateSuccess:^(id retObj) {
        DLog(@"verifyLoginState success retObj = %@", retObj);
        NSDictionary* retDict = retObj;
        NSString* code = [NSString stringWithFormat:@"%@", retDict[@"code"]];
        if ([code isEqualToString:@"1"]) { //1 token有效，其他为无效需删除本地登录状态，重新登录
            UserModel* user = [UserModel mj_objectWithKeyValues:retDict[@"data"]];
            if (user) {
                UserModel* userInfo = [UserAuth shared].userInfo;
                userInfo.userId = user.userId;
                userInfo.phone = user.phone;
                userInfo.nickName = user.nickName;
                userInfo.avatarUrl = user.avatarUrl;
                userInfo.isSpreader = user.isSpreader;
                
                [UserAuth saveUserInfo:userInfo];
            }
        } else {
            [UserAuth clean]; //删除登录状态
        }
    } failure:^(NSError *error) {
        DLog(@"verifyLoginState failed - %@", error);
    }];
}

#pragma mark - 检测版本更新
- (void)checkAppVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //当前版本号
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    [FJVersionCheck shareInstance].currentVersion = currentVersion;;
    
    [HttpTool checkVersionFromAppstoreSuccess:^(id retObj) {
        DLog(@"checkVersionFromAppstoreSuccess retObj = %@", retObj);
        NSDictionary* retDict = retObj;
        NSArray* results = retDict[@"results"];
        if (results && [results isKindOfClass:[NSArray class]] && results.count>0) {
            FJAppModel* app = [FJAppModel mj_objectWithKeyValues:results[0]];
            NSLog(@"version = %@, name = %@", app.version, app.trackName);
            [FJVersionCheck shareInstance].appstoreVerInfo = app;
        }
    } failure:^(NSError *error) {
        DLog(@"检测升级失败，连接超时 - %@", error);
    }];
}

#pragma mark - Private Methods
- (void)launchAnimation
{
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    
    //将闪屏view添加到keyWindow
    UIView *launchView = viewController.view;
    launchView.userInteractionEnabled = YES;
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    [mainWindow addSubview:launchView];
    mainWindow.backgroundColor = [UIColor redColor];
    mainWindow.userInteractionEnabled = YES;
    [launchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(mainWindow);
    }];
    self.launchView = launchView;
    
    //将闪屏图片重新设置约束
    NSArray* subViews = launchView.subviews;
    for (UIView* v in subViews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(launchView);
            }];
        }
    }
    
    //在闪屏view添加跳过按钮
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button.titleLabel setTextAlignment:NSTextAlignmentRight];
    [button setTitle:[NSString stringWithFormat:@"跳过(%d)", kLaunchCountDown] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickSkip) forControlEvents:UIControlEventTouchUpInside];
    [launchView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(launchView).offset(iphoneX?54:30);
        make.right.mas_equalTo(launchView).offset(-20);
        make.width.mas_equalTo(@100);
        make.height.mas_equalTo(@50);
    }];
    [self openCountdown:button launchView:launchView];
    
}

- (void)clickSkip
{
    NSLog(@"skip...");
    [self overShow:self.launchView];
}

- (void)overShow:(UIView*)launchView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            launchView.alpha = 0.0f;
            launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.0f, 2.0f, 1.0f);
        } completion:^(BOOL finished) {
            [launchView removeFromSuperview];
        }];
    });
}

// 开启（跳过）倒计时效果
-(void)openCountdown:(UIButton*)btn launchView:(UIView*)launchView
{
    __block NSInteger time = kLaunchCountDown; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            [self overShow:launchView];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [btn setTitle:[NSString stringWithFormat:@"跳过(%ld)", (long)time] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                btn.userInteractionEnabled = YES;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

@end
