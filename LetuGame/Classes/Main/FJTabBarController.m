//
//  FJTabBarController.m
//  LetuGame
//
//  Created by  admin on 18/5/4.
//  Copyright © 2018年  admin. All rights reserved.
//

#import "FJTabBarController.h"
#import "FJNavigationController.h"
#import "FJMeViewController.h"
#import "FJHomeViewController.h"
#import "FJGameViewController.h"
#import "FJTabBar.h"

@interface FJTabBarController() <FJTabBarDelegate>

@end

@implementation FJTabBarController

/**
 *  第一次使用调用一次
 */
+ (void)initialize {
    
    UITabBarItem *item = [UITabBarItem appearance];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    //    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

/**
 *  添加子控制器
 *
 *  @param viewController    控制器
 *  @param title             标题
 *  @param name              图片名字
 */
- (void)addChildController:(UIViewController *)viewController withTitle:(NSString *)title withName:(NSString *)name
{
    viewController.title = title;
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"tabBar_%@_icon", name]];
   viewController.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabBar_%@_click_icon", name]];
    
    // 添加导航控制器
    FJNavigationController *nav = [[FJNavigationController alloc] initWithRootViewController:viewController];
    
    [self addChildViewController:nav];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 添加子控制器
    [self addChildController:[[FJHomeViewController alloc] init] withTitle:@"首页" withName:@"home"];

    [self addChildController:[[FJGameViewController alloc] init] withTitle:@"游戏" withName:@"game"];

    [self addChildController:[[FJMeViewController alloc] initWithStyle:UITableViewStyleGrouped] withTitle:@"我的" withName:@"me"];
    
    // 更换tabBar
    FJTabBar* tabBar = [[FJTabBar alloc] init];
    tabBar.delegate = self;
    [self setValue:tabBar forKey:@"tabBar"];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (iphoneX) { //适配iPhone X 的图标/title位置
        for (UITabBarItem *item in self.tabBar.items) {
            item.imageInsets = UIEdgeInsetsMake(-15, 0, 15, 0);
            [item setTitlePositionAdjustment:UIOffsetMake(0, -34)];
        }
    }
}

#pragma mark - FJTabBarDelegate
- (void)fj_tabBar:(FJTabBar *)tabBar didSelectedItemIndex:(NSInteger)index
{
//    NSLog(@"fj_tabBar didSelectedItemIndex %ld", (long)index);
}

-(BOOL)prefersHomeIndicatorAutoHidden
{
    return YES;
}





@end
