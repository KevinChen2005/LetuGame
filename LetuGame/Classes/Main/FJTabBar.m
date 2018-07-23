//
//  FJTabBar.m
//  LetuGame
//
//  Created by  admin on 18/5/4.
//  Copyright © 2018年  admin. All rights reserved.
//

#import "FJTabBar.h"
//#import "FJPublishViewController.h"

#define kItemCount 3

@interface FJTabBar ()

@property (nonatomic, weak) UIButton *publishButton; //中间的发布按钮（未启用）

@end

@implementation FJTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 设置tabbar的背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
        
        // 添加按钮
//        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
//        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
//        [publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:publishButton];
//        publishButton.fj_size = publishButton.currentBackgroundImage.size;
//        self.publishButton = publishButton;
    }
    return self;
}

- (void)publishClick
{
//    FJPublishViewController *vc = [[FJPublishViewController alloc] init];
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:NO completion:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 标记按钮是否已经添加过监听器
    static BOOL added = NO;
    
    CGFloat width = self.fj_width;
    CGFloat height = self.fj_height;
    
    // 设置Button的frame
//    self.publishButton.center = CGPointMake(width * 0.5, height * 0.5);
    
    // 设置其他UITabBarButton的frame
    CGFloat buttonY = 0;
    CGFloat buttonW = width / kItemCount;
    CGFloat buttonH = height;
    NSInteger index = 0;
    
    for (UIControl *button in self.subviews) {
        
        if (![button isKindOfClass:[UIControl class]] || button == self.publishButton) {
            continue;
        }
        
        // 计算按钮的x值
        CGFloat buttonX = buttonW * index;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        if (added == NO) {
            // 设置tag
            button.tag = index;
            
            // 监听按钮点击
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        // 增加索引
        index++;
    }
    
    added = YES;
}

- (void)buttonClick:(UIControl*)btn
{
//    NSLog(@"click item %ld", (long)btn.tag);
    // 发通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:FJTabBarDidSelectNotification object:nil userInfo:nil];
    
    NSInteger index = btn.tag;
    
    if ([self.delegate respondsToSelector:@selector(fj_tabBar:didSelectedItemIndex:)]) {
        [self.delegate fj_tabBar:self didSelectedItemIndex:index];
    }
}

@end
