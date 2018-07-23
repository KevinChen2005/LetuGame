//
//  FJNavigationController.m
//  LetuGame
//
//  Created by  admin on 18/5/5.
//  Copyright © 2018年  admin. All rights reserved.
//

#import "FJNavigationController.h"

@interface FJNavigationController ()

@end

@implementation FJNavigationController

/**
 *  第一次使用调用一次
 */
+ (void)initialize
{
    // 设置导航图片
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = nil;
}

// 拦截push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count > 0) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -18, 0, 0);
        [button.titleLabel setFont:FJNavbarItemFont];
        // 颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"nav_back_arrow"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"nav_back_arrow"] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

@end
