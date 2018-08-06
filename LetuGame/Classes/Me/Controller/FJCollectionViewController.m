//
//  FJCollectionViewController.m
//  LetuGame
//
//  Created by admin on 2018/7/18.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJCollectionViewController.h"

@interface FJCollectionViewController ()

@end

@implementation FJCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的收藏";
}

// 重写父类
- (void)loadNewDatas
{
    WEAKSELF
    [HttpTool fetchCollectionListWithType:@"news" Success:^(id retObj) {
        STRONGSELF
        DLog(@"retObj = %@", retObj);
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        
        NSDictionary* retDict = retObj;
        if ([retDict[@"code"] isEqualToString:@"1"]) {
            
            NSArray* arr = retDict[@"data"];
            NSArray* tempArr = [FJNews mj_objectArrayWithKeyValuesArray:arr];
            if (tempArr.count == 0) {
                return;
            }
            [strongSelf.datas removeAllObjects];
            [strongSelf.datas addObjectsFromArray:tempArr];
            [strongSelf.tableView reloadData];
        } else {
//            [strongSelf showRefreshStaus:@"刷新失败"];
//            [FJProgressHUB showErrorWithMessage:@"刷新失败" withTimeInterval:kTimeHubError];
        }
    } failure:^(NSError *error) {
        STRONGSELF
        DLog(@"error = %@", error);
        [strongSelf.tableView.mj_header endRefreshing];
//        [strongSelf showRefreshStaus:@"刷新失败，请检查网络"];
//        [FJProgressHUB showErrorWithMessage:@"刷新失败，请检查网络" withTimeInterval:kTimeHubError];
    }];
}

@end
