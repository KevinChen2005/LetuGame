//
//  FJGameDetailController.m
//  LetuGame
//
//  Created by admin on 2018/7/11.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJGameDetailController.h"
#import "FJGame.h"

@interface FJGameDetailController ()

@end

@implementation FJGameDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.game.title;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    // 右上角“我要玩游戏”
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"我要玩游戏" forState:UIControlStateNormal];
    [button setTitleColor:FJRGBColor(0, 130, 188) forState:UIControlStateNormal];
    [button sizeToFit];
    [button.titleLabel setFont:FJNavbarItemFont];
    [button addTarget:self action:@selector(onClickWantPlay:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView* headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, 80);
    headerView.backgroundColor = [UIColor blueColor];
    self.tableView.tableHeaderView = headerView;
    
    UIView* footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, kScreenWidth, 80);
    footerView.backgroundColor = [UIColor greenColor];
    self.tableView.tableFooterView = footerView;
}

- (void)onClickWantPlay:(id)sender
{
    
}

@end
