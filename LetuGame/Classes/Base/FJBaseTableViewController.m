//
//  FJBaseTableViewController.m
//  LetuGame
//
//  Created by admin on 2018/7/8.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJBaseTableViewController.h"

@interface FJBaseTableViewController ()

@end

@implementation FJBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.datas = [NSMutableArray array];
    
    // tableView 偏移20/64适配
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        self.tableView.contentInset = UIEdgeInsetsMake(iphoneX?84:64, 0, iphoneX?83:49, 0);
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
    }
    
    
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    self.view.backgroundColor = FJGlobalBG;
    self.tableView.backgroundColor = FJGlobalBG;
    
    self.tableView.sectionHeaderHeight = 1;
    self.tableView.sectionFooterHeight = 1;
    
    //去除tableview右侧滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
//    //去掉分割线
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dealloc
{
    DLog(@"---dealloc---");
}

@end
