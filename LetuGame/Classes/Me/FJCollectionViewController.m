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
            if (arr == nil || [arr isEqual:[NSNull null]] || arr.count<=0) {
                [strongSelf showRefreshStaus:@"没有新数据"];
                return ;
            }
            [strongSelf.datas removeAllObjects];
            NSArray* tempArr = [FJNews mj_objectArrayWithKeyValuesArray:arr];
            [strongSelf.datas addObjectsFromArray:tempArr];
            
            [strongSelf.tableView reloadData];
        } else {
            [strongSelf showRefreshStaus:@"刷新失败"];
        }
    } failure:^(NSError *error) {
        STRONGSELF
        DLog(@"error = %@", error);
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf showRefreshStaus:@"刷新失败，请检查网络"];
    }];
}

@end
