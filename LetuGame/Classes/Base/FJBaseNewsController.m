//
//  FJBaseNewsController.m
//  LetuGame
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJBaseNewsController.h"
#import "FJDetailViewController.h"
#import "FJNewsCell.h"

@interface FJBaseNewsController()

@property (nonatomic, strong)NSDate* startDate;
@property (nonatomic, strong)NSDate* endDate;

@end

@implementation FJBaseNewsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置标题
    self.navigationItem.title = @"游戏攻略";
    
    // 设置tableView相关高度
    self.tableView.sectionHeaderHeight = 1;
    self.tableView.sectionFooterHeight = 1;
    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.rowHeight = 80.0;
    
    // 注册cell
    [self.tableView registerNib:[FJNewsCell nib] forCellReuseIdentifier:NSStringFromClass([FJNewsCell class])];
}

// 跳转详情控制器
- (void)gotoDetailVC:(FJNews*)news
{
    FJDetailViewController* detailVC = [FJDetailViewController new];
    detailVC.news = news;
    detailVC.isPushInto = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FJNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FJNewsCell class]) forIndexPath:indexPath];
    
    FJNews* news = self.datas[indexPath.row];
    cell.news = news;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    // 跳转详情控制器
    [self gotoDetailVC:[self.datas objectAtIndex:indexPath.row]];
}

@end
