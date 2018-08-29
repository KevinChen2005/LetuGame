//
//  FJStrategyController.m
//  LetuGame
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJStrategyController.h"

#import "FJGame.h"

@interface FJStrategyController ()

@end

@implementation FJStrategyController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

// 重写父类
- (void)loadNewDatas
{
    NSInteger start = 0;
    NSInteger end = 20;
    
    [HttpTool fetchNewslistWithGameId:self.game.gameId StartId:start endId:end Success:^(id retObj){
        DLog(@"retObj = %@", retObj);
        [self.tableView.mj_header endRefreshing];
        
        NSDictionary* retDict = retObj;
        if ([retDict[@"code"] isEqualToString:@"1"]) {
            NSArray* arr = retDict[@"data"][@"newsList"];
            if (arr == nil || [arr isEqual:[NSNull null]] || arr.count <= 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                [self showRefreshStaus:@"没有更多数据"];
//                [FJProgressHUB showInfoWithMessage:@"没有更多数据" withTimeInterval:kTimeHubError];
                return;
            }
            [self.datas removeAllObjects];
            NSArray* tempArr = [FJNews mj_objectArrayWithKeyValuesArray:arr];
            [self.datas addObjectsFromArray:tempArr];
            
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        } else {
//            [self showRefreshStaus:@"刷新失败"];
//            [FJProgressHUB showErrorWithMessage:@"刷新失败" withTimeInterval:kTimeHubError];
        }
    } failure:^(NSError *error) {
        DLog(@"error = %@", error);
        [self.tableView.mj_header endRefreshing];
//        [self showRefreshStaus:@"刷新失败，请检查网络"];
//        [FJProgressHUB showErrorWithMessage:@"刷新失败，请检查网络" withTimeInterval:kTimeHubError];
    }];
}

- (void)loadMoreDatas
{
    static NSInteger start = 0;
    start = self.datas.count;
    NSInteger count = 20;
    NSInteger end = start + count;
    [HttpTool fetchNewslistWithGameId:self.game.gameId StartId:start endId:end Success:^(id retObj) {
        DLog(@"retObj = %@", retObj);
        
        NSDictionary* retDict = retObj;
        if ([retDict[@"code"] isEqualToString:@"1"]) {
            NSArray* arr = retDict[@"data"][@"newsList"];
            if (arr == nil || [arr isEqual:[NSNull null]] || arr.count <= 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                [FJProgressHUB showInfoWithMessage:@"没有更多数据" withTimeInterval:1.0f];
                return;
            }
            [self.tableView.mj_footer endRefreshing];
            NSArray* tempArr = [FJNews mj_objectArrayWithKeyValuesArray:arr];
            [self.datas addObjectsFromArray:tempArr];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        DLog(@"error = %@", error);
        [self.tableView.mj_footer endRefreshing];
    }];
}

@end
