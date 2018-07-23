//
//  MACMacro.h
//
//  Created by admin on 18/7/22.
//  Copyright © 2018年 admin. All rights reserved.
//

#ifndef MACMacro_h
#define MACMacro_h

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d]: " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

//-------------------网络控制----------------
#define DevelopSever    0
#define TestSever       1
#define ProductSever    0

#if DevelopSever
/**开发服务器*/
#define URL_MAIN @"http://192.168.5.168:8000/GameSales"
#elif TestSever
/**测试服务器*/
#define URL_MAIN @"http://59.111.103.96:8000/GameSales"
#elif ProductSever
/**生产服务器*/
#define URL_MAIN @"http://59.111.103.96:8000/GameSales"
#endif
#define kUrl(sub) [NSString stringWithFormat:@"%@/%@", URL_MAIN, sub]

//-------------------颜色和字体----------------
#define FJRGBColor(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1]
#define FJGlobalBG FJRGBColor(245, 245, 245)

#define FJNavbarItemFont [UIFont systemFontOfSize:15]

//-------------------系统----------------
#pragma mark - 系统
//当前系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//版本判断语句,是否是version以后的
#define IOS(version) (([[[UIDevice currentDevice] systemVersion] intValue] >= version)?1:0)

//获取当前语言
#define CurrentLanguage [[NSLocale preferredLanguages]objectAtIndex:0]

//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
//-------------------系统----------------
//系统版本
#define IS_IOS_VERSION   floorf([[UIDevice currentDevice].systemVersion floatValue]
#define IS_IOS_5    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==5.0 ? 1 : 0
#define IS_IOS_6    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==6.0 ? 1 : 0
#define IS_IOS_7    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==7.0 ? 1 : 0
#define IS_IOS_8    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==8.0 ? 1 : 0
#define IS_IOS_9    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==9.0 ? 1 : 0
#define IS_IOS_10   floorf([[UIDevice currentDevice].systemVersion floatValue]) ==10.0 ? 1 : 0
#define IS_IOS_11   floorf([[UIDevice currentDevice].systemVersion floatValue]) ==11.0 ? 1 : 0

//-------------------设备相关----------------
#pragma mark - 设备相关
//判断是什么大小的机型 4，4s ; 5,5s ; 6,6s ; 6+,6+s ; iphoneX
#define iphone4s CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen]currentMode].size)
#define iphone5 CGSizeEqualToSize(CGSizeMake(640,1136), [[UIScreen mainScreen]currentMode].size)
#define iphone6 CGSizeEqualToSize(CGSizeMake(750,1334), [[UIScreen mainScreen]currentMode].size)
#define iphone6Plus CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen]currentMode].size)
#define iphoneX CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size)

//获取屏幕宽度、高度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define ToolBarHeigth 44

//获取状态栏和导航栏高度

#define appStatusBarHeight  [UIApplication sharedApplication].statusBarFrame.size.height

#define appNavigationBarHeight  self.navigationController.navigationBar.frame.size.height

//-------------------设备相关----------------

//-----------------警告处理----------------
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
//-----------------警告处理----------------

#endif /* MACMacro_h */

